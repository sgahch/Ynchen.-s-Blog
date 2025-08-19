package xyz.kuailemao.quartz;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import jakarta.annotation.Resource;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.quartz.JobExecutionContext;
import org.springframework.scheduling.quartz.QuartzJobBean;
import xyz.kuailemao.constants.RedisConst;
import xyz.kuailemao.domain.entity.Article;
import xyz.kuailemao.mapper.ArticleMapper;
import xyz.kuailemao.utils.RedisCache;

import java.util.List;
import java.util.Objects;

@Slf4j
public class RefreshTheCache extends QuartzJobBean {

    @Resource
    private ArticleMapper articleMapper;

    @Resource
    private RedisCache redisCache;

    @Override
    protected void executeInternal(@NonNull JobExecutionContext context) {
        log.info("-------------------------------开始同步文章浏览量到数据库-------------------------------");
        try {
            // 1. 从数据库获取所有当前有效的文章ID
            List<Long> articleIds = articleMapper.selectList(null).stream().map(Article::getId).toList();

            // 2. 遍历每个文章ID，尝试从Redis同步数据
            articleIds.forEach(id -> {
                String redisKey = RedisConst.ARTICLE_VISIT_COUNT + id;
                Object rawViewCount = redisCache.getCacheObject(redisKey);

                // 3. 【核心】只有当Redis中存在有效值时才进行处理
                if (Objects.nonNull(rawViewCount)) {
                    try {
                        // 4. 安全地将Object转换为Long，兼容Integer, Long等数字类型
                        if (rawViewCount instanceof Number) {
                            long visitCount = ((Number) rawViewCount).longValue();

                            // 5. 更新数据库
                            articleMapper.update(null, new LambdaUpdateWrapper<Article>()
                                    .eq(Article::getId, id)
                                    .set(Article::getVisitCount, visitCount));
                        } else {
                            // 记录日志：发现了类型不匹配的脏数据
                            log.warn("在Redis中发现脏数据：键 '{}' 的值不是数字类型，其值为: {}", redisKey, rawViewCount);
                        }
                    } catch (Exception e) {
                        // 记录日志：处理单个ID时发生未知异常，但不会中断整个任务
                        log.error("同步文章ID '{}' 的浏览量时发生异常。", id, e);
                    }
                }
                // 如果rawViewCount为null，则静默跳过，这是正常行为。
            });
            log.info("-------------------------------同步文章浏览量成功-------------------------------");
        } catch (Exception e) {
            // 记录日志：整个同步任务发生严重错误
            log.error("同步文章浏览量任务失败", e);
        }
    }
}