package xyz.kuailemao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import xyz.kuailemao.domain.entity.Article;
import xyz.kuailemao.domain.vo.ArticleVO;

import java.util.List;
import java.util.Map;


/**
 * (Article)表数据库访问层
 *
 * @author kuailemao
 * @since 2023-10-15 02:29:11
 */
public interface ArticleMapper extends BaseMapper<Article> {

    @Select("SELECT * FROM t_article WHERE status = #{status} and is_deleted = 0 ORDER BY RAND() LIMIT #{limit}")
    List<Article> selectRandomArticles(@Param("status") Integer status, @Param("limit") Integer limit);

    @Select("SELECT category_id, COUNT(id) as article_count FROM t_article WHERE is_deleted = 0 GROUP BY category_id")
    @MapKey("category_id") // 告诉MyBatis将 category_id 作为Map的Key
    Map<Long, Map<String, Object>> selectArticleCountByCategoryId();
}
