# Ruyu-Blog 前台系统

## 📋 项目介绍

Ruyu-Blog 前台系统是一个基于 Vue 3 + TypeScript + Tailwind CSS 构建的现代化博客展示界面，为访问者提供优雅、流畅的阅读体验。系统支持文章阅读、评论互动、分类浏览、标签搜索、暗黑模式等多种功能，同时兼顾了美观的视觉设计和良好的响应式体验。

## 🛠️ 技术栈

- **前端框架**：Vue 3
- **构建工具**：Vite
- **编程语言**：TypeScript
- **UI 框架**：Element Plus + Tailwind CSS
- **状态管理**：Pinia
- **路由管理**：Vue Router
- **HTTP 客户端**：Axios
- **CSS 预处理器**：SCSS
- **图标库**：Font Awesome + 自定义 SVG 图标
- **动画效果**：CSS 动画 + JavaScript 动画
- **Markdown 渲染**：markdown-it
- **容器化**：Docker

## 📁 项目结构

```
blog-frontend/kuailemao-blog/src/
├── App.vue                     # 应用入口组件
├── apis/                       # API 接口定义
│   ├── article/                # 文章相关接口
│   ├── category/               # 分类相关接口
│   ├── comment/                # 评论相关接口
│   ├── user/                   # 用户相关接口
│   └── ...                     # 其他业务接口
├── assets/                     # 静态资源
│   ├── cursor/                 # 自定义光标
│   ├── icons/                  # 图标资源
│   ├── images/                 # 图片资源
│   └── woff/                   # 字体文件
├── components/                 # 公共组件
│   ├── Banner/                 # 轮播图组件
│   ├── Comment/                # 评论组件
│   ├── Layout/                 # 布局组件
│   │   ├── Footer/             # 页脚组件
│   │   ├── Header/             # 头部组件
│   │   ├── Main/               # 主内容区组件
│   │   └── SideBar/            # 侧边栏组件
│   ├── Card/                   # 卡片组件
│   └── ...                     # 其他通用组件
├── config/                     # 配置文件
├── const/                      # 常量定义
├── directives/                 # 自定义指令
├── main.ts                     # 应用入口文件
├── router/                     # 路由配置
│   ├── index.ts                # 路由入口
│   └── routers.ts              # 路由定义
├── store/                      # Pinia 状态管理
│   ├── index.ts                # store 入口
│   └── modules/                # 模块状态
│       ├── loading.ts          # 加载状态
│       ├── pagination.ts       # 分页状态
│       ├── user.ts             # 用户状态
│       └── website.ts          # 网站状态
├── styles/                     # 样式文件
├── types/                      # TypeScript 类型定义
├── utils/                      # 工具函数
│   ├── http.ts                 # HTTP 请求工具
│   ├── tool.ts                 # 通用工具函数
│   └── ...                     # 其他工具函数
├── views/                      # 页面组件
└── vite-env.d.ts               # Vite 环境类型声明
```

## 🏗️ 系统架构详解

### 整体架构

Ruyu-Blog 前台系统采用现代化前端架构，基于 Vue 3 的组合式 API 构建，实现了组件化、模块化的前端应用。

![前端架构图](https://raw.githubusercontent.com/kuailemao/Ruyu-Blog/master/img/frontend_architecture.svg)

### 核心架构设计

1. **组件化设计**
   - 页面组件与业务组件分离
   - 通用组件复用机制
   - 组件化通信通过 Props/Events、Provide/Inject、Pinia 状态管理等多种方式实现

2. **状态管理**
   - 使用 Pinia 进行全局状态管理
   - 模块化的 store 设计，分离不同业务领域的状态
   - 响应式状态更新，确保视图与数据同步

3. **路由系统**
   - 基于 Vue Router 实现页面导航
   - 路由懒加载，提高首屏加载速度
   - 路由元信息，支持页面标题动态设置

4. **API 通信**
   - 统一的 API 请求封装
   - 请求拦截、响应拦截处理
   - 错误处理与重试机制

5. **样式系统**
   - 基于 Tailwind CSS 的实用优先样式方案
   - 自定义主题变量，支持暗黑模式
   - 响应式设计，适配多种设备

## ✨ 核心功能模块

### 📚 文章阅读
- 文章列表：分页展示、分类筛选、标签筛选
- 文章详情：Markdown 渲染、代码高亮、图片预览
- 目录导航：文章内容快速跳转
- 阅读模式：专注阅读体验
- 相关推荐：基于文章标签和分类推荐相关文章

### 💬 评论互动
- 多级评论：支持嵌套回复
- Markdown 支持：评论内容支持 Markdown 格式
- 表情包：评论支持插入表情包
- 点赞功能：支持对文章和评论点赞
- 收藏功能：支持收藏喜欢的文章

### 🔍 内容发现
- 分类浏览：按分类查看文章
- 标签云：热门标签展示与筛选
- 搜索功能：全文搜索文章内容
- 随机文章：随机推荐一篇文章
- 树洞功能：匿名留言板

### 🎨 用户体验
- 暗黑模式：一键切换明暗主题
- 响应式设计：完美适配手机、平板、PC
- 平滑滚动：页面内平滑导航
- 返回顶部：快速返回页面顶部
- 背景动画：动态背景效果
- 鼠标特效：自定义鼠标样式和动效

### 👥 用户中心
- 用户注册/登录：邮箱注册、第三方登录
- 个人主页：用户信息展示
- 我的收藏：查看已收藏的文章
- 我的评论：查看自己的评论记录
- 个人设置：修改个人信息

## 🚀 快速开始

### 环境要求
- Node.js 16+
- pnpm/npm/yarn

### 1. 安装依赖

```bash
cd blog-frontend/kuailemao-blog

# 使用 pnpm 安装依赖（推荐）
pnpm install

# 或使用 npm
npm install

# 或使用 yarn
yarn install
```

### 2. 配置环境变量

在项目根目录下创建 `.env.development` 文件，配置开发环境变量：

```env
# 开发环境配置
NODE_ENV=development

# API 基础路径
VITE_APP_BASE_URL=http://localhost:8088

# API 前缀
VITE_APP_BASE_API=/api
```

### 3. 启动开发服务器

```bash
# 使用 pnpm
pnpm run dev

# 或使用 npm
npm run dev

# 或使用 yarn
yarn dev
```

开发服务器启动后，可访问 `http://localhost:5174` 查看博客前台界面。

### 4. 构建生产版本

```bash
# 使用 pnpm
pnpm run build

# 或使用 npm
npm run build

# 或使用 yarn
yarn build
```

构建完成后，生产版本文件将生成在 `dist` 目录中。

## 🐳 Docker 部署

### 构建 Docker 镜像

```bash
cd blog-frontend/kuailemao-blog

docker build -t ruyu-blog-front .
```

### 运行 Docker 容器

```bash
docker run -d -p 80:80 --name ruyu-blog-front ruyu-blog-front
```

## 🔧 开发指南

### 组件开发
- 遵循 Vue 3 组合式 API 最佳实践
- 使用 TypeScript 进行类型定义
- 组件命名遵循 PascalCase 规范
- 组件拆分粒度合理，提高复用性

### API 接口开发
- 按照功能模块组织 API 文件
- 统一处理请求和响应格式
- 添加接口参数和返回值类型定义

### 样式开发
- 优先使用 Tailwind CSS 工具类
- 自定义样式通过 `styles` 目录下的文件管理
- 响应式设计使用 Tailwind 的响应式前缀
- 主题变量通过 `styles/theme.scss` 管理

### 自定义指令

项目中实现了多个自定义指令，用于增强用户体验：

- **vLazy**：图片懒加载
- **vSlideIn**：元素滑入动画
- **vViewRequest**：视图请求处理

### 性能优化
- 使用路由懒加载减少首屏加载时间
- 图片懒加载减少带宽占用
- 组件按需引入减小打包体积
- 使用缓存减少重复请求

## 🤝 贡献指南

1. Fork 本项目
2. 创建新的分支（git checkout -b feature/your-feature）
3. 提交你的修改（git commit -am 'Add some feature'）
4. 推送到分支（git push origin feature/your-feature）
5. 创建 Pull Request

## 📝 许可证

本项目采用 Apache License 2.0 许可证。详情请查看 [LICENSE](../LICENSE) 文件。