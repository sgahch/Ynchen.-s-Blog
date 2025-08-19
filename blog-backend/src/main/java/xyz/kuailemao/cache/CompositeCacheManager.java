package xyz.kuailemao.cache;

import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;

import java.util.Collection;
import java.util.Collections;

public class CompositeCacheManager implements CacheManager {

    private final CacheManager caffeineCacheManager;
    private final CacheManager redisCacheManager;

    public CompositeCacheManager(CacheManager caffeineCacheManager, CacheManager redisCacheManager) {
        this.caffeineCacheManager = caffeineCacheManager;
        this.redisCacheManager = redisCacheManager;
    }

    @Override
    public Cache getCache(String name) {
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