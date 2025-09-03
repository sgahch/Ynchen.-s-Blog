package xyz.kuailemao.config;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);

        // 1. 创建并配置 ObjectMapper
        ObjectMapper om = new ObjectMapper();
        // 指定要序列化的域(field,get,set)，以及修饰符范围(ANY是包括private和public)
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        // 关键配置：指定序列化输入的类型，类必须是非final修饰的。
        // LaissezFaireSubTypeValidator.instance 是一个宽松的类型验证器, 允许任何类型
        om.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);

        // 2. 使用配置好的 ObjectMapper 创建 Jackson2JsonRedisSerializer
        //    这是修复“方法过时”警告和类型转换异常的关键！
        //    我们不再使用 setObjectMapper() 方法，而是直接通过构造函数传入。
        Jackson2JsonRedisSerializer<Object> jacksonSerializer = new Jackson2JsonRedisSerializer<>(om, Object.class);

        // 3. 配置 RedisTemplate 的序列化器
        StringRedisSerializer stringSerializer = new StringRedisSerializer();

        // Key 和 Hash-Key 都使用 String 序列化
        template.setKeySerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);

        // Value 和 Hash-Value 都使用我们配置好的 Jackson 序列化
        template.setValueSerializer(jacksonSerializer);
        template.setHashValueSerializer(jacksonSerializer);

        template.afterPropertiesSet();
        return template;
    }
}