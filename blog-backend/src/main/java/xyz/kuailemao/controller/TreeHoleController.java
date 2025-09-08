package xyz.kuailemao.controller;

// 1. 引入 Jackson 的 ObjectMapper
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import xyz.kuailemao.annotation.AccessLimit;
import xyz.kuailemao.annotation.CheckBlacklist;
import xyz.kuailemao.annotation.LogAnnotation;
import xyz.kuailemao.constants.LogConst;
import xyz.kuailemao.domain.dto.SearchTreeHoleDTO;
import xyz.kuailemao.domain.dto.TreeHoleIsCheckDTO;
import xyz.kuailemao.domain.response.ResponseResult;
import xyz.kuailemao.domain.vo.TreeHoleListVO;
import xyz.kuailemao.domain.vo.TreeHoleVO;
import xyz.kuailemao.service.TreeHoleService;
import xyz.kuailemao.utils.ControllerUtils;

import java.io.IOException;
import java.util.List;

/**
 * @author kuailemao
 * <p>
 * 创建时间：2023/10/30 11:20
 */
@RestController
@Tag(name = "树洞相关接口")
@RequestMapping("/treeHole")
@Validated
public class TreeHoleController {

    @Resource
    private TreeHoleService treeHoleService;

    // 2. 注入一个 ObjectMapper Bean，这是更高效和推荐的做法
    @Resource
    private ObjectMapper objectMapper;

    @CheckBlacklist
    @Operation(summary = "添加树洞")
    @AccessLimit(seconds = 60, maxCount = 60)
    @PostMapping("/auth/addTreeHole")
    public ResponseResult<Void> addTreeHole(@Valid @NotNull @RequestBody String requestBody) {
        // 3. 使用 Jackson 来解析JSON字符串
        try {
            JsonNode rootNode = objectMapper.readTree(requestBody);
            if (rootNode.has("content")) {
                String content = rootNode.get("content").asText();
                return treeHoleService.addTreeHole(content);
            } else {
                return ResponseResult.failure("请求体中缺少 'content' 字段");
            }
        } catch (IOException e) {
            // 当传入的字符串不是一个合法的JSON时，会抛出异常
            return ResponseResult.failure("无效的JSON格式");
        }
    }

    @Operation(summary = "查看树洞")
    @AccessLimit(seconds = 60, maxCount = 60)
    @GetMapping("/getTreeHoleList")
    public ResponseResult<List<TreeHoleVO>> getTreeHoleList() {
        return ControllerUtils.messageHandler(() -> treeHoleService.getTreeHole());
    }

    @PreAuthorize("hasAnyAuthority('blog:treeHole:list')")
    @Operation(summary = "后台树洞列表")
    @AccessLimit(seconds = 60, maxCount = 30)
    @LogAnnotation(module="树洞管理",operation= LogConst.GET)
    @GetMapping("/back/list")
    public ResponseResult<List<TreeHoleListVO>> backList() {
        return ControllerUtils.messageHandler(() -> treeHoleService.getBackTreeHoleList(null));
    }

    @PreAuthorize("hasAnyAuthority('blog:treeHole:search')")
    @Operation(summary = "搜索后台树洞列表")
    @AccessLimit(seconds = 60, maxCount = 30)
    @LogAnnotation(module="树洞管理",operation= LogConst.SEARCH)
    @PostMapping("/back/search")
    public ResponseResult<List<TreeHoleListVO>> backList(@RequestBody SearchTreeHoleDTO searchDTO) {
        return ControllerUtils.messageHandler(() -> treeHoleService.getBackTreeHoleList(searchDTO));
    }

    @PreAuthorize("hasAnyAuthority('blog:treeHole:isCheck')")
    @Operation(summary = "修改树洞是否通过")
    @AccessLimit(seconds = 60, maxCount = 30)
    @LogAnnotation(module="树洞管理",operation= LogConst.UPDATE)
    @PostMapping("/back/isCheck")
    public ResponseResult<Void> isCheck(@RequestBody @Valid TreeHoleIsCheckDTO treeHoleIsCheckDTO) {
        return treeHoleService.isCheckTreeHole(treeHoleIsCheckDTO);
    }

    @PreAuthorize("hasAnyAuthority('blog:treeHole:delete')")
    @Operation(summary = "删除树洞")
    @AccessLimit(seconds = 60, maxCount = 30)
    @LogAnnotation(module="树洞管理",operation= LogConst.DELETE)
    @DeleteMapping("/back/delete")
    public ResponseResult<Void> delete(@RequestBody List<Long> ids) {
        return treeHoleService.deleteTreeHole(ids);
    }
}