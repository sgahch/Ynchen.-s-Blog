package xyz.kuailemao.aop;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import xyz.kuailemao.annotation.LogAnnotation;
import xyz.kuailemao.constants.FunctionConst;
import xyz.kuailemao.domain.entity.Log;
import xyz.kuailemao.domain.entity.User;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.mapper.UserMapper;
import xyz.kuailemao.utils.IpUtils;
import xyz.kuailemao.utils.SecurityUtils;

import java.lang.reflect.Method;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * @author kuailemao
 * <p>
 * 创建时间：2023/12/11 22:56
 * 操作日志aop (已使用 Jackson 重构)
 */
@Component
@Slf4j
@Aspect // 切面
public class LogAspect {

    @Resource
    private UserMapper userMapper;

    @Resource
    private RabbitTemplate rabbitTemplate;

    // 注入 Spring Boot 自动配置的 ObjectMapper
    @Resource
    private ObjectMapper objectMapper;

    @Value("${spring.rabbitmq.routingKey.log-system}")
    private String routingKey;

    @Value("${spring.rabbitmq.exchange.log}")
    private String exchange;

    /**
     * 切点，注解加在哪，哪就是切点
     */
    @Pointcut("@annotation(xyz.kuailemao.annotation.LogAnnotation)")
    public void pt() {
    }

    // 环绕通知，在方法执行前后执行
    @Around("pt()")
    public Object log(ProceedingJoinPoint joinPoint) throws Throwable {
        long beginTime = System.currentTimeMillis();
        try {
            // 执行方法
            Object result = joinPoint.proceed();
            // 执行时长
            long time = System.currentTimeMillis() - beginTime;
            recordLog(joinPoint, time, result);
            return result;
        } catch (Throwable e) {
            long time = System.currentTimeMillis() - beginTime;
            // 记录异常日志
            recordExceptionLog(joinPoint, time, e);
            // 这里一定要重新抛出去，不然全局异常处理器会失效
            throw e;
        }
    }

    /**
     * 记录正常操作日志
     */
    private void recordLog(ProceedingJoinPoint joinPoint, long time, Object result) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        LogAnnotation logAnnotation = method.getAnnotation(LogAnnotation.class);
        Operation operation = method.getAnnotation(Operation.class);

        HttpServletRequest request = SecurityUtils.getCurrentHttpRequest();
        if (request == null) {
            log.warn("无法获取 HttpServletRequest,跳过日志记录");
            return;
        }

        String ipAddr = IpUtils.getIpAddr(request);
        User user = userMapper.selectById(SecurityUtils.getUserId());
        String userName = (user != null) ? user.getUsername() : FunctionConst.UNKNOWN_USER;

        Log logEntity = Log.builder()
                .module(logAnnotation.module())
                .operation(logAnnotation.operation())
                .ip(ipAddr)
                .description(operation != null ? operation.summary() : "")
                .reqMapping(request.getMethod())
                .userName(userName)
                .method(joinPoint.getTarget().getClass().getName() + "." + signature.getName() + "()")
                .reqParameter(convertArgsToJson(joinPoint.getArgs()))
                .returnParameter(convertObjectToJson(result))
                .reqAddress(request.getRequestURI())
                .time(time)
                .build();

        // 根据返回结果设置日志状态
        if (result instanceof ResponseResult) {
            ResponseResult<?> responseResult = (ResponseResult<?>) result;
            logEntity.setState(responseResult.getCode() == 200 ? 0 : 1);
        } else {
            // 如果返回值不是 ResponseResult 类型，默认为成功
            logEntity.setState(0);
        }

        rabbitTemplate.convertAndSend(exchange, routingKey, logEntity);
    }

    /**
     * 记录异常日志
     */
    private void recordExceptionLog(ProceedingJoinPoint joinPoint, long time, Throwable e) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        LogAnnotation logAnnotation = method.getAnnotation(LogAnnotation.class);

        HttpServletRequest request = SecurityUtils.getCurrentHttpRequest();
        if (request == null) {
            log.error("无法获取 HttpServletRequest,异常日志记录不完整", e);
            return;
        }

        String ipAddr = IpUtils.getIpAddr(request);
        User user = userMapper.selectById(SecurityUtils.getUserId());
        String userName = (user != null) ? user.getUsername() : FunctionConst.UNKNOWN_USER;

        Log logEntity = Log.builder()
                .module(logAnnotation.module())
                .operation(logAnnotation.operation())
                .ip(ipAddr)
                .exception(e.toString()) // 记录更详细的异常信息
                .reqMapping(request.getMethod())
                .userName(userName)
                .state(2) // 状态2表示异常
                .method(joinPoint.getTarget().getClass().getName() + "." + signature.getName() + "()")
                .reqParameter(convertArgsToJson(joinPoint.getArgs()))
                .reqAddress(request.getRequestURI())
                .time(time)
                .build();

        rabbitTemplate.convertAndSend(exchange, routingKey, logEntity);
        log.error("执行方法 [{}] 异常", signature.getName(), e);
    }

    /**
     * 将方法参数数组转换为 JSON 字符串。
     * 会过滤掉不可序列化的类型，如 MultipartFile, HttpServletRequest 等。
     */
    private String convertArgsToJson(Object[] args) {
        if (args == null || args.length == 0) {
            return "[]";
        }
        // 过滤掉不能被序列化的参数
        List<Object> serializableArgs = Stream.of(args)
                .filter(arg -> !(arg instanceof MultipartFile) &&
                        !(arg instanceof HttpServletRequest) &&
                        !(arg instanceof HttpServletResponse))
                .collect(Collectors.toList());

        // 如果过滤后没有参数，也返回一个标记
        if (serializableArgs.isEmpty()) {
            return "[Filtered]";
        }

        return convertObjectToJson(serializableArgs);
    }

    /**
     * 通用的对象转 JSON 字符串方法，处理序列化异常
     */
    private String convertObjectToJson(Object object) {
        if (object == null) {
            return "null";
        }
        try {
            return objectMapper.writeValueAsString(object);
        } catch (JsonProcessingException e) {
            log.warn("序列化对象到 JSON 失败: {}", e.getMessage());
            return "[Serialization Failed]";
        }
    }
}