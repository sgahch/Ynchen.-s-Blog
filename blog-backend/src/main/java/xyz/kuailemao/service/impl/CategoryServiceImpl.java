package xyz.kuailemao.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import xyz.kuailemao.constants.FunctionConst;
import xyz.kuailemao.domain.dto.CategoryDTO;
import xyz.kuailemao.domain.dto.SearchCategoryDTO;
import xyz.kuailemao.domain.entity.Article;
import xyz.kuailemao.domain.entity.Category;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.domain.vo.CategoryVO;
import xyz.kuailemao.mapper.ArticleMapper;
import xyz.kuailemao.mapper.CategoryMapper;
import xyz.kuailemao.service.CategoryService;
import xyz.kuailemao.utils.StringUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

import java.util.List;
import java.util.Map;

/**
 * (Category)表服务实现类
 *
 * @author kuailemao
 * @since 2023-10-15 02:29:14
 */
@Slf4j
@Service("categoryService")
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Resource
    private ArticleMapper articleMapper;

    @Resource
    private CategoryMapper categoryMapper;

    @Override
    @Cacheable(cacheNames = "category", key = "'list'") // 为列表结果添加缓存
    public List<CategoryVO> listAllCategory() {
        log.info("=========== 从数据库查询所有分类及其文章数 ============");
        // 1. 查所有分类 (1次SQL)
        List<Category> categories = this.list();
        if (categories.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 用GROUP BY查所有计数 (1次SQL)
        Map<Long, Map<String, Object>> countMapResult = articleMapper.selectArticleCountByCategoryId();
        Map<Long, Long> articleCountMap = countMapResult.entrySet().stream()
                .collect(Collectors.toMap(  
                        Map.Entry::getKey,
                        entry -> ((Number) entry.getValue().get("article_count")).longValue()
                ));

        // 3. 内存中组装
        return categories.stream().map(category ->
                category.asViewObject(CategoryVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(category.getId(), 0L))
                )
        ).toList();
    }



    @Override
    public List<CategoryVO> searchCategory(SearchCategoryDTO searchCategoryDTO) {
        LambdaQueryWrapper<Category> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(searchCategoryDTO.getCategoryName()), Category::getCategoryName, searchCategoryDTO.getCategoryName());
        if (StringUtils.isNotNull(searchCategoryDTO.getStartTime()) && StringUtils.isNotNull(searchCategoryDTO.getEndTime()))
            queryWrapper.between(Category::getCreateTime, searchCategoryDTO.getStartTime(), searchCategoryDTO.getEndTime());

        // 1. 根据搜索条件查询出分类
        List<Category> categories = categoryMapper.selectList(queryWrapper);
        if (categories.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. (同上) 用GROUP BY查所有计数
        Map<Long, Map<String, Object>> countMapResult = articleMapper.selectArticleCountByCategoryId();
        Map<Long, Long> articleCountMap = countMapResult.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> ((Number) entry.getValue().get("article_count")).longValue()
                ));

        // 3. (同上) 内存中组装
        return categories.stream().map(category ->
                category.asViewObject(CategoryVO.class, item ->
                        item.setArticleCount(articleCountMap.getOrDefault(category.getId(), 0L))
                )
        ).toList();
    }

    @Override
    @Cacheable(cacheNames = "category", key = "#id")
    public CategoryVO getCategoryById(Long id) {
        return categoryMapper.selectById(id).asViewObject(CategoryVO.class);
    }

    @Transactional
    @Override
    @CacheEvict(cacheNames = "category", key = "'list'")
    public ResponseResult<Void> addOrUpdateCategory(CategoryDTO categoryDTO) {
        if (this.saveOrUpdate(categoryDTO.asViewObject(Category.class))) return ResponseResult.success();
        return ResponseResult.failure();
    }

    @Override
    @CacheEvict(cacheNames = "category", key = "'list'")
    public ResponseResult<Void> addCategory(CategoryDTO categoryDTO) {
        categoryDTO.setId(null);
        if (this.save(categoryDTO.asViewObject(Category.class))) return ResponseResult.success();
        return ResponseResult.failure();
    }

    @Transactional
    @Override
    @CacheEvict(cacheNames = "category", key = "'list'")
    public ResponseResult<Void> deleteCategoryByIds(List<Long> ids) {
        // 是否有剩下文章
        Long count = articleMapper.selectCount(new LambdaQueryWrapper<Article>().in(Article::getCategoryId, ids));
        if (count > 0) return ResponseResult.failure(FunctionConst.CATEGORY_EXIST_ARTICLE);
        // 执行删除
        if (this.removeByIds(ids)) return ResponseResult.success();
        return ResponseResult.failure();
    }
}
