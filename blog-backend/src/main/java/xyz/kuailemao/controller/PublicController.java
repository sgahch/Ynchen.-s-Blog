package xyz.kuailemao.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;
import xyz.kuailemao.annotation.AccessLimit;
import xyz.kuailemao.annotation.LogAnnotation;
import xyz.kuailemao.constants.LogConst;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.domain.ip.IpDetail;
import xyz.kuailemao.service.PublicService;
import xyz.kuailemao.utils.ControllerUtils;
import xyz.kuailemao.utils.IpUtils;
import xyz.kuailemao.service.impl.IpServiceImpl;

/**
 * @author kuailemao
 * <p>
 * 创建时间：2023/10/16 17:00
 * 公共接口
 */
@RestController
@Tag(name = "公共接口")
@RequestMapping("/public")
@Validated
public class PublicController {

    @Resource
    private PublicService publicService;

    /**
     * 邮件发送
     */
    @Operation(summary = "邮件发送")
    @Parameters({
            @Parameter(name = "email", description = "邮箱", required = true),
            @Parameter(name = "type", description = "邮箱类型", required = true)
    })
    @AccessLimit(seconds = 60, maxCount = 1)
    @LogAnnotation(module="邮件发送",operation= LogConst.EMAIL_SEND)
    @GetMapping("/ask-code")
    public ResponseResult<String> askVerifyCode(
            @RequestParam @Email String email,
            @RequestParam @Pattern(regexp = "(register|reset|resetEmail)",message = "邮箱类型错误" ) String type
    ) {
        return ControllerUtils.messageHandler(() -> publicService.registerEmailVerifyCode(type, email));
    }

    /**
     * 获取客户端IP详情
     */
    @Operation(summary = "获取客户端IP详情")
    @AccessLimit(seconds = 10, maxCount = 3)
    @LogAnnotation(module="公共接口",operation= LogConst.GET)
    @GetMapping("/ip/detail")
    public ResponseResult<IpDetail> ipDetail(HttpServletRequest request) {
        String ip = IpUtils.getIpAddr(request);
        IpDetail detail = IpServiceImpl.getIpDetailOrNull(ip);
        if (detail == null) {
            detail = IpDetail.builder().ip(ip).country("未知").region("").city("").isp("").build();
        }
        return ResponseResult.success(detail);
    }

}
