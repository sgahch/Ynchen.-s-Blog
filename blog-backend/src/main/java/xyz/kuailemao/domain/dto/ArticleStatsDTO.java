package xyz.kuailemao.domain.dto;

import lombok.Data;

import java.util.Date;

@Data
public class ArticleStatsDTO {
    private Long articleCount;
    private Date lastUpdateTime;
    private Long visitCount;
}
