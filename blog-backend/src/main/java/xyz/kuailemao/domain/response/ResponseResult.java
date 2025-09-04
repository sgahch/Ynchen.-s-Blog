package xyz.kuailemao.domain.response;

// 1. 删掉所有 fastjson 的 import
// import com.alibaba.fastjson2.JSONObject;
// import com.alibaba.fastjson2.JSONWriter;

// 2. 引入 Jackson 的 ObjectMapper
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.kuailemao.enums.RespEnum;

/**
 * 统一响应类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
// 这个 Jackson 注解可以确保在序列化时，值为null的字段不会被包含在JSON结果中
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ResponseResult<T> {
    /**
     * 状态码
     */
    @Schema(description = "状态码")
    private Integer code;
    /**
     * 提示信息，如果有错误时，前端可以获取该字段进行提示
     */
    @Schema(description = "提示信息")
    private String msg;
    /**
     * 查询到的结果数据，
     */
    @Schema(description = "查询到的结果数据")
    private T data;

    /**
     * 成功响应，不需要返回数据
     */
    public static <T> ResponseResult<T> success() {
        return new ResponseResult<>(RespEnum.SUCCESS.getCode(), RespEnum.SUCCESS.getMsg(), null);
    }

    /**
     * 成功响应，需要返回数据
     */
    public static <T> ResponseResult<T> success(T data) {
        return new ResponseResult<>(RespEnum.SUCCESS.getCode(), RespEnum.SUCCESS.getMsg(), data);
    }

    /**
     * 成功响应，需要返回数据跟信息
     */
    public static <T> ResponseResult<T> success(T data, String msg) {
        return new ResponseResult<>(RespEnum.SUCCESS.getCode(), msg, data);
    }

    /**
     * 失败响应，不需要返回数据
     */
    public static <T> ResponseResult<T> failure(Integer code, String msg) {
        return new ResponseResult<>(code, msg, null);
    }

    /**
     * 失败响应，不需要返回数据
     */
    public static <T> ResponseResult<T> failure() {
        return new ResponseResult<>(RespEnum.FAILURE.getCode(), RespEnum.FAILURE.getMsg(), null);
    }

    public static <T> ResponseResult<T> failure(String msg) {
        return new ResponseResult<>(RespEnum.FAILURE.getCode(), msg, null);
    }

    public static <T> ResponseResult<T> failure(T data) {
        return new ResponseResult<>(RespEnum.FAILURE.getCode(), RespEnum.FAILURE.getMsg(), data);
    }


    // 3. 改造 asJsonString 方法，使用 Jackson
    /**
     * 转json字符串
     *
     * @return {@link String}
     */
    public String asJsonString() {
        try {
            // ObjectMapper 是 Jackson 库的核心，用于序列化和反序列化
            ObjectMapper objectMapper = new ObjectMapper();
            // writeValueAsString 方法可以将任何Java对象转换为JSON字符串
            return objectMapper.writeValueAsString(this);
        } catch (Exception e) {
            // 异常处理，防止在序列化失败时整个应用崩溃
            // 生产环境中建议使用日志记录 e.printStackTrace();
            return "{\"code\":500,\"msg\":\"Error serializing response object\"}";
        }
    }
}