# Ruyu-Blog 管理后台

## 📋 项目介绍

Ruyu-Blog 管理后台是基于 Vue 3 + Ant Design Vue Pro 构建的现代化博客管理系统前端界面，提供完整的博客内容管理、用户管理、权限控制等功能。系统采用前后端分离架构，通过 RESTful API 与后端服务进行通信，为博客管理员提供高效、直观的管理体验。

## 🛠️ 技术栈

- **前端框架**：Vue 3
- **构建工具**：Vite
- **编程语言**：TypeScript
- **UI 框架**：Ant Design Vue
- **状态管理**：Pinia
- **路由管理**：Vue Router
- **HTTP 客户端**：Axios
- **CSS 预处理器**：Less
- **图标库**：Ant Design Icons
- **国际化**：i18n
- **代码规范**：ESLint + Prettier
- **容器化**：Docker

## 📁 项目结构

```
blog-frontend/kuailemao-admin/src/
├── App.vue                     # 应用入口组件
├── api/                        # API 接口定义
│   ├── blog/                   # 博客相关接口
│   │   ├── article/            # 文章接口
│   │   ├── category/           # 分类接口
│   │   ├── comment/            # 评论接口
│   │   └── ...
│   ├── common/                 # 通用接口
│   ├── log/                    # 日志接口
│   ├── permission/             # 权限接口
│   ├── role/                   # 角色接口
│   └── user/                   # 用户接口
├── assets/                     # 静态资源
│   ├── images/                 # 图片资源
│   └── styles/                 # 样式文件
├── components/                 # 公共组件
│   ├── access/                 # 权限相关组件
│   ├── base-loading/           # 加载组件
│   ├── layout/                 # 布局组件
│   └── ...
├── composables/                # 组合式函数
│   ├── access.ts               # 权限相关函数
│   ├── api.ts                  # API 相关函数
│   └── ...
├── config/                     # 配置文件
├── directive/                  # 自定义指令
│   ├── access.ts               # 权限指令
│   ├── loading.ts              # 加载指令
│   └── ...
├── enums/                      # 枚举类型
├── layouts/                    # 页面布局
│   ├── basic-layout/           # 基础布局
│   ├── components/             # 布局组件
│   └── multi-tab/              # 多标签布局
├── locales/                    # 国际化资源
│   └── lang/                   # 语言文件
├── main.ts                     # 应用入口文件
├── pages/                      # 页面组件
│   ├── account/                # 账户相关页面
│   ├── blog/                   # 博客管理页面
│   │   ├── article/            # 文章管理
│   │   ├── category/           # 分类管理
│   │   ├── comment/            # 评论管理
│   │   └── ...
│   ├── common/                 # 通用页面
│   ├── exception/              # 异常页面
│   ├── system/                 # 系统管理页面
│   │   ├── log/                # 日志管理
│   │   ├── menu/               # 菜单管理
│   │   ├── permission/         # 权限管理
│   │   ├── role/               # 角色管理
│   │   └── user/               # 用户管理
│   └── welcome/                # 欢迎页面
├── router/                     # 路由配置
│   ├── index.ts                # 路由入口
│   ├── dynamic-routes.ts       # 动态路由
│   ├── router-guard.ts         # 路由守卫
│   └── static-routes.ts        # 静态路由
├── stores/                     # Pinia 状态管理
│   ├── app.ts                  # 应用状态
│   ├── layout-menu.ts          # 菜单状态
│   ├── multi-tab.ts            # 多标签状态
│   └── user.ts                 # 用户状态
└── utils/                      # 工具函数
    ├── request.ts              # 网络请求工具
    ├── tools.ts                # 通用工具
    └── ...
```

## 🏗️ 系统架构详解

### 整体架构

Ruyu-Blog 管理后台采用现代化前端架构，基于 Vue 3 的组合式 API 构建，实现了组件化、模块化的前端应用。

![前端架构图](https://raw.githubusercontent.com/kuailemao/Ruyu-Blog/master/img/frontend_architecture.svg)

### 核心架构设计

1. **组件化设计**
   - 页面级组件与业务组件分离
   - 通用组件复用机制
   - 组件间通信通过 Props/Events、Provide/Inject、Pinia 状态管理等多种方式实现

2. **状态管理**
   - 使用 Pinia 进行全局状态管理
   - 模块化的 store 设计，分离不同业务领域的状态
   - 响应式状态更新，确保视图与数据同步

3. **路由系统**
   - 静态路由与动态路由结合
   - 路由守卫实现权限控制
   - 支持多标签页功能

4. **API 通信**
   - 统一的 API 请求封装
   - 请求拦截、响应拦截处理
   - 错误处理与重试机制

5. **权限体系**
   - 基于角色的访问控制（RBAC）
   - 动态菜单与权限验证
   - 权限指令与权限函数双重控制

## ✨ 核心功能模块

### 🔐 权限管理
- 角色管理：创建、编辑、删除角色
- 权限分配：细粒度的权限控制
- 用户角色：用户与角色的关联管理
- 动态菜单：根据用户权限动态生成菜单

### 📝 内容管理
- **文章管理**：文章的发布、编辑、删除、分类、标签管理
- **分类管理**：创建多级分类结构
- **标签管理**：文章标签的增删改查
- **评论管理**：评论审核、回复、删除
- **友链管理**：友链申请审核与管理
- **树洞管理**：匿名留言的管理
- **留言板**：访客留言的管理

### 👥 用户管理
- 用户列表：查看、搜索、筛选用户
- 用户编辑：修改用户信息、重置密码
- 用户状态：启用/禁用用户账户
- 第三方登录：管理用户第三方账号绑定

### 📊 系统监控
- 操作日志：记录用户操作行为
- 登录日志：记录用户登录信息
- 服务监控：服务器资源使用情况
- 访问统计：网站访问量统计分析

### ⚙️ 系统配置
- 网站信息配置：网站标题、描述、Logo等
- 公告管理：发布和管理网站公告
- 轮播图管理：配置首页轮播图
- 黑名单管理：管理恶意用户和IP

## 🚀 快速开始

### 环境要求
- Node.js 16+
- pnpm/npm/yarn

### 1. 安装依赖

```bash
cd blog-frontend/kuailemao-admin

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

# 前端域名
VITE_APP_DOMAIN_NAME_FRONT=http://localhost:99
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

开发服务器启动后，可访问 `http://localhost:5173` 查看管理后台界面。

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
cd blog-frontend/kuailemao-admin

docker build -t ruyu-blog-admin .
```

### 运行 Docker 容器

```bash
docker run -d -p 80:80 --name ruyu-blog-admin ruyu-blog-admin
```

## 🔧 开发指南

### 组件开发
- 遵循 Vue 3 组合式 API 最佳实践
- 使用 TypeScript 进行类型定义
- 组件命名遵循 PascalCase 规范
- 添加组件文档注释

### API 接口开发
- 按照功能模块组织 API 文件
- 统一处理请求和响应格式
- 添加接口参数和返回值类型定义

### 权限控制

#### 支持方式
- 多角色权限控制
- 多权限点控制

#### 使用方法

**根据角色判断权限：**
- 方法1：在模板中使用 `v-if="hasRole(['admin'])"` 判断是否拥有 admin 角色
- 方法2：在模板中使用 `v-hasRole="[AccessEnum.USER, AccessEnum.ADMIN]"` 自定义指令

**根据权限字符判断权限：**
- 方法1：在模板中使用 `v-if="hasPermi(['user:add'])"` 判断是否拥有 user:add 权限
- 方法2：在模板中使用 `v-hasPermi="['user:add', 'user:delete']"` 自定义指令

### 路由配置

#### 父菜单配置
```typescript
{
  component: 'RouteView',
  redirect: '/dashboard/workplace',
  meta: {
    title: '主导航',
    icon: 'dashboard',
    permissions: ['dashboard']
  },
  children: []
}
```

#### 普通组件配置
```typescript
{
  path: 'article',
  component: './blog/article/index',
  meta: {
    title: '文章管理',
    icon: 'file-text',
    permissions: ['article:list']
  }
}
```

#### 内嵌组件配置
```typescript
{
  path: 'iframe',
  component: 'Iframe',
  meta: {
    title: '内嵌页面',
    icon: 'link'
  },
  props: {
    url: 'https://example.com'
  }
}
```

## 🤝 贡献指南

1. Fork 本项目
2. 创建新的分支（git checkout -b feature/your-feature）
3. 提交你的修改（git commit -am 'Add some feature'）
4. 推送到分支（git push origin feature/your-feature）
5. 创建 Pull Request

## 📝 许可证

本项目采用 Apache License 2.0 许可证。详情请查看 [LICENSE](LICENSE) 文件。
