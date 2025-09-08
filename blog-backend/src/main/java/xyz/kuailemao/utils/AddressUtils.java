package xyz.kuailemao.utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import xyz.kuailemao.constants.Const;

/**
 * 获取地址类 (已使用 Jackson 重构)
 *
 * @author ruoyi
 */
public class AddressUtils {
    private static final Logger log = LoggerFactory.getLogger(AddressUtils.class);

    // IP地址查询 API
    public static final String IP_URL = "http://whois.pconline.com.cn/ipJson.jsp";

    // 未知地址常量
    public static final String UNKNOWN = "未知";

    // 创建一个静态的 ObjectMapper 实例。
    // ObjectMapper 的创建是重量级的，推荐复用。
    private static final ObjectMapper MAPPER = new ObjectMapper();

    /**
     * 根据 IP 地址获取真实的地理位置
     *
     * @param ip 查询的IP地址
     * @return 地理位置字符串，格式为 "省份 城市"
     */
    public static String getRealAddressByIP(String ip) {
        // 1. 内网不查询
        if (IpUtils.internalIp(ip)) {
            return "内网IP";
        }

        try {
            // 2. 发送 HTTP GET 请求
            // 注意: HttpUtils.sendGet 是您项目中的方法，这里假设它能正常工作
            String rspStr = HttpUtils.sendGet(IP_URL, "ip=" + ip + "&json=true", Const.GBK);

            // 3. 检查响应是否为空
            // 这里使用了 Spring Framework 的 StringUtils，它对 null 和空字符串都有判断
            if (!StringUtils.hasText(rspStr)) {
                log.error("获取地理位置异常，API响应为空。IP: {}", ip);
                return UNKNOWN;
            }

            // 4. 使用 Jackson 的 ObjectMapper 解析 JSON 字符串
            // mapper.readTree() 会将 JSON 字符串转换成一个树形结构的 JsonNode 对象
            JsonNode rootNode = MAPPER.readTree(rspStr);

            // 5. 从 JsonNode 中安全地获取省份和城市信息
            // .path("key") 方法即使在 key 不存在时也不会抛出异常，而是返回一个 MissingNode
            // .asText() 方法会尝试将节点值转为文本，如果节点不存在或不是文本，则返回空字符串 ""
            String region = rootNode.path("pro").asText();
            String city = rootNode.path("city").asText();

            // 6. 校验获取到的地址信息是否有效
            if (!StringUtils.hasText(region) && !StringUtils.hasText(city)) {
                log.warn("从API响应中未能解析出有效的地址信息。IP: {}, Response: {}", ip, rspStr);
                return UNKNOWN;
            }

            // 7. 格式化并返回结果
            return String.format("%s %s", region, city).trim();

        } catch (Exception e) {
            // 捕获所有可能的异常（网络、IO、JSON解析等）
            log.error("获取地理位置时发生异常。IP: {}", ip, e);
        }

        // 如果发生任何异常，都返回未知
        return UNKNOWN;
    }
}