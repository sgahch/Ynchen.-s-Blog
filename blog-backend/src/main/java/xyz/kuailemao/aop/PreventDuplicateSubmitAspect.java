package xyz.kuailemao.aop;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import xyz.kuailemao.annotation.PreventDuplicateSubmit;
import xyz.kuailemao.exceptions.DuplicateSubmitException; // 这是一个需要您自己创建的自定义异常
import xyz.kuailemao.utils.SecurityUtils;

import java.util.Objects;


@Slf4j
@Aspect
@Component
public class PreventDuplicateSubmitAspect {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    /**
     * 定义切点，拦截所有使用了 @PreventDuplicateSubmit 注解的方法
     */
    @Around("@annotation(preventDuplicateSubmit)")
    public Object around(ProceedingJoinPoint joinPoint, PreventDuplicateSubmit preventDuplicateSubmit) throws Throwable {

        HttpServletRequest request = ((ServletRequestAttributes) Objects.requireNonNull(RequestContextHolder.getRequestAttributes())).getRequest();

        // 1. 生成唯一的Key
        // Key的构成：用户ID + 请求URI + 方法签名
        // 这样可以确保同一个用户对同一个接口的多次请求被识别
        String userId = String.valueOf(SecurityUtils.getUserId());
        String requestURI = request.getRequestURI();
        String methodName = joinPoint.getSignature().toLongString();
        String redisKey = "prevent_duplicate_submit:" + userId + ":" + requestURI + ":" + methodName;

        // 2. 尝试向Redis设置这个Key
        // setIfAbsent 是一个原子操作，如果key不存在，则设置并返回true；如果key已存在，则不设置并返回false
        Boolean isSuccess = stringRedisTemplate.opsForValue().setIfAbsent(
                redisKey,
                "1", // 随便放一个值，代表占位
                preventDuplicateSubmit.expire(),
                preventDuplicateSubmit.timeUnit()
        );

        // 3. 判断结果
        if (Boolean.TRUE.equals(isSuccess)) {
            // 设置成功，说明是第一次请求，放行
            log.info("[防重] 请求通过: {}", redisKey);
            // 执行目标方法
            return joinPoint.proceed();
        } else {
            // 设置失败，说明是重复请求，抛出异常
            log.warn("[防重] 拦截到重复请求: {}", redisKey);
            // 抛出一个自定义异常，由全局异常处理器来处理并返回给前端
            throw new DuplicateSubmitException(preventDuplicateSubmit.message());
        }
    }
}