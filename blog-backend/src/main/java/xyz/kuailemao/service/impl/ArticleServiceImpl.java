package xyz.kuailemao.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import xyz.kuailemao.constants.RedisConst;
import xyz.kuailemao.constants.SQLConst;
import xyz.kuailemao.domain.dto.ArticleDTO;
import xyz.kuailemao.domain.dto.SearchArticleDTO;
import xyz.kuailemao.domain.entity.*;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.domain.vo.*;
import xyz.kuailemao.enums.*;
import xyz.kuailemao.exceptions.FileUploadException;
import xyz.kuailemao.mapper.*;
import xyz.kuailemao.service.*;
import xyz.kuailemao.utils.*;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * (Article)表服务实现类
 *
 * @author kuailemao
 * @since 2023-10-15 02:29:13
 */
@Slf4j
@Service("articleService")
public class ArticleServiceImpl extends ServiceImpl<ArticleMapper, Article> implements ArticleService {

    @Resource
    private CategoryMapper categoryMapper;

    @Resource
    private ArticleTagMapper articleTagMapper;

    @Resource
    private TagMapper tagMapper;

    @Resource
    private ArticleMapper articleMapper;

    @Resource
    private FavoriteService favoriteService;

    @Resource
    private LikeService likeService;

    @Resource
    private CommentService commentService;

    @Resource
    private RedisCache redisCache;

    @Resource
    private FileUploadUtils fileUploadUtils;

    @Resource
    private UserMapper userMapper;

    @Resource
    private LikeMapper likeMapper;

    @Resource
    private FavoriteMapper favoriteMapper;

    @Resource
    private CommentMapper commentMapper;

    @Resource
    private CacheManager cacheManager;


    // 在 ArticleServiceImpl.java 中
    // 确保已经导入了 @Cacheable, Collectors, Collections 等

    @Override
    @Cacheable(cacheNames = "articleList", key = "'page:' + #pageNum + ':' + #pageSize")
    public PageVO<List<ArticleVO>> listAllArticle(Integer pageNum, Integer pageSize) {
        log.info("=========== 从数据库查询前台文章列表: 页码 {}, 每页数量 {} ============", pageNum, pageSize);

        // 1. 分页查询文章 (1次SQL)
        Page<Article> page = new Page<>(pageNum, pageSize);
        this.page(page, new LambdaQueryWrapper<Article>()
                .eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE)
                .orderByDesc(Article::getCreateTime));

        List<Article> articles = page.getRecords();
        if (articles.isEmpty()) {
            return new PageVO<>(Collections.emptyList(), 0L);
        }

        List<Long> articleIds = articles.stream().map(Article::getId).toList();

        // 2. 批量获取所有需要的关联数据
        // (1) 批量获取分类 (1次SQL)
        Map<Long, String> categoryMap = categoryMapper.selectBatchIds(
                        articles.stream().map(Article::getCategoryId).distinct().toList()
                ).stream()
                .collect(Collectors.toMap(Category::getId, Category::getCategoryName));

        // (2) 批量获取标签 (1次SQL)
        List<Map<String, Object>> tagResults = articleTagMapper.selectTagsByArticleIds(articleIds);
        Map<Long, List<String>> articleTagsMap = tagResults.stream()
                .collect(Collectors.groupingBy(
                        map -> ((Number) map.get("article_id")).longValue(),
                        Collectors.mapping(map -> (String) map.get("tag_name"), Collectors.toList())
                ));

        // 3. 在内存中高效组装数据
        List<ArticleVO> articleVOS = articles.stream().map(article -> {
            ArticleVO articleVO = article.asViewObject(ArticleVO.class);
            articleVO.setCategoryName(categoryMap.get(article.getCategoryId()));
            // 直接从Map中获取标签列表，如果某篇文章没有标签，getOrDefault会返回一个空列表
            articleVO.setTags(articleTagsMap.getOrDefault(article.getId(), Collections.emptyList()));
            return articleVO;
        }).toList();

        // 4. (可选) 从Redis中获取并设置互动计数 (这部分您的逻辑已经很好了，可以保留)
        boolean hasKey = redisCache.isHasKey(RedisConst.ARTICLE_COMMENT_COUNT) && redisCache.isHasKey(RedisConst.ARTICLE_FAVORITE_COUNT) && redisCache.isHasKey(RedisConst.ARTICLE_LIKE_COUNT);
        if (hasKey) {
            articleVOS.forEach(articleVO -> {
                setArticleCount(articleVO, RedisConst.ARTICLE_FAVORITE_COUNT, CountTypeEnum.FAVORITE);
                setArticleCount(articleVO, RedisConst.ARTICLE_LIKE_COUNT, CountTypeEnum.LIKE);
                setArticleCount(articleVO, RedisConst.ARTICLE_COMMENT_COUNT, CountTypeEnum.COMMENT);
            });
        }

        return new PageVO<>(articleVOS, page.getTotal());
    }

    private void setArticleCount(ArticleVO articleVO, String redisKey, CountTypeEnum articleFieldName) {
        String articleId = articleVO.getId().toString();
        Object countObj = redisCache.getCacheMap(redisKey).get(articleId);
        long count = 0L;
        if (countObj != null) {
            count = Long.parseLong(countObj.toString());
        } else {
            // 缓存发布新文章时数量缓存不存在
            redisCache.setCacheMap(redisKey, Map.of(articleId, 0));
        }

        if (articleFieldName.equals(CountTypeEnum.FAVORITE)) {
            articleVO.setFavoriteCount(count);
        } else if (articleFieldName.equals(CountTypeEnum.LIKE)) {
            articleVO.setLikeCount(count);
        } else if (articleFieldName.equals(CountTypeEnum.COMMENT)) {
            articleVO.setCommentCount(count);
        }
    }

    @Override
    public List<RecommendArticleVO> listRecommendArticle() {
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getIsTop, SQLConst.RECOMMEND_ARTICLE).and(i -> i.eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE));
        List<Article> articles = articleMapper.selectList(wrapper);
        return articles.stream().map(article -> article.asViewObject(RecommendArticleVO.class)).toList();
    }

    @Override
    public List<RandomArticleVO> listRandomArticle() {
        List<Article> randomArticles = articleMapper.selectRandomArticles(SQLConst.PUBLIC_ARTICLE, SQLConst.RANDOM_ARTICLE_COUNT);
        return randomArticles.stream()
                .map(article -> article.asViewObject(RandomArticleVO.class))
                .toList();
    }

    /**
     * 获取文章详情
     *
     * @param id 文章id
     * @return 文章详情
     */
    @Cacheable(cacheNames = "articleDetail", key = "#id")
    @Override
    public ArticleDetailVO getArticleDetail(Integer id) {
        log.info("=========== 从数据库查询文章详情: {} ============", id);
        Article article = articleMapper.selectOne(new LambdaQueryWrapper<Article>().eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE).and(i -> i.eq(Article::getId, id)));
        if (StringUtils.isNull(article)) return null;
        // 文章分类
        Category category = categoryMapper.selectById(article.getCategoryId());
        // 文章关系
        List<ArticleTag> articleTags = articleTagMapper.selectList(new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, article.getId()));
        // 标签
        List<Tag> tags = tagMapper.selectBatchIds(articleTags.stream().map(ArticleTag::getTagId).toList());
        // 当前文章的上一篇文章与下一篇文章,大于当前文章的最小文章与小于当前文章的最大文章
        LambdaQueryWrapper<Article> preAndNextWrapper = new LambdaQueryWrapper<>();
        preAndNextWrapper.lt(Article::getId, id);
        Article preArticle = articleMapper.selectOne(preAndNextWrapper.orderByDesc(Article::getId).last(SQLConst.LIMIT_ONE_SQL));
        preAndNextWrapper.clear();
        preAndNextWrapper.gt(Article::getId, id);
        Article nextArticle = articleMapper.selectOne(preAndNextWrapper.orderByAsc(Article::getId).last(SQLConst.LIMIT_ONE_SQL));

        return article.asViewObject(ArticleDetailVO.class, vo -> {
            vo.setCategoryName(category.getCategoryName());
            vo.setCategoryId(category.getId());
            vo.setTags(tags.stream().map(tag -> tag.asViewObject(TagVO.class)).toList());
            vo.setCommentCount(commentService.count(new LambdaQueryWrapper<Comment>().eq(Comment::getTypeId, article.getId()).eq(Comment::getType, CommentEnum.COMMENT_TYPE_ARTICLE.getType())));
            vo.setLikeCount(likeService.count(new LambdaQueryWrapper<Like>().eq(Like::getTypeId, article.getId()).eq(Like::getType, LikeEnum.LIKE_TYPE_ARTICLE.getType())));
            vo.setFavoriteCount(favoriteService.count(new LambdaQueryWrapper<Favorite>().eq(Favorite::getTypeId, article.getId()).eq(Favorite::getType, FavoriteEnum.FAVORITE_TYPE_ARTICLE.getType())));
            vo.setPreArticleId(preArticle == null ? 0 : preArticle.getId());
            vo.setPreArticleTitle(preArticle == null ? "" : preArticle.getArticleTitle());
            vo.setNextArticleId(nextArticle == null ? 0 : nextArticle.getId());
            vo.setNextArticleTitle(nextArticle == null ? "" : nextArticle.getArticleTitle());
        });
    }

    @Override
    public List<RelatedArticleVO> relatedArticleList(Integer categoryId, Integer articleId) {
        // 文章id不等于当前文章id,相关推荐排除自己，5条
        List<Article> articles = articleMapper.selectList(
                new LambdaQueryWrapper<Article>()
                        .eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE)
                        .and(i -> i.eq(Article::getCategoryId, categoryId))
                        .ne(Article::getId, articleId)
        );
        List<Article> articlesLimit5 = articles.stream().limit(SQLConst.RELATED_ARTICLE_COUNT).toList();
        return articlesLimit5.stream().map(article -> article.asViewObject(RelatedArticleVO.class)).toList();
    }

    @Override
    public List<TimeLineVO> listTimeLine() {
        List<Article> list = this.query().list();
        return list.stream().map(article -> article.asViewObject(TimeLineVO.class)).toList();
    }

    @Override
    public List<CategoryArticleVO> listCategoryArticle(Integer type, Long typeId) {
        List<Article> articles;
        if (type == 1)
            articles = articleMapper.selectList(new LambdaQueryWrapper<Article>().eq(Article::getCategoryId, typeId));
        else if (type == 2) {
            List<Long> articleIds = articleTagMapper.selectList(new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getTagId, typeId)).stream().map(ArticleTag::getArticleId).toList();
            if (!articleIds.isEmpty()) articles = articleMapper.selectBatchIds(articleIds);
            else articles = List.of();
        } else articles = List.of();

        if (Objects.isNull(articles) || articles.isEmpty()) return null;
        List<ArticleTag> articleTags = articleTagMapper.selectBatchIds(articles.stream().map(Article::getId).toList());
        List<Tag> tags = tagMapper.selectBatchIds(articleTags.stream().map(ArticleTag::getTagId).toList());

        return articles.stream().map(article -> article.asViewObject(CategoryArticleVO.class, item -> {
            item.setCategoryId(articles.stream().filter(art -> Objects.equals(art.getId(), article.getId())).findFirst().orElseThrow().getCategoryId());
            item.setTags(tags.stream().filter(tag -> articleTags.stream().anyMatch(articleTag -> Objects.equals(articleTag.getArticleId(), article.getId()) && Objects.equals(articleTag.getTagId(), tag.getId()))).map(tag -> tag.asViewObject(TagVO.class)).toList());
        })).toList();
    }

    @Override
    public void addVisitCount(Long id) {
        // 访问量去重
        HttpServletRequest request = SecurityUtils.getCurrentHttpRequest();
        // key + id + ip + time(秒)
        String KEY = RedisConst.ARTICLE_VISIT_COUNT_LIMIT + id + ":" + IpUtils.getIpAddr(request);
        if (redisCache.getCacheObject(KEY) == null) {
            // 设置间隔时间
            redisCache.setCacheObject(KEY, 1, RedisConst.ARTICLE_VISIT_COUNT_INTERVAL, TimeUnit.SECONDS);

            if (redisCache.isHasKey(RedisConst.ARTICLE_VISIT_COUNT + id))
                redisCache.increment(RedisConst.ARTICLE_VISIT_COUNT + id, 1L);
            else redisCache.setCacheObject(RedisConst.ARTICLE_VISIT_COUNT + id, 0);
        }

    }

    @Override
    public ResponseResult<String> uploadArticleCover(MultipartFile articleCover) {
        try {
            String articleCoverUrl = null;
            try {
                articleCoverUrl = fileUploadUtils.upload(UploadEnum.ARTICLE_COVER, articleCover);
            } catch (FileUploadException e) {
                return ResponseResult.failure(e.getMessage());
            }
            if (StringUtils.isNotNull(articleCoverUrl))
                return ResponseResult.success(articleCoverUrl);
            else
                return ResponseResult.failure("上传格式错误");
        } catch (Exception e) {
            log.error("文章封面上传失败", e);
            return ResponseResult.failure();
        }
    }

    @Resource
    private ArticleTagService articleTagService;

//================================================================================
// 1. publish 方法 (新增/更新文章)
//================================================================================

    @Transactional
    @Caching(evict = {
            // 效果: 新增或更新文章后，所有列表缓存都会被清空，下次访问时会重新从数据库加载
            @CacheEvict(cacheNames = "articleList", allEntries = true),
            // 效果: 只有在"更新"文章时 (articleDTO.id不为null)，才会精确地清除该文章的详情缓存
            @CacheEvict(cacheNames = "articleDetail", key = "#articleDTO.id", condition = "#articleDTO.id != null")
    })
    @Override
    public ResponseResult<Void> publish(ArticleDTO articleDTO) {
        Article article = articleDTO.asViewObject(Article.class, v -> v.setUserId(SecurityUtils.getUserId()));

        if (this.saveOrUpdate(article)) {
            // 清除旧的标签关系
            if(article.getId() != null) {
                articleTagMapper.delete(new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, article.getId()));
            }
            // 新增标签关系
            List<ArticleTag> articleTags = articleDTO.getTagId().stream()
                    .map(tagId -> ArticleTag.builder().articleId(article.getId()).tagId(tagId).build())
                    .toList();
            if(!articleTags.isEmpty()) {
                articleTagService.saveBatch(articleTags);
            }

            log.info("=========== 发布/更新文章成功: {} ============", article.getId());
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }

    @Value("${minio.bucketName}")
    private String bucketName;

    @Override
    public ResponseResult<Void> deleteArticleCover(String articleCoverUrl) {
        try {
            // 提取图片名称
            String articleCoverName = articleCoverUrl.substring(articleCoverUrl.indexOf(bucketName) + bucketName.length());
            fileUploadUtils.deleteFiles(List.of(articleCoverName));
            log.info("=========== 删除文章封面成功: {} ============", articleCoverName);
            return ResponseResult.success();
        } catch (Exception e) {
            log.error("删除文章封面失败", e);
            return ResponseResult.failure();
        }
    }

    @Override
    public ResponseResult<String> uploadArticleImage(MultipartFile articleImage) {
        try {
            String url = fileUploadUtils.upload(UploadEnum.ARTICLE_IMAGE, articleImage);
            if (StringUtils.isNotNull(url))
                return ResponseResult.success(url);
            else
                return ResponseResult.failure("上传格式错误");
        } catch (Exception e) {
            log.error("文章图片上传失败", e);
        }
        return null;
    }

//    重构 `listArticle()` 和 `searchArticle()`**：这是**最重要**的一步。请务必将“批量查询+内存组装”的优化模式应用到这两个方法上，消除最后的N+1性能瓶-颈。
//    @Override     N+1版本
//    public List<ArticleListVO> listArticle() {
////        List<ArticleListVO> articleListVOS = articleMapper.selectList(new LambdaQueryWrapper<Article>()
////                .orderByDesc(Article::getCreateTime)).stream().map(article -> article.asViewObject(ArticleListVO.class)).toList();
////        if (!articleListVOS.isEmpty()) {
////            articleListVOS.forEach(articleListVO -> {
////                articleListVO.setCategoryName(categoryMapper.selectById(articleListVO.getCategoryId()).getCategoryName());
////                articleListVO.setUserName(userMapper.selectById(articleListVO.getUserId()).getUsername());
////                // 查询文章标签
////                List<Long> tagIds = articleTagMapper.selectList(new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, articleListVO.getId())).stream().map(ArticleTag::getTagId).toList();
////                articleListVO.setTagsName(tagMapper.selectBatchIds(tagIds).stream().map(Tag::getTagName).toList());
////            });
////            return articleListVOS;
////        }
////        return null;


    @Override
    // (可选) 为后台列表添加缓存
    @Cacheable(cacheNames = "article", key = "'back:list'")
    public List<ArticleListVO> listArticle() {
        log.info("=========== 从数据库查询后台文章列表 ============");

        // 1. 一次性查询出所有文章 (1次SQL)
        List<Article> articles = this.list(new LambdaQueryWrapper<Article>().orderByDesc(Article::getCreateTime));
        if (articles.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 准备好需要查询的ID集合
        List<Long> articleIds = articles.stream().map(Article::getId).toList();
        // 使用 distinct() 去重，减少查询量
        List<Long> userIds = articles.stream().map(Article::getUserId).distinct().toList();
        List<Long> categoryIds = articles.stream().map(Article::getCategoryId).distinct().toList();

        // 3. 批量获取所有需要的关联数据 (只需3次SQL)
        // (1) 批量获取分类信息
        Map<Long, String> categoryMap = categoryMapper.selectBatchIds(categoryIds)
                .stream().collect(Collectors.toMap(Category::getId, Category::getCategoryName));

        // (2) 批量获取用户信息
        Map<Long, String> userMap = userMapper.selectBatchIds(userIds)
                .stream().collect(Collectors.toMap(User::getId, User::getUsername));

        // (3) 批量获取所有文章的标签关系及标签名 (这里可以使用我们之前创建的高效JOIN查询)
        List<Map<String, Object>> tagResults = articleTagMapper.selectTagsByArticleIds(articleIds);
        Map<Long, List<String>> articleTagsMap = tagResults.stream()
                .collect(Collectors.groupingBy(
                        map -> ((Number) map.get("article_id")).longValue(),
                        Collectors.mapping(map -> (String) map.get("tag_name"), Collectors.toList())
                ));

        // 4. 在内存中高效组装最终的VO列表
        return articles.stream().map(article -> {
            ArticleListVO vo = article.asViewObject(ArticleListVO.class);
            // 从Map中获取数据，O(1)复杂度
            vo.setCategoryName(categoryMap.get(article.getCategoryId()));
            vo.setUserName(userMap.get(article.getUserId()));
            vo.setTagsName(articleTagsMap.getOrDefault(article.getId(), Collections.emptyList()));
            return vo;
        }).toList();
    }

//    @Override   N+1版本
//    public List<ArticleListVO> searchArticle(SearchArticleDTO searchArticleDTO) {
//        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
//        wrapper.like(StringUtils.isNotNull(searchArticleDTO.getArticleTitle()), Article::getArticleTitle, searchArticleDTO.getArticleTitle())
//                .eq(StringUtils.isNotNull(searchArticleDTO.getCategoryId()), Article::getCategoryId, searchArticleDTO.getCategoryId())
//                .eq(StringUtils.isNotNull(searchArticleDTO.getStatus()), Article::getStatus, searchArticleDTO.getStatus())
//                .eq(StringUtils.isNotNull(searchArticleDTO.getIsTop()), Article::getIsTop, searchArticleDTO.getIsTop());
//        List<ArticleListVO> articleListVOS = articleMapper.selectList(wrapper).stream().map(article -> article.asViewObject(ArticleListVO.class)).toList();
//        if (!articleListVOS.isEmpty()) {
//            articleListVOS.forEach(articleListVO -> {
//                articleListVO.setCategoryName(categoryMapper.selectById(articleListVO.getCategoryId()).getCategoryName());
//                articleListVO.setUserName(userMapper.selectById(articleListVO.getUserId()).getUsername());
//                // 查询文章标签
//                List<Long> tagIds = articleTagMapper.selectList(new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, articleListVO.getId())).stream().map(ArticleTag::getTagId).toList();
//                articleListVO.setTagsName(tagMapper.selectBatchIds(tagIds).stream().map(Tag::getTagName).toList());
//            });
//            return articleListVOS;
//        }
//        return null;
//    }
    @Override
    public List<ArticleListVO> searchArticle(SearchArticleDTO searchArticleDTO) {
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.isNotNull(searchArticleDTO.getArticleTitle()), Article::getArticleTitle, searchArticleDTO.getArticleTitle())
                .eq(StringUtils.isNotNull(searchArticleDTO.getCategoryId()), Article::getCategoryId, searchArticleDTO.getCategoryId())
                .eq(StringUtils.isNotNull(searchArticleDTO.getStatus()), Article::getStatus, searchArticleDTO.getStatus())
                .eq(StringUtils.isNotNull(searchArticleDTO.getIsTop()), Article::getIsTop, searchArticleDTO.getIsTop());

        // 1. 根据搜索条件查询文章 (1次SQL)
        List<Article> articles = articleMapper.selectList(wrapper);
        if (articles.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 和 listArticle() 完全相同的批量查询与组装逻辑
        List<Long> articleIds = articles.stream().map(Article::getId).toList();
        List<Long> userIds = articles.stream().map(Article::getUserId).distinct().toList();
        List<Long> categoryIds = articles.stream().map(Article::getCategoryId).distinct().toList();

        Map<Long, String> categoryMap = categoryMapper.selectBatchIds(categoryIds)
                .stream().collect(Collectors.toMap(Category::getId, Category::getCategoryName));
        Map<Long, String> userMap = userMapper.selectBatchIds(userIds)
                .stream().collect(Collectors.toMap(User::getId, User::getUsername));

        List<Map<String, Object>> tagResults = articleTagMapper.selectTagsByArticleIds(articleIds);
        Map<Long, List<String>> articleTagsMap = tagResults.stream()
                .collect(Collectors.groupingBy(
                        map -> ((Number) map.get("article_id")).longValue(),
                        Collectors.mapping(map -> (String) map.get("tag_name"), Collectors.toList())
                ));

        // 3. 内存中组装
        return articles.stream().map(article -> {
            ArticleListVO vo = article.asViewObject(ArticleListVO.class);
            vo.setCategoryName(categoryMap.get(article.getCategoryId()));
            vo.setUserName(userMap.get(article.getUserId()));
            vo.setTagsName(articleTagsMap.getOrDefault(article.getId(), Collections.emptyList()));
            return vo;
        }).toList();
    }

//================================================================================
// 2. updateStatus 方法 (更新文章状态)
//================================================================================

    @Override
    @Caching(evict = {
            // 效果: 文章状态变更（发布/下架）会影响列表，清空所有列表缓存
            @CacheEvict(cacheNames = "articleList", allEntries = true),
            // 效果: 同时精确清除该文章的详情缓存
            @CacheEvict(cacheNames = "articleDetail", key = "#id")
    })
    public ResponseResult<Void> updateStatus(Long id, Integer status) {
        if (this.update(new LambdaUpdateWrapper<Article>().eq(Article::getId, id).set(Article::getStatus, status))) {
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }


//================================================================================
// 3. updateIsTop 方法 (更新文章置顶状态)
//================================================================================

    @Override
    @Caching(evict = {
            // 效果: 文章置顶状态变更会影响列表，清空所有列表缓存
            @CacheEvict(cacheNames = "articleList", allEntries = true),
            // 效果: 同时精确清除该文章的详情缓存
            @CacheEvict(cacheNames = "articleDetail", key = "#id")
    })
    public ResponseResult<Void> updateIsTop(Long id, Integer isTop) {
        if (this.update(new LambdaUpdateWrapper<Article>().eq(Article::getId, id).set(Article::getIsTop, isTop))) {
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }


    @Override
    public ArticleDTO getArticleDTO(Long id) {
        ArticleDTO articleDTO = articleMapper.selectById(id).asViewObject(ArticleDTO.class);
        if (StringUtils.isNotNull(articleDTO)) {
            // 查询文章标签
            List<Long> tagIds = articleTagMapper.selectList(new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, articleDTO.getId())).stream().map(ArticleTag::getTagId).toList();
            articleDTO.setTagId(tagMapper.selectBatchIds(tagIds).stream().map(Tag::getId).toList());
            return articleDTO;
        }
        return null;
    }


//================================================================================
// 4. deleteArticle 方法 (删除文章)
//================================================================================

    @Transactional
    @Caching(evict = {
            // 效果: 删除文章会影响所有列表，清空所有列表缓存
            @CacheEvict(cacheNames = "articleList", allEntries = true)
    })
    @Override
    public ResponseResult<Void> deleteArticle(List<Long> ids) {
        if (this.removeByIds(ids)) {
            // 删除标签关系
            articleTagMapper.delete(new LambdaQueryWrapper<ArticleTag>().in(ArticleTag::getArticleId, ids));
            // 删除点赞、收藏、评论
            likeMapper.delete(new LambdaQueryWrapper<Like>().eq(Like::getType, LikeEnum.LIKE_TYPE_ARTICLE.getType()).and(a -> a.in(Like::getTypeId, ids)));
            favoriteMapper.delete(new LambdaQueryWrapper<Favorite>().eq(Favorite::getType, FavoriteEnum.FAVORITE_TYPE_ARTICLE.getType()).and(a -> a.in(Favorite::getTypeId, ids)));
            commentMapper.delete(new LambdaQueryWrapper<Comment>().eq(Comment::getType, CommentEnum.COMMENT_TYPE_ARTICLE.getType()).and(a -> a.in(Comment::getTypeId, ids)));

            // --- 手动清除文章详情缓存 ---
            // 理由: @CacheEvict注解不方便处理List<Long>类型的key, 因此手动清除更直观
            Cache detailCache = cacheManager.getCache("articleDetail");
            if (detailCache != null && ids != null && !ids.isEmpty()) {
                ids.forEach(id -> {
                    log.info("=========== 删除文章，清除详情缓存: {} ============", id);
                    detailCache.evict(id);
                });
            }
            // --------------------------

            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }
    @Override
    public List<InitSearchTitleVO> initSearchByTitle() {
        List<Article> articles = this.list(new LambdaQueryWrapper<Article>().eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE));
        Map<Long, String> categoryMap = categoryMapper.selectList(null).stream().collect(Collectors.toMap(Category::getId, Category::getCategoryName));
        if (articles.isEmpty()) {
            return List.of();
        }
        return articles.stream().map(article -> article.asViewObject(InitSearchTitleVO.class, item -> item.setCategoryName(categoryMap.get(article.getCategoryId())))).toList();
    }

    @Override
    public List<HotArticleVO> listHotArticle() {
        List<Article> articles = articleMapper.selectList(new LambdaQueryWrapper<Article>().eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE).orderByDesc(Article::getVisitCount).last("LIMIT 5"));
        if (!articles.isEmpty()) {
            return articles.stream().map(article -> article.asViewObject(HotArticleVO.class)).toList();
        }
        return List.of();
    }

    @Override
    public List<SearchArticleByContentVO> searchArticleByContent(String keyword) {
        List<Article> articles = articleMapper.selectList(new LambdaQueryWrapper<Article>().like(Article::getArticleContent, keyword).eq(Article::getStatus, SQLConst.PUBLIC_ARTICLE));
        Map<Long, String> categoryMap = categoryMapper.selectList(null).stream().collect(Collectors.toMap(Category::getId, Category::getCategoryName));
        if (!articles.isEmpty()) {
            List<SearchArticleByContentVO> listVos = articles.stream().map(article -> article.asViewObject(SearchArticleByContentVO.class, vo -> {
                vo.setCategoryName(categoryMap.get(article.getCategoryId()));
            })).toList();
            int index = -1;
            for (SearchArticleByContentVO articleVo : listVos) {
                String content = articleVo.getArticleContent();
                index = content.toLowerCase().indexOf(keyword.toLowerCase());
                if (index != -1) {
                    int end = Math.min(content.length(), index + keyword.length() + 20);
                    String highlighted = keyword + content.substring(index + keyword.length(), end);
                    articleVo.setArticleContent(stripMarkdown(highlighted));
                }
            }
            if (index != -1) {
                return listVos;
            }
        }
        return List.of();
    }

    /**
     * 去掉markdown格式
     *
     * @param markdown markdown
     * @return txt
     */
    private String stripMarkdown(String markdown) {
        return markdown.replaceAll("(?m)^\\s*#.*$", "") // 去掉标题
                .replaceAll("\\*\\*(.*?)\\*\\*", "$1") // 去掉加粗
                .replaceAll("\\*(.*?)\\*", "$1") // 去掉斜体
                .replaceAll("`([^`]*)`", "$1") // 去掉行内代码
                .replaceAll("~~(.*?)~~", "$1") // 去掉删除线
                .replaceAll("\\[(.*?)\\]\\(.*?\\)", "$1") // 去掉链接
                .replaceAll("!\\[.*?\\]\\(.*?\\)", "") // 去掉图片
                .replaceAll(">\\s?", "") // 去掉引用
                .replaceAll("(?m)^\\s*[-*+]\\s+", "") // 去掉无序列表
                .replaceAll("(?m)^\\s*\\d+\\.\\s+", "") // 去掉有序列表
                .replaceAll("\\n", " "); // 去掉换行符
    }
}
