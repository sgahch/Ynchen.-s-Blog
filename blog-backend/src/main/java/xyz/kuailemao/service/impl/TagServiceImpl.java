package xyz.kuailemao.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
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
 */
@Slf4j
@Service("tagService")
public class TagServiceImpl extends ServiceImpl<TagMapper, Tag> implements TagService {

    @Resource
    private ArticleTagMapper articleTagMapper;

    @Resource
    private TagMapper tagMapper;

    @Override
    @Cacheable(cacheNames = "tag", key = "'list'")
    public List<TagVO> listAllTag() {
        log.info("=========== 从数据库查询所有标签及其文章数 ============");
        List<Tag> tags = this.list();
        if (CollectionUtils.isEmpty(tags)) {
            return Collections.emptyList();
        }
        // 【优化】提取公共方法获取文章计数
        Map<Long, Long> articleCountMap = getArticleCountMap();
        // 在内存中进行数据组装
        return tags.stream().map(tag ->
                tag.asViewObject(TagVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L))
                )
        ).toList();
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

        // 【优化】提取公共方法获取文章计数
        Map<Long, Long> articleCountMap = getArticleCountMap();
        // 在内存中进行数据组装
        return tags.stream().map(tag ->
                tag.asViewObject(TagVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L))
                )
        ).toList();
    }

    @Override
    @Cacheable(cacheNames = "tag", key = "#id")
    public TagVO getTagById(Long id) {
        log.info("=========== 从数据库查询单个标签: {} ============", id);
        Tag tag = tagMapper.selectById(id);
        // 【优化】这里也加上文章计数逻辑，使得单个查询和列表查询数据结构一致
        if (tag != null) {
            TagVO tagVO = tag.asViewObject(TagVO.class);
            Map<Long, Long> articleCountMap = getArticleCountMap();
            tagVO.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L));
            return tagVO;
        }
        return null;
    }

    @Transactional
    @Override
    // 【优化】使用 @Caching 一次性管理多个缓存操作，覆盖新增和修改场景
    @Caching(evict = {
            @CacheEvict(cacheNames = "tag", key = "'list'"),      // 1. 清除列表缓存
            @CacheEvict(cacheNames = "tag", key = "#tagDTO.id", condition = "#tagDTO.id != null")  // 2. 如果是更新操作，清除对应的单个标签缓存
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
            @CacheEvict(cacheNames = "tag", allEntries = true) // 2. 【保险措施】清除所有单个tag缓存，因为无法在注解中循环ids
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
     * 【优化】提取的私有方法，用于获取所有标签的文章计数值
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

