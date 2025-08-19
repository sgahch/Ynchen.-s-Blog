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
import xyz.kuailemao.cache.CompositeCacheManager; // 这是我们需要自己创建的类

import java.time.Duration;
import java.util.concurrent.TimeUnit;

@Configuration
public class CompositeCacheConfig {

    /**
     * 配置一级缓存 Caffeine Cache Manager
     */
    @Bean("caffeineCacheManager")
    public CacheManager caffeineCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .initialCapacity(128) // 初始大小
                .maximumSize(1024)    // 最大数量
                .expireAfterWrite(10, TimeUnit.MINUTES)); // 过期时间
        return cacheManager;
    }

    /**
     * 配置二级缓存 Redis Cache Manager
     */
    @Bean("redisCacheManager")
    public CacheManager redisCacheManager(RedisConnectionFactory connectionFactory) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1)) // 默认1小时过期
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(config)
                .build();
    }

    /**
     * 配置最终的复合缓存管理器
     * @Primary 注解表示当有多个CacheManager时，默认使用这个
     */
    @Primary
    @Bean("compositeCacheManager")
    public CacheManager cacheManager(CacheManager caffeineCacheManager, CacheManager redisCacheManager) {
        return new CompositeCacheManager(caffeineCacheManager, redisCacheManager);
    }
}