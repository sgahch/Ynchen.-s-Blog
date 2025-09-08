//package xyz.kuailemao.config;
//
//// 1. 移除 fastjson 的 import
//// import com.alibaba.fastjson.support.spring.FastJsonRedisSerializer;
//
//import com.fasterxml.jackson.annotation.JsonAutoDetect;
//import com.fasterxml.jackson.annotation.PropertyAccessor;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
//import com.github.benmanes.caffeine.cache.Caffeine;
//import org.springframework.cache.CacheManager;
//import org.springframework.cache.caffeine.CaffeineCacheManager;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.context.annotation.Primary;
//import org.springframework.data.redis.cache.RedisCacheConfiguration;
//import org.springframework.data.redis.cache.RedisCacheManager;
//import org.springframework.data.redis.connection.RedisConnectionFactory;
//import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
//import org.springframework.data.redis.serializer.RedisSerializationContext;
//import org.springframework.data.redis.serializer.StringRedisSerializer;
//import xyz.kuailemao.cache.CompositeCacheManager;
//
//import java.time.Duration;
//import java.util.concurrent.TimeUnit;
//
//@Configuration
//public class CompositeCacheConfig {
//
//    /**
//     * 配置一级缓存 Caffeine Cache Manager
//     * (这部分保持不变)
//     */
//    @Bean
//    public CacheManager caffeineCacheManager() {
//        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
//        cacheManager.setCaffeine(Caffeine.newBuilder()
//                .initialCapacity(128)
//                .maximumSize(1024)
//                .expireAfterWrite(10, TimeUnit.MINUTES));
//        return cacheManager;
//    }
//
//    /**
//     * 配置二级缓存 Redis Cache Manager
//     * 关键：将值序列化器从 FastJSON 替换为我们统一配置的 Jackson
//     */
//    @Bean
//    public CacheManager redisCacheManager(RedisConnectionFactory connectionFactory) {
//
//        // 2. 创建并配置 Jackson 序列化器
//        // 这里的配置必须与 RedisConfig.java 中的完全一致，以保证数据格式统一
//        ObjectMapper om = new ObjectMapper();
//        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
//        om.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);
//        Jackson2JsonRedisSerializer<Object> jacksonSerializer = new Jackson2JsonRedisSerializer<>(om, Object.class);
//
//        // 3. 使用新的 Jackson 序列化器来构建 RedisCacheConfiguration
//        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
//                // 设置缓存的默认过期时间为1小时
//                .entryTtl(Duration.ofHours(1))
//                // 配置 Key 的序列化方式为 String
//                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
//                // !!! 核心修改：使用 Jackson 序列化值 !!!
//                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(jacksonSerializer))
//                // 禁用缓存 null 值
//                .disableCachingNullValues();
//
//        return RedisCacheManager.builder(connectionFactory)
//                .cacheDefaults(config)
//                .build();
//    }
//
//    /**
//     * 配置最终的复合缓存管理器
//     * @Primary 注解确保 @Cacheable 默认使用此管理器
//     * (这部分保持不变)
//     */
//    @Primary
//    @Bean
//    public CacheManager cacheManager(CacheManager caffeineCacheManager, CacheManager redisCacheManager) {
//        return new CompositeCacheManager(caffeineCacheManager, redisCacheManager);
//    }
//}
package xyz.kuailemao.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import xyz.kuailemao.cache.CompositeCacheManager;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

@Configuration
public class CompositeCacheConfig {

    @Bean
    public CacheManager caffeineCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .initialCapacity(128)
                .maximumSize(1024)
                .expireAfterWrite(10, TimeUnit.MINUTES));
        return cacheManager;
    }

    @Bean
    public CacheManager redisCacheManager(RedisConnectionFactory connectionFactory, GenericJackson2JsonRedisSerializer genericJackson2JsonRedisSerializer) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(genericJackson2JsonRedisSerializer))
                .disableCachingNullValues();
        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(config)
                .build();
    }

    @Primary
    @Bean
    public CacheManager cacheManager(CacheManager caffeineCacheManager, CacheManager redisCacheManager) {
        return new CompositeCacheManager(caffeineCacheManager, redisCacheManager);
    }
}