## 统计逻辑评审结论
- 前台：文章详情首次进入基于 `sessionStorage` 做去重，并调用 `GET /article/visit/{id}` 进行上报，避免刷新重复统计。
  - 相关：<mcfile name="src/views/Article/index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\views\Article\index.vue"></mcfile> <mcfile name="src/apis/article/index.ts" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\apis\article\index.ts"></mcfile> <mcfile name="src/const/Visits/index.ts" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\const\Visits\index.ts"></mcfile>
- 后台：基于 `ip + articleId` 的 15 分钟限流窗口控制重复上报，使用 Redis 自增并定期落库；站点聚合使用 `SUM(visit_count)`。
  - 相关：<mcfile name="ArticleController.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\controller\ArticleController.java"></mcfile> <mcfile name="ArticleServiceImpl.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\service\impl\ArticleServiceImpl.java"></mcfile> <mcfile name="RefreshTheCache.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\quartz\RefreshTheCache.java"></mcfile> <mcfile name="WebsiteInfoServiceImpl.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\service\impl\WebsiteInfoServiceImpl.java"></mcfile> <mcfile name="ArticleMapper.xml" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\resources\mapper\ArticleMapper.xml"></mcfile>
- 结论：整体链路清晰，能较好抑制短时间重复计数；站点汇总使用数据库值避免 Redis/DB 双计的问题。

## 潜在问题与改进建议
- IP 代表性有限：NAT/代理会导致多人共享同一 IP；建议在反向代理层正确解析 `X-Forwarded-For` 并取可信链首地址。
- 机器人与爬虫：建议基于 UA/路径规则与 `robots` 策略排除常见爬虫，避免数据污染。
- 窗口策略：`15min` 对活跃读者的二次访问去重较强，视需求可按“每用户每文章每天一次”改为 Cookie/LocalStorage 辅助。
- 真实 IP 获取校验：确认后端真实 IP 提取位置与可信代理配置，避免都记到网关 IP。
- 任务落库语义：确认 Quartz 落库是“覆盖为 Redis 值”而非“累加”，确保聚合一致。

## 卡片设计与数据来源
- 数据来源：站点信息接口的 `visitCount`（全站访问量聚合）
  - 相关：<mcfile name="WebsiteInfoController.java" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-backend\src\main\java\xyz\kuailemao\controller\WebsiteInfoController.java"></mcfile>、前台调用与 Store：<mcfile name="src/store/modules/website.ts" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\store\modules\website.ts"></mcfile> <mcfile name="src/components/Layout/SideBar/index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Layout\SideBar\index.vue"></mcfile>
- 展示样式：新建 `SiteVisitCard` 小卡片，使用现有 `Card` 组件风格统一显示“全站浏览量”，格式化为千分位并含小图标。
- 更新策略：主页加载时若 `useWebsite.webInfo` 为空则触发 `getWebsiteInfo()` 拉取；侧边栏挂载后即可展示。

## 页面接入位置
- 主页主体在 `Main` 布局的 `#information` 右侧栏插槽中渲染 `SideBar`。
  - 相关：<mcfile name="src/views/Home/Main/index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\views\Home\Main\index.vue"></mcfile> <mcfile name="src/components/Layout/Main/index.vue" path="c:\Users\Ynchen\Desktop\Ruyu-Blog\blog-frontend\kuailemao-blog\src\components\Layout\Main\index.vue"></mcfile>
- 方案：在 `src/components/Layout/SideBar/index.vue` 中将 `SiteVisitCard` 插入到 `InfoCard` 后、公告卡片前，保证靠前可见性且视觉层级合理。

## 实施步骤
1. 新增组件 `SiteVisitCard`（采用现有 `Card` 包裹，展示标题与 `useWebsite.webInfo.visitCount`，含图标与千分位格式化）。
2. 在 `SideBar/index.vue` 引入并注册 `SiteVisitCard`，按规划位置插入。
3. 确认 `website` store 在主页路径加载时拉取站点信息；若无则在侧边栏 `onMounted` 时确保触发一次拉取。
4. 视觉适配：对齐 Tailwind/SCSS 变量，保证与其他卡片间距和阴影一致；暗色模式适配。
5. 自测：主页右侧出现卡片且数值与“网站资讯”一致；切换语言与暗色模式显示正确。

## 验收标准
- 卡片在主页右侧栏可见，标题为“全站浏览量”，数值同步于站点信息接口。
- Lighthouse 无显著回归；在弱网下卡片加载回退为骨架或占位。
- 暗色模式与移动端断点显示正常（如隐藏或栅格重排与现有布局一致）。

确认后我将按上述步骤为你添加卡片，并可在后续迭代中逐步完善统计逻辑。