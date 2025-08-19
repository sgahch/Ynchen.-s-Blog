package xyz.kuailemao.cache;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;

import java.util.Collection;
import java.util.Collections;

@Slf4j
public class CompositeCacheManager implements CacheManager {

    private final CacheManager caffeineCacheManager;
    private final CacheManager redisCacheManager;

    public CompositeCacheManager(CacheManager caffeineCacheManager, CacheManager redisCacheManager) {
        this.caffeineCacheManager = caffeineCacheManager;
        this.redisCacheManager = redisCacheManager;
    }

    @Override
    public Cache getCache(String name) {
        log.info(">>>>>> CompositeCacheManager正在为缓存 '{}' 创建CompositeCache实例 <<<<<<", name);

        Cache caffeineCache = caffeineCacheManager.getCache(name);
        Cache redisCache = redisCacheManager.getCache(name);
        // 返回我们自定义的 CompositeCache 实例
        return new CompositeCache(caffeineCache, redisCache);
    }

    @Override
    public Collection<String> getCacheNames() {
        return Collections.emptyList(); // 可以根据需要实现
    }
}