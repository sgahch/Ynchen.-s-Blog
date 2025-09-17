package xyz.kuailemao.config;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary; // 确保导入了这个包
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {

    /**
     * 最终的、唯一正确的解决方案：
     * 创建一个配置了“自由模式”类型验证器的 GenericJackson2JsonRedisSerializer。
     * 1. LaissezFaireSubTypeValidator.instance: 这是一个“万能钥匙”，它允许任何我们自己定义的Java类（如PageVO, TagVO等）被序列化时附带类型信息。
     * 2. ObjectMapper.DefaultTyping.NON_FINAL: 指定为所有非final的类（这包括了我们所有的VO和集合类）添加类型信息。
     * 3. JsonTypeInfo.As.PROPERTY: 指示类型信息将作为一个名为"@class"的属性写入JSON中。
     * 这个配置组合确保了无论是什么对象，存入Redis时都自带“身份说明”，从而彻底杜绝了反序列化时的类型混淆和ClassCastException。
     */
    @Bean
    public GenericJackson2JsonRedisSerializer genericJackson2JsonRedisSerializer() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.activateDefaultTyping(
                LaissezFaireSubTypeValidator.instance,
                ObjectMapper.DefaultTyping.NON_FINAL,
                JsonTypeInfo.As.PROPERTY
        );
        return new GenericJackson2JsonRedisSerializer(objectMapper);
    }

    /**
     * 配置 RedisTemplate，注入并使用上面创建的、最终正确的序列化器。
     * 添加 @Primary 注解，确保这是默认的、首选的 RedisTemplate 实例。
     */
    @Bean
    @Primary // <== 添加 @Primary 注解，消除注入歧义
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory, GenericJackson2JsonRedisSerializer genericJackson2JsonRedisSerializer) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);

        StringRedisSerializer stringSerializer = new StringRedisSerializer();

        template.setKeySerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);
        template.setValueSerializer(genericJackson2JsonRedisSerializer);
        template.setHashValueSerializer(genericJackson2JsonRedisSerializer);

        template.afterPropertiesSet();
        return template;
    }
}