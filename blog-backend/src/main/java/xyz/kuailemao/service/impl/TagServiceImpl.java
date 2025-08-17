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
    @Cacheable(cacheNames = "tag", key = "'list'") // 为整个列表结果添加缓存
    public List<TagVO> listAllTag() {
        log.info("=========== 从数据库查询所有标签及其文章数 ============");
        // 第1步：一次性查询出所有标签
        List<Tag> tags = this.list();
        if (tags.isEmpty()) {
            return Collections.emptyList();
        }

        // 第2步：一次性查询出所有标签对应的文章计数值
        Map<Long, Map<String, Object>> countMapResult = articleTagMapper.selectArticleCountByTagId();
        // 将其转换为更易于使用的 Map<Long, Long>
        Map<Long, Long> articleCountMap = countMapResult.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> ((Number) entry.getValue().get("article_count")).longValue()
                ));

        // 第3步：在内存中进行数据组装，不再有数据库查询
        return tags.stream().map(tag ->
                tag.asViewObject(TagVO.class, item ->
                        // 从Map中获取计数，如果某个标签没有文章，getOrDefault会返回0
                        item.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L))
                )
        ).toList();
    }

    @Override
    @CacheEvict(cacheNames = "tag", key = "'list'")
    public ResponseResult<Void> addTag(TagDTO tagDTO) {
        if (this.save(tagDTO.asViewObject(Tag.class))) return ResponseResult.success();
        return ResponseResult.failure();
    }

    @Override
    public List<TagVO> searchTag(SearchTagDTO searchTagDTO) {
        LambdaQueryWrapper<Tag> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(searchTagDTO.getTagName()), Tag::getTagName, searchTagDTO.getTagName());
        if (StringUtils.isNotNull(searchTagDTO.getStartTime()) && StringUtils.isNotNull(searchTagDTO.getEndTime()))
            queryWrapper.between(Tag::getCreateTime, searchTagDTO.getStartTime(), searchTagDTO.getEndTime());

        // 第1步：根据搜索条件查询出标签
        List<Tag> tags = tagMapper.selectList(queryWrapper);
        if (tags.isEmpty()) {
            return Collections.emptyList();
        }

        // 第2步：一次性查询出所有标签对应的文章计数值
        // (这一步和 listAllTag 完全一样)
        Map<Long, Map<String, Object>> countMapResult = articleTagMapper.selectArticleCountByTagId();
        Map<Long, Long> articleCountMap = countMapResult.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> ((Number) entry.getValue().get("article_count")).longValue()
                ));

        // 第3步：在内存中进行数据组装
        return tags.stream().map(tag ->
                tag.asViewObject(TagVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(tag.getId(), 0L))
                )
        ).toList();
    }

    @Override
    @Cacheable(cacheNames = "tag", key = "#id") // <-- 添加缓存
    public TagVO getTagById(Long id) {
        log.info("=========== 从数据库查询单个标签: {} ============", id);
        Tag tag = tagMapper.selectById(id);
        return tag != null ? tag.asViewObject(TagVO.class) : null;
    }

    @Transactional
    @Override
    // 使用 @Caching 一次性管理多个缓存操作
    @Caching(evict = {
            @CacheEvict(cacheNames = "tag", key = "'list'"), // 清除列表缓存
            @CacheEvict(cacheNames = "tag", key = "#tagDTO.id")  // 清除单个标签的缓存
    })
    public ResponseResult<Void> addOrUpdateTag(TagDTO tagDTO) {
        if (this.saveOrUpdate(tagDTO.asViewObject(Tag.class))) return ResponseResult.success();
        return ResponseResult.failure();
    }

    @Transactional
    @Override
    @CacheEvict(cacheNames = "tag", key = "'list'")
    public ResponseResult<Void> deleteTagByIds(List<Long> ids) {
        // 是否有剩下文章
        Long count = articleTagMapper.selectCount(new LambdaQueryWrapper<ArticleTag>().in(ArticleTag::getTagId, ids));
        if (count > 0) return ResponseResult.failure(FunctionConst.TAG_EXIST_ARTICLE);
        // 执行删除
        if (this.removeByIds(ids)) return ResponseResult.success();
        return ResponseResult.failure();
    }
}
