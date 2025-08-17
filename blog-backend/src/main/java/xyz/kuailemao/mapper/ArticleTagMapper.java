package xyz.kuailemao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Select;
import xyz.kuailemao.domain.entity.ArticleTag;
import xyz.kuailemao.domain.entity.Tag;

import java.util.List;
import java.util.Map;


/**
 * (ArticleTag)表数据库访问层
 *
 * @author kuailemao
 * @since 2023-10-15 02:29:13
 */
public interface ArticleTagMapper extends BaseMapper<ArticleTag> {

    @Select("SELECT tag_id, COUNT(article_id) as article_count FROM t_article_tag WHERE is_deleted = 0 GROUP BY tag_id")
    @MapKey("tag_id") // 告诉MyBatis将查询结果的 `tag_id` 字段作为Map的Key
    Map<Long, Map<String, Object>> selectArticleCountByTagId();

}
