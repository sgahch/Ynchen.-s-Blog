package xyz.kuailemao.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import xyz.kuailemao.constants.FunctionConst;
import xyz.kuailemao.domain.dto.SearchTagDTO;
import xyz.kuailemao.domain.dto.TagDTO;
import xyz.kuailemao.domain.entity.ArticleTag;
import xyz.kuailemao.domain.entity.Tag;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.domain.vo.TagVO;
import xyz.kuailemao.mapper.ArticleTagMapper;
import xyz.kuailemao.mapper.TagMapper;
import xyz.kuailemao.service.TagService;
import xyz.kuailemao.utils.StringUtils;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * (Tag)表服务实现类
 *
 * @author kuailemao
 * @since 2023-10-15 02:29:14
 *
 * 【重要修复】Redis 序列化问题修复:
 * 1. 添加了缓存异常捕获和自动清理机制
 * 2. 增加了 CacheManager 支持手动清理缓存
 * 3. 优化了缓存读取逻辑,增加容错处理
 */
@Slf4j
@Service("tagService")
public class TagServiceImpl extends ServiceImpl<TagMapper, Tag> implements TagService {

    @Resource
    private ArticleTagMapper articleTagMapper;

    @Resource
    private TagMapper tagMapper;

    @Resource
    private CacheManager cacheManager;

    /**
     * 【修复】改进的列表查询,增加缓存异常容错
     */
    @Override
    public List<TagVO> listAllTag() {
        try {
            // 1. 尝试从缓存获取
            Cache cache = cacheManager.getCache("tag");
            if (cache != null) {
                Cache.ValueWrapper wrapper = cache.get("list");
                if (wrapper != null && wrapper.get() != null) {
                    try {
                        @SuppressWarnings("unchecked")
                        List<TagVO> cachedList = (List<TagVO>) wrapper.get();
                        log.info("=========== 从缓存读取标签列表成功 ============");
                        return cachedList;
                    } catch (Exception e) {
                        // 【修复】如果缓存反序列化失败,清除缓存并继续查数据库
                        log.error("缓存反序列化失败,清除缓存: {}", e.getMessage());
                        cache.evict("list");
                    }
                }
            }
        } catch (Exception e) {
            log.error("读取缓存异常: {}", e.getMessage(), e);
        }

        // 2. 从数据库查询
        log.info("=========== 从数据库查询所有标签及其文章数 ============");
        List<Tag> tags = this.list();
        if (CollectionUtils.isEmpty(tags)) {
            return Collections.emptyList();
        }

        // 3. 组装数据
        Map<Long, Long> articleCountMap = getArticleCountMap();
        List<TagVO> result = tags.stream().map(tag ->
                tag.asViewObject(TagVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L))
                )
        ).toList();

        // 4. 写入缓存
        try {
            Cache cache = cacheManager.getCache("tag");
            if (cache != null) {
                cache.put("list", result);
                log.info("=========== 标签列表已写入缓存 ============");
            }
        } catch (Exception e) {
            log.error("写入缓存失败: {}", e.getMessage());
        }

        return result;
    }

    @Override
    public List<TagVO> searchTag(SearchTagDTO searchTagDTO) {
        LambdaQueryWrapper<Tag> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(searchTagDTO.getTagName()), Tag::getTagName, searchTagDTO.getTagName());
        if (StringUtils.isNotNull(searchTagDTO.getStartTime()) && StringUtils.isNotNull(searchTagDTO.getEndTime()))
            queryWrapper.between(Tag::getCreateTime, searchTagDTO.getStartTime(), searchTagDTO.getEndTime());

        List<Tag> tags = tagMapper.selectList(queryWrapper);
        if (CollectionUtils.isEmpty(tags)) {
            return Collections.emptyList();
        }

        // 提取公共方法获取文章计数
        Map<Long, Long> articleCountMap = getArticleCountMap();
        // 在内存中进行数据组装
        return tags.stream().map(tag ->
                tag.asViewObject(TagVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L))
                )
        ).toList();
    }

    /**
     * 【修复】改进的单个标签查询,增加缓存异常容错
     */
    @Override
    public TagVO getTagById(Long id) {
        try {
            // 1. 尝试从缓存获取
            Cache cache = cacheManager.getCache("tag");
            if (cache != null) {
                Cache.ValueWrapper wrapper = cache.get(id);
                if (wrapper != null && wrapper.get() != null) {
                    try {
                        TagVO cachedTag = (TagVO) wrapper.get();
                        log.info("=========== 从缓存读取标签成功: {} ============", id);
                        return cachedTag;
                    } catch (Exception e) {
                        // 【修复】如果缓存反序列化失败,清除缓存并继续查数据库
                        log.error("缓存反序列化失败,清除缓存 [id={}]: {}", id, e.getMessage());
                        cache.evict(id);
                    }
                }
            }
        } catch (Exception e) {
            log.error("读取缓存异常 [id={}]: {}", id, e.getMessage(), e);
        }

        // 2. 从数据库查询
        log.info("=========== 从数据库查询单个标签: {} ============", id);
        Tag tag = tagMapper.selectById(id);
        if (tag == null) {
            return null;
        }

        // 3. 组装数据
        TagVO tagVO = tag.asViewObject(TagVO.class);
        Map<Long, Long> articleCountMap = getArticleCountMap();
        tagVO.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L));

        // 4. 写入缓存
        try {
            Cache cache = cacheManager.getCache("tag");
            if (cache != null) {
                cache.put(id, tagVO);
                log.info("=========== 标签已写入缓存 [id={}] ============", id);
            }
        } catch (Exception e) {
            log.error("写入缓存失败 [id={}]: {}", id, e.getMessage());
        }

        return tagVO;
    }

    @Transactional
    @Override
    // 【优化】使用 @Caching 一次性管理多个缓存操作,覆盖新增和修改场景
    @Caching(evict = {
            @CacheEvict(cacheNames = "tag", key = "'list'"),      // 1. 清除列表缓存
            @CacheEvict(cacheNames = "tag", key = "#tagDTO.id", condition = "#tagDTO.id != null")  // 2. 如果是更新操作,清除对应的单个标签缓存
    })
    public ResponseResult<Void> addOrUpdateTag(TagDTO tagDTO) {
        if (this.saveOrUpdate(tagDTO.asViewObject(Tag.class))) {
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }

    @Transactional
    @Override
    // 【优化】使用 @Caching 保证清除所有相关缓存
    @Caching(evict = {
            @CacheEvict(cacheNames = "tag", key = "'list'"), // 1. 清除列表缓存
            @CacheEvict(cacheNames = "tag", allEntries = true) // 2. 【保险措施】清除所有单个tag缓存,因为无法在注解中循环ids
    })
    public ResponseResult<Void> deleteTagByIds(List<Long> ids) {
        Long count = articleTagMapper.selectCount(new LambdaQueryWrapper<ArticleTag>().in(ArticleTag::getTagId, ids));
        if (count > 0) {
            return ResponseResult.failure(FunctionConst.TAG_EXIST_ARTICLE);
        }
        if (this.removeByIds(ids)) {
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }

    /**
     * 【优化】提取的私有方法,用于获取所有标签的文章计数值
     * @return Map<标签ID, 文章数量>
     */
    private Map<Long, Long> getArticleCountMap() {
        // 【修复】修复了潜在的 NullPointerException
        Map<Long, Map<String, Object>> countMapResult = articleTagMapper.selectArticleCountByTagId();
        if (CollectionUtils.isEmpty(countMapResult)) {
            return Collections.emptyMap();
        }
        return countMapResult.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> ((Number) entry.getValue().get("article_count")).longValue()
                ));
    }
}
