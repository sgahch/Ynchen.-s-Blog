## 目标

* 删除侧边栏的“充电榜”卡片

* 新增一张展示“当前登录者 IP 所在地区的天气与位置”的卡片，显示城市/行政区与实时气温/天气现象

## 数据来源与接口设计

* IP→位置：后端已有 IP 解析能力（淘宝与 PCOnline 接口），但目前未对外提供公开接口

  * 相关能力：<mcfile name="IpUtils.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\utils\IpUtils.java"></mcfile> <mcsymbol name="getIpAddr" filename="IpUtils.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\utils\IpUtils.java" startline="21" type="function"></mcsymbol>；<mcfile name="IpServiceImpl.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\service\impl\IpServiceImpl.java"></mcfile> <mcsymbol name="getIpDetailOrNull" filename="IpServiceImpl.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\service\impl\IpServiceImpl.java" startline="265" type="function"></mcsymbol>

* 新增后端公开接口：在 <mcfile name="PublicController.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\controller\PublicController.java"></mcfile> 下增加 `GET /public/ip/detail`，返回 `IpDetail`（国家/省/市/区/ISP 等）。

* 天气数据：前端调用 Open-Meteo 免费无鉴权方案

  * 地理编码：`https://geocoding-api.open-meteo.com/v1/search?name={city}&language=zh&count=1`

  * 天气：`https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,weather_code,wind_speed_10m`

  * 前端做天气码→文案/图标映射，无需密钥与服务端改动

## 前端改动

* 删除“充电榜”卡片：移除 <mcfile name="index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Layout\SideBar\ChargingList\index.vue"></mcfile> 在侧边栏的引用

  * 修改文件：<mcfile name="index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Layout\SideBar\index.vue"></mcfile>，删除 `<ChargingList/>`

* 新增“天气与位置”卡片组件

  * 路径：<mcfile name="index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Card\WeatherLocationCard\index.vue"></mcfile>

  * 逻辑：

    * 挂载后请求 `GET /public/ip/detail` 获取 `province/city/district`

    * 用城市名进行 Open-Meteo 地理编码获取 `lat/lon`

    * 拉取当前天气数据并映射图标与文案

    * UI 复用通用 `Card` 样式 <mcfile name="index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Card\index.vue"></mcfile>

  * 展示：城市（带省份缩写或全称）、气温（℃）、天气现象、风速；加载中显示骨架/占位

* 集成：在 <mcfile name="index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Layout\SideBar\index.vue"></mcfile> 中引入并在原“充电榜”位置插入新卡片

## 后端改动

* 控制器：在 <mcfile name="PublicController.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\controller\PublicController.java"></mcfile> 增加方法 `ipDetail(HttpServletRequest)`，从请求头解析真实 IP（考虑 `X-Forwarded-For`），调用 <mcsymbol name="getIpDetailOrNull" filename="IpServiceImpl.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\service\impl\IpServiceImpl.java" startline="265" type="function"></mcsymbol> 返回位置信息。

* 安全与健壮：设置合理速率限制、超时与失败回退（如返回仅城市字符串）。不记录或暴露任何敏感信息。

## 验收标准

* 侧边栏“充电榜”被移除

* 新卡片显示城市（省/市/区）与实时天气，加载与失败有清晰反馈

* 移动端与暗色模式样式与现有卡片一致

* 不引入密钥，网络异常不影响整体页面

## 备选方案（无需后端改动）

* 如果你希望更快上线且后端不改动：前端直接调用 `ipapi.co/json`（或其他无密钥 IP 接口）获取城市，再走 Open-Meteo；但需考虑第三方的 CORS 与速率限制。

请确认上述方案与接口选择（后端公开 `/public/ip/detail` 或走纯前端），我将据此开始实现并交付。
