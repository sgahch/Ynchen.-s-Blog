-- 读取桶的状态
local rate = tonumber(redis.call('HGET', KEYS[1], 'rate'))
local capacity = tonumber(redis.call('HGET', KEYS[1], 'capacity'))
local tokens = tonumber(redis.call('HGET', KEYS[1], 'tokens'))
local timestamp = tonumber(redis.call('HGET', KEYS[1], 'timestamp'))

-- 计算应该生成的令牌数量
local now = redis.call('TIME')
local elapsed = now[1] - timestamp
local generated = math.floor(elapsed * rate)

-- 更新令牌数量并限制桶的容量
tokens = math.min(capacity, tokens + generated)

-- 执行操作
local required = tonumber(ARGV[1])
if tokens >= required then
    tokens = tokens - required
    redis.call('HSET', KEYS[1], 'tokens', tokens)
    redis.call('HSET', KEYS[1], 'timestamp', now[1])
    return 1
else
    return 0
end