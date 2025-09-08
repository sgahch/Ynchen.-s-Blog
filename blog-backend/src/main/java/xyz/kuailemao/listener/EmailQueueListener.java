package xyz.kuailemao.listener;

import jakarta.annotation.Resource;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import xyz.kuailemao.constants.RabbitConst;
import java.util.Map;

/**
 * @author kuailemao
 * 邮件队列消费者，负责监听并处理邮件发送任务
 */
@Component
@Slf4j
public class EmailQueueListener {

    @Resource
    private JavaMailSender javaMailSender;

    @Resource
    private TemplateEngine templateEngine;

    @Value("${spring.mail.username}")
    private String fromEmail;

    /**
     * 监听邮件队列
     * @param data 从队列中收到的包含所有邮件信息的 Map
     */
    @RabbitListener(queues = RabbitConst.MAIL_QUEUE)
    public void handlerEmailQueue(Map<String, Object> data) {
        if (data == null || data.isEmpty()) {
            log.warn("从邮件队列收到空消息，已忽略");
            return;
        }

        String toEmail = (String) data.get("email");
        String type = (String) data.get("type");
        if (toEmail == null || type == null) {
            log.error("邮件消息缺少必要的'email'或'type'字段: {}", data);
            return;
        }

        // 1. 根据类型选择模板
        String templateName = getTemplateNameByType(type);
        if (templateName == null) {
            log.error("未知的邮件类型: {}，无法找到对应的模板", type);
            return;
        }

        try {
            // 2. 准备 Thymeleaf 上下文
            Context context = new Context();
            context.setVariables(data);

            // ==================== 诊断日志开始 ====================
            log.info("==================== 邮件发送诊断开始 ====================");
            log.info("准备渲染的模板文件: {}", templateName);
            log.info("传递给模板的完整数据 (Context): {}", data);
            log.info("从 Context 中获取到的 webmasterAvatar: {}", data.get("webmasterAvatar"));
            log.info("从 Context 中获取到的 websiteName: {}", data.get("websiteName"));
            // ==================== 诊断日志结束 ====================

            // 3. 使用模板引擎渲染（Thymeleaf会自动处理布局和片段的替换）
            String emailContent = templateEngine.process(templateName, context);

            // ==================== 诊断日志开始 ====================
            log.info("Thymeleaf 渲染后的 HTML 内容 (前500字符): {}...", emailContent.substring(0, Math.min(emailContent.length(), 500)));
            log.info("==================== 邮件发送诊断结束 ====================");
            // ==================== 诊断日志结束 ====================

            // 4. 创建并发送邮件
            MimeMessage mimeMessage = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject(getSubjectByType(type, data));
            helper.setText(emailContent, true);

            javaMailSender.send(mimeMessage);
            log.info("邮件发送成功: to={}, type={}", toEmail, type);

        } catch (Exception e) {
            log.error("邮件发送或渲染过程中发生严重异常: to={}, type={}", toEmail, type, e);
        }
    }

    /**
     * 根据邮件类型获取模板文件名
     */
    private String getTemplateNameByType(String type) {
        // 您需要根据您的业务，在这里把所有邮件类型和模板文件的映射关系都补全
        return switch (type) {
            case "register" -> "register-email-template";
            case "reset" -> "reset-password-template";
            case "reset_email" -> "reset-email-template";
            case "comment" -> "comment-email-template";
            case "reply_comment" -> "reply-comment-email-template";
            case "link_apply" -> "link-email-template";
            case "link_pass" -> "email-getThrough-template";
            case "message" -> "message-email-template";
            default -> null;
        };
    }

    /**
     * 根据邮件类型获取邮件主题
     */
    private String getSubjectByType(String type, Map<String, Object> data) {
        String websiteName = (String) data.getOrDefault("websiteName", "系统通知");
        // 您需要根据您的业务，在这里把所有邮件类型和主题的映射关系都补全
        return switch (type) {
            case "register" -> "【" + websiteName + "】欢迎注册！邮箱验证";
            case "reset" -> "【" + websiteName + "】密码重置验证";
            case "reset_email" -> "【" + websiteName + "】邮箱修改验证";
            case "comment" -> "【" + websiteName + "】您收到了新的评论！";
            case "reply_comment" -> "【" + websiteName + "】您的评论收到了新的回复！";
            case "link_apply" -> "【" + websiteName + "】您有新的友链申请！";
            case "link_pass" -> "【" + websiteName + "】您的友链申请已通过！";
            case "message" -> "【" + websiteName + "】您收到了新的留言！";
            default -> websiteName + " - 邮件通知";
        };
    }
}