package xyz.kuailemao.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import xyz.kuailemao.constants.SQLConst;
import xyz.kuailemao.constants.WebsiteInfoConst;
import xyz.kuailemao.domain.dto.ArticleStatsDTO;
import xyz.kuailemao.domain.dto.StationmasterInfoDTO;
import xyz.kuailemao.domain.dto.WebsiteInfoDTO;
import xyz.kuailemao.domain.entity.Article;
import xyz.kuailemao.domain.entity.WebsiteInfo;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.domain.vo.WebsiteInfoVO;
import xyz.kuailemao.enums.UploadEnum;
import xyz.kuailemao.mapper.ArticleMapper;
import xyz.kuailemao.mapper.CategoryMapper;
import xyz.kuailemao.mapper.CommentMapper;
import xyz.kuailemao.mapper.WebsiteInfoMapper;
import xyz.kuailemao.service.WebsiteInfoService;
import xyz.kuailemao.utils.FileUploadUtils;
import xyz.kuailemao.utils.StringUtils;

import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * (WebsiteInfo)表服务实现类
 *
 * @author kuailemao
 * @since 2023-12-27 14:07:34
 */
@Slf4j
@Service("websiteInfoService")
public class WebsiteInfoServiceImpl extends ServiceImpl<WebsiteInfoMapper, WebsiteInfo> implements WebsiteInfoService {

    @Resource
    private FileUploadUtils fileUploadUtils;

    @Resource
    private ArticleMapper articleMapper;

    @Resource
    private CategoryMapper categoryMapper;

    @Resource
    private CommentMapper commentMapper;

    @Transactional
    @Override
    public ResponseResult<String> uploadImageInsertOrUpdate(UploadEnum uploadEnum, MultipartFile avatar, Integer type) {
        try {
            List<String> avatarNames = fileUploadUtils.listFiles(uploadEnum.getDir());
            if (!avatarNames.isEmpty()) {
                if (fileUploadUtils.deleteFiles(avatarNames))
                    log.info("删除旧图片成功,{}", avatarNames);
            }
            // 上传
            String url = fileUploadUtils.upload(uploadEnum, avatar);
            switch (type) {
                case 0 ->
                        this.saveOrUpdate(WebsiteInfo.builder().webmasterAvatar(url).id(WebsiteInfoConst.WEBSITE_INFO_ID).build());
                case 1 ->
                        this.saveOrUpdate(WebsiteInfo.builder().webmasterProfileBackground(url).id(WebsiteInfoConst.WEBSITE_INFO_ID).build());
            }

            if (StringUtils.isNotNull(url))
                return ResponseResult.success(url);
            else
                return ResponseResult.failure("图片格式不正确");

        } catch (Exception e) {
            log.error("上传图片失败", e);
            return ResponseResult.failure();
        }
    }

    // 查询网站信息(new)
    @Override
    public WebsiteInfoVO selectWebsiteInfo() {
        WebsiteInfoVO websiteInfoVO = this.getById(WebsiteInfoConst.WEBSITE_INFO_ID)
                .asViewObject(WebsiteInfoVO.class);
        if (websiteInfoVO == null) {
            return null;
        }

        // 聚合查询文章统计
        ArticleStatsDTO stats = articleMapper.selectArticleStats();
        websiteInfoVO.setArticleCount(stats.getArticleCount());
        websiteInfoVO.setLastUpdateTime(stats.getLastUpdateTime());
        websiteInfoVO.setVisitCount(stats.getVisitCount());

        // 如果没有文章，直接返回
        if (stats.getArticleCount() == null || stats.getArticleCount() <= 0) {
            return websiteInfoVO;
        }

        // 字数统计：逐条累加，避免一次性拼接大字符串
        long charCount = articleMapper.selectList(new LambdaQueryWrapper<Article>()
                        .select(Article::getArticleContent))
                .stream()
                .map(Article::getArticleContent)
                .filter(Objects::nonNull)
                .map(this::extractTextFromMarkdown) // 去除 Markdown 标记
                .mapToLong(String::length)
                .sum();
        websiteInfoVO.setWordCount(charCount);

        websiteInfoVO.setCategoryCount(categoryMapper.selectCount(null));
        websiteInfoVO.setCommentCount(commentMapper.selectCount(null));

        return websiteInfoVO;
    }



    @Transactional
    @Override
    public ResponseResult<Void> updateStationmasterInfo(StationmasterInfoDTO stationmasterInfoDTO) {
        WebsiteInfo websiteInfo = stationmasterInfoDTO.asViewObject(WebsiteInfo.class, v -> v.setId(WebsiteInfoConst.WEBSITE_INFO_ID));
        if (StringUtils.isNotNull(websiteInfo)) {
            this.saveOrUpdate(websiteInfo);
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }

    @Transactional
    @Override
    public ResponseResult<Void> updateWebsiteInfo(WebsiteInfoDTO websiteInfoDTO) {
        WebsiteInfo websiteInfo = websiteInfoDTO.asViewObject(WebsiteInfo.class, v -> v.setId(WebsiteInfoConst.WEBSITE_INFO_ID));
        if (StringUtils.isNotNull(websiteInfo)) {
            this.saveOrUpdate(websiteInfo);
            return ResponseResult.success();
        }
        return ResponseResult.failure();
    }

    /**
     * 从Markdown文档中提取文字内容
     *
     * @param markdownContent Markdown文档内容
     * @return 文字内容
     */
    private String extractTextFromMarkdown(String markdownContent) {
        // 使用正则表达式匹配Markdown文档中的文字内容，并去掉空格
        Pattern pattern = Pattern.compile("[^#>\\*\\[\\]`\\s]+");
        Matcher matcher = pattern.matcher(markdownContent);

        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            result.append(matcher.group()).append("\n");
        }

        return result.toString().trim();
    }
}
