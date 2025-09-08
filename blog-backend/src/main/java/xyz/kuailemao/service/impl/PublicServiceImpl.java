package xyz.kuailemao.service.impl;

import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import xyz.kuailemao.constants.RedisConst;
import xyz.kuailemao.domain.entity.WebsiteInfo;
import xyz.kuailemao.mapper.WebsiteInfoMapper;
import xyz.kuailemao.service.PublicService;
import xyz.kuailemao.utils.RedisCache;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * @author kuailemao
 * 公共服务实现类，负责准备并发送消息到队列
 */
@Slf4j
@Service
public class PublicServiceImpl implements PublicService {

    @Resource
    private RedisCache redisCache;

    @Resource
    private RabbitTemplate rabbitTemplate;

    @Resource
    private WebsiteInfoMapper websiteInfoMapper;

    @Value("${spring.rabbitmq.routingKey.email}")
    private String routingKey;

    @Value("${spring.rabbitmq.exchange.email}")
    private String exchange;

    /**
     * 发送邮箱验证码
     *
     * @param type  邮箱类型 (如: register, reset)
     * @param email 邮箱地址
     * @return 提示信息
     */
    @Override
    public String registerEmailVerifyCode(String type, String email) {
        // 使用 email 字符串的 intern() 方法作为锁对象，可以确保对同一个邮箱的操作是同步的
        synchronized (email.intern()) {
            // 1. 生成6位验证码
            String verifyCode = String.valueOf((int) ((Math.random() * 9 + 1) * 100000));
            // 2. 将验证码存入 Redis，设置5分钟过期
            redisCache.setCacheObject(RedisConst.VERIFY_CODE + type + RedisConst.SEPARATOR + email, verifyCode, RedisConst.VERIFY_CODE_EXPIRATION, TimeUnit.MINUTES);

            // 3. 准备发送到消息队列的数据包
            Map<String, Object> emailData = new HashMap<>();
            emailData.put("email", email);
            emailData.put("code", verifyCode);
            emailData.put("type", type);
            // 额外添加一些通用变量，供模板使用
            emailData.put("expirationTime", "5分钟");
            emailData.put("openSourceAddress", "https://gitee.com/kuailemao/ruyu-blog"); // 示例开源地址

            // 4. 将网站的动态信息添加到数据包中
            addWebsiteInfoToMap(emailData);

            // 5. 发送数据包到 RabbitMQ
            rabbitTemplate.convertAndSend(exchange, routingKey, emailData);

            return "验证码已发送，请注意查收！";
        }
    }

    /**
     * 发送通用的邮件通知
     *
     * @param type  邮件类型
     * @param email 邮箱地址
     * @param content 邮件内容相关的业务数据
     */
    @Override
    public void sendEmail(String type, String email, Map<String, Object> content) {
        // 确保 content 是一个可变的 Map
        Map<String, Object> emailData = (content != null) ? new HashMap<>(content) : new HashMap<>();
        emailData.put("email", email);
        emailData.put("type", type);

        // 将网站的动态信息添加到数据包中
        addWebsiteInfoToMap(emailData);

        // 发送数据包到 RabbitMQ
        rabbitTemplate.convertAndSend(exchange, routingKey, emailData);

        log.info("邮件通知任务已发送到队列，发送时间为：{}，类型：{}，邮箱：{}", new Date(), type, email);
    }

    /**
     * 从数据库查询网站信息，并将其添加到 Map 中
     * @param map 存储邮件参数的 Map
     */
    private void addWebsiteInfoToMap(Map<String, Object> map) {
        try {
            // 假设网站信息存储在 ID 为 1 的记录中
            WebsiteInfo websiteInfo = websiteInfoMapper.selectById(1L);
            if (websiteInfo != null) {
                map.put("webmasterAvatar", websiteInfo.getWebmasterAvatar());
                map.put("websiteName", websiteInfo.getWebsiteName());
                // 也可以添加其他网站信息
                // map.put("toUrl", websiteInfo.getWebsiteUrl());
            } else {
                log.warn("ID为1的网站信息未找到，邮件模板将使用默认值。");
                setDefaultWebsiteInfo(map);
            }
        } catch (Exception e) {
            log.error("查询网站信息时发生异常，邮件模板将使用默认值。", e);
            setDefaultWebsiteInfo(map);
        }
    }

    /**
     * 设置默认的网站信息，用于容错
     * @param map 存储邮件参数的 Map
     */
    private void setDefaultWebsiteInfo(Map<String, Object> map) {
        map.putIfAbsent("webmasterAvatar", "https://image.kuailemao.xyz/blog/websiteInfo/avatar/default.jpg"); // 替换成你的默认头像URL
        map.putIfAbsent("websiteName", "我的博客网站"); // 替换成你的默认网站名称
    }
}