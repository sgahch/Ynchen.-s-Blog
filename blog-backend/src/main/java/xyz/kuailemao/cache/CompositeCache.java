package xyz.kuailemao.cache;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.Cache;
import org.springframework.cache.support.SimpleValueWrapper;
import org.springframework.lang.Nullable;

import java.util.Objects;
import java.util.concurrent.Callable;

/**
 * 复合缓存实现 (L1 + L2)
 * 实现了Spring的Cache接口，用于组合Caffeine（一级缓存）和Redis（二级缓存）。
 */
@Slf4j
public class CompositeCache implements Cache {

    private final Cache caffeineCache;
    private final Cache redisCache;

    public CompositeCache(Cache caffeineCache, Cache redisCache) {
        Objects.requireNonNull(caffeineCache, "一级缓存(Caffeine)不能为空");
        Objects.requireNonNull(redisCache, "二级缓存(Redis)不能为空");
        this.caffeineCache = caffeineCache;
        this.redisCache = redisCache;
    }

    @Override
    public String getName() {
        return caffeineCache.getName();
    }

    @Override
    public Object getNativeCache() {
        // 返回自身，因为这是一个自定义的复合实现
        return this;
    }

    /**
     * 核心的读操作：先查L1，再查L2
     */
    @Override
    @Nullable
    public ValueWrapper get(Object key) {
        // 1. 先从一级缓存 Caffeine 中获取
        ValueWrapper valueWrapper = caffeineCache.get(key);
        if (valueWrapper != null) {
            log.info("=========== 命中一级缓存(Caffeine): {} ============", key.toString());
            return valueWrapper;
        }

        // 2. 如果一级缓存没有，再从二级缓存 Redis 中获取
        valueWrapper = redisCache.get(key);
        if (valueWrapper != null) {
            log.info("=========== 命中二级缓存(Redis), 回填一级缓存: {} ============", key.toString());
            // 将从Redis获取的数据，异步回填到Caffeine中
            // (这里的put是同步的，对于高性能要求可以考虑异步化)
            caffeineCache.put(key, valueWrapper.get());
        }
        return valueWrapper;
    }

    /**
     * 带类型转换的读操作
     */
    @Override
    @Nullable
    public <T> T get(Object key, @Nullable Class<T> type) {
        // 优先从一级缓存获取
        T value = caffeineCache.get(key, type);
        if (value != null) {
            log.info("=========== 命中一级缓存(Caffeine): {} ============", key.toString());
            return value;
        }

        // 再从二级缓存获取
        value = redisCache.get(key, type);
        if (value != null) {
            log.info("=========== 命中二级缓存(Redis), 回填一级缓存: {} ============", key.toString());
            caffeineCache.put(key, value);
        }
        return value;
    }

    /**
     * 支持 "cache-aside" 模式的读操作
     * (如果缓存不存在，则执行 valueLoader 从数据源加载数据)
     */
    @Override
    @Nullable
    public <T> T get(Object key, Callable<T> valueLoader) {
        // 尝试从缓存中获取
        ValueWrapper valueWrapper = get(key);
        if (valueWrapper != null) {
            return (T) valueWrapper.get();
        }

        // 缓存中没有，执行加载逻辑
        // 使用锁来防止缓存击穿 (多个线程同时加载同一数据)
        synchronized (key.toString().intern()) {
            // 双重检查锁定 (Double-Checked Locking)
            valueWrapper = get(key);
            if (valueWrapper != null) {
                return (T) valueWrapper.get();
            }

            // 从数据源加载数据
            T value;
            try {
                value = valueLoader.call();
            } catch (Exception e) {
                throw new ValueRetrievalException(key, valueLoader, e);
            }

            // 将加载到的数据放入缓存
            put(key, value);
            return value;
        }
    }

    /**
     * 核心的写操作：同时写入 L1 和 L2
     */
    @Override
    public void put(Object key, @Nullable Object value) {
        log.info("=========== 写入二级缓存(Redis): {} ============", key.toString());
        redisCache.put(key, value);
        log.info("=========== 写入一级缓存(Caffeine): {} ============", key.toString());
        caffeineCache.put(key, value);
    }

    /**
     * 核心的删除操作：同时删除 L1 和 L2
     */
    @Override
    public void evict(Object key) {
        log.warn("=========== 清除二级缓存(Redis): {} ============", key.toString());
        // 先删除远程的Redis缓存，再删除本地的Caffeine缓存，保证最终一致性
        redisCache.evict(key);
        log.warn("=========== 清除一级缓存(Caffeine): {} ============", key.toString());
        caffeineCache.evict(key);
    }

    /**
     * 核心的清空操作：同时清空 L1 和 L2
     */
    @Override
    public void clear() {
        log.warn("=========== 清空二级缓存(Redis) ============");
        redisCache.clear();
        log.warn("=========== 清空一级缓存(Caffeine) ============");
        caffeineCache.clear();
    }
}
