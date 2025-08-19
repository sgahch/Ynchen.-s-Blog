package xyz.kuailemao.config;

import com.alibaba.fastjson.support.spring.FastJsonRedisSerializer;
import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import xyz.kuailemao.cache.CompositeCacheManager;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

@Configuration
public class CompositeCacheConfig {

    /**
     * 配置一级缓存 Caffeine Cache Manager
     */
    @Bean
    public CacheManager caffeineCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .initialCapacity(128)
                .maximumSize(1024)
                .expireAfterWrite(10, TimeUnit.MINUTES));
        return cacheManager;
    }

    /**
     * 配置二级缓存 Redis Cache Manager
     * 关键：将值序列化器从 Jackson 替换为 FastJSON
     */
    @Bean
    public CacheManager redisCacheManager(RedisConnectionFactory connectionFactory) {
        // 创建我们期望使用的 FastJSON 序列化器
        FastJsonRedisSerializer<Object> fastJsonSerializer = new FastJsonRedisSerializer<>(Object.class);

        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                // !!! 核心修改：使用 FastJSON 序列化值 !!!
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(fastJsonSerializer))
                .disableCachingNullValues();

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(config)
                .build();
    }

    /**
     * 配置最终的复合缓存管理器
     * @Primary 注解确保 @Cacheable 默认使用此管理器
     */
    @Primary
    @Bean
    public CacheManager cacheManager(CacheManager caffeineCacheManager, CacheManager redisCacheManager) {
        return new CompositeCacheManager(caffeineCacheManager, redisCacheManager);
    }
}