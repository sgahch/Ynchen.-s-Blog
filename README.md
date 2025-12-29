# Ruyu-Blog 2.0 文档

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/kuailemao/Ruyu-Blog?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/kuailemao/Ruyu-Blog?style=flat-square)
![GitHub license](https://img.shields.io/github/license/kuailemao/Ruyu-Blog?style=flat-square)
![Java Version](https://img.shields.io/badge/Java-17+-blue?style=flat-square)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1.4-green?style=flat-square)
![Vue](https://img.shields.io/badge/Vue-3.x-brightgreen?style=flat-square)

**一个功能完善的现代化全栈博客系统**

[在线演示](http://your-demo-url.com) · [使用文档](https://github.com/kuailemao/Ruyu-Blog/wiki) · [反馈问题](https://github.com/kuailemao/Ruyu-Blog/issues)

![GitHub 贡献贪吃蛇](https://raw.githubusercontent.com/yuaotian/yuaotian/refs/heads/output/github-contribution-grid-snake.svg)

</div>

---

## 目录

- [项目概述](#项目概述)
- [技术栈](#技术栈)
- [系统架构](#系统架构)
- [数据库设计](#数据库设计)
- [API接口文档](#api接口文档)
- [前端架构](#前端架构)
- [核心功能](#核心功能)
- [项目结构](#项目结构)
- [快速开始](#快速开始)
- [配置说明](#配置说明)
- [开发指南](#开发指南)
- [常见问题](#常见问题)
- [路线图](#路线图)
- [贡献者](#贡献者)
- [许可证](#许可证)

---

## 项目概述

### 简介

**Ruyu-Blog（如雨博客）** 是一个基于 Spring Boot 3.1.4 + Vue 3 构建的现代化全栈博客系统。采用前后端分离架构，集成了完整的用户管理、内容管理、权限控制、消息队列、缓存系统等企业级功能。

### 核心特性

| 特性 | 描述 |
|------|------|
| **前后端分离** | 后端提供 RESTful API，前端独立部署 |
| **双前端设计** | 博客前台展示 + 管理后台分离 |
| **企业级技术栈** | Spring Boot 3.x + MyBatis-Plus + Redis + RabbitMQ |
| **高可用架构** | 多级缓存策略 + 消息队列 + 容器化部署 |
| **完整权限系统** | JWT + Spring Security + RBAC 权限模型 |

### 项目定位

- 个人博客站点
- 技术分享平台
- 学习参考项目（二次开发基础）
- 团队内容管理系统

---

## 技术栈

### 后端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.1.4 | 基础框架，自动配置和快速开发 |
| Spring Security | 6.x | 安全框架，认证和授权 |
| Spring AOP | - | 面向切面编程，日志和权限控制 |
| MyBatis-Plus | 3.5.3.1 | ORM框架，简化数据库操作 |
| MySQL | 8.0+ | 关系型数据库 |
| Redis | 6.0+ | 缓存数据库，高性能访问 |
| MinIO | Latest | 对象存储，文件管理 |
| RabbitMQ | 3.8+ | 消息队列，异步任务处理 |
| JWT | 0.9.1 | 无状态身份验证 |
| Knife4j | 4.4.0 | API文档生成和在线测试 |
| Quartz | 2.3.2 | 定时任务调度 |
| Lombok | 1.18.30 | 简化Java代码 |
| Hutool | 5.8.24 | Java工具类库 |
| FastJSON2 | 2.0.43 | JSON序列化 |

### 前端技术栈

#### 博客前台 (kuailemao-blog)

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.21 | 渐进式JavaScript框架 |
| Vite | 5.4.11 | 下一代前端构建工具 |
| TypeScript | 5.9.2 | 静态类型检查 |
| Element Plus | 2.8.6 | Vue 3 UI组件库 |
| Tailwind CSS | 3.4.15 | 原子化CSS框架 |
| Pinia | 2.2.6 | 状态管理 |
| Vue Router | 4.5.0 | 路由管理 |
| Axios | 1.7.9 | HTTP请求库 |
| md-editor-v3 | 2.3.1 | Markdown编辑器 |
| ECharts | 5.6.0 | 图表库 |
| GSAP | 3.12.5 | 动画库 |
| Swiper | 11.1.15 | 轮播组件 |

#### 管理后台 (kuailemao-admin)

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.21 | 渐进式JavaScript框架 |
| Ant Design Vue | 4.2.6 | 企业级UI组件库 |
| UnoCSS | 0.56.5 | 原子化CSS引擎 |
| Vue I18n | 9.15.2 | 国际化支持 |

---

## 系统架构

### 整体架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        用户浏览器                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐         ┌──────────────────┐              │
│  │  kuailemao-blog  │         │ kuailemao-admin  │              │
│  │    (前台展示)     │         │   (管理后台)      │              │
│  └────────┬─────────┘         └────────┬─────────┘              │
│           │                            │                        │
│           └──────────┬─────────────────┘                        │
│                      ▼                                          │
│           ┌─────────────────────┐                               │
│           │    Nginx/CDN        │                               │
│           │   (负载均衡/静态资源) │                               │
│           └──────────┬──────────┘                               │
│                      │                                          │
└──────────────────────┼──────────────────────────────────────────┘
                       │
┌──────────────────────┼──────────────────────────────────────────┐
│                      ▼                                          │
│           ┌─────────────────────┐                               │
│           │   Spring Boot 3.1   │                               │
│           │   (blog-backend)    │                               │
│           └──────────┬──────────┘                               │
│                      │                                          │
│     ┌────────────────┼────────────────┐                         │
│     ▼                ▼                ▼                         │
│ ┌────────┐     ┌───────────┐    ┌──────────┐                   │
│ │  MySQL │     │   Redis   │    │ RabbitMQ │                   │
│ │  8.0+  │     │   6.0+    │    │  3.8+    │                   │
│ └────────┘     └───────────┘    └──────────┘                   │
│                      │                                          │
│                      ▼                                          │
│               ┌────────────┐                                    │
│               │   MinIO    │                                    │
│               │ (对象存储)  │                                    │
│               └────────────┘                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 后端架构 (三层架构)

```
┌─────────────────────────────────────────────────────────────┐
│                      Controller Layer (24个控制器)           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │ Article  │ │  User    │ │ Comment  │ │  Admin   │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
├─────────────────────────────────────────────────────────────┤
│                      Service Layer                           │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 业务逻辑层: 认证授权 | 文章管理 | 评论系统 | 文件上传 │    │
│  │           | 定时任务 | 消息队列 | 缓存管理           │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                      Mapper Layer                            │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 数据访问层: 继承BaseMapper<T>                        │    │
│  │ 自定义SQL | 批量操作 | 复杂查询                      │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │  Entity  │ │   VO     │ │   DTO    │ │ Request  │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
├─────────────────────────────────────────────────────────────┤
│                      Infrastructure                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │ Security │ │   JWT    │ │  Redis   │ │  Config  │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### 前端架构

```
┌─────────────────────────────────────────────────────────────┐
│                      Views (页面层)                          │
│  Home | Article | Pigeonhole | Amusement | Photo | Link     │
├─────────────────────────────────────────────────────────────┤
│                     Components (组件层)                       │
│  Layout | Card | Comment | Banner | Search | Effects        │
├─────────────────────────────────────────────────────────────┤
│                    Store (Pinia状态管理)                      │
│  user | website | loading | pagination                       │
├─────────────────────────────────────────────────────────────┤
│                     Router (路由)                            │
│  路由守卫 | 动态路由 | 权限路由                               │
├─────────────────────────────────────────────────────────────┤
│                     Utils (工具层)                           │
│  HTTP封装 | 认证工具 | 性能优化 | 特效实现                    │
├─────────────────────────────────────────────────────────────┤
│                     Styles (样式层)                          │
│  TailwindCSS | 主题变量 | 动画特效                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 数据库设计

### 数据库信息

- **数据库类型**: MySQL 8.0+
- **字符集**: utf8mb4
- **存储引擎**: InnoDB
- **软删除**: 所有业务表支持软删除 (`is_deleted` 字段)

### 核心数据表

#### 1. 系统管理表 (sys_)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| `sys_user` | 用户表 | username, password, email, avatar |
| `sys_role` | 角色表 | role_name, role_key |
| `sys_permission` | 权限表 | permission_key, menu_id |
| `sys_menu` | 菜单表 | title, path, component |
| `sys_user_role` | 用户-角色关联 | user_id, role_id |
| `sys_role_menu` | 角色-菜单关联 | role_id, menu_id |
| `sys_role_permission` | 角色-权限关联 | role_id, permission_id |
| `sys_website_info` | 网站配置 | website_name, webmaster_info |
| `sys_log` | 操作日志 | operator, method, params |
| `sys_login_log` | 登录日志 | username, ip, address |

#### 2. 业务数据表 (t_)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| `t_article` | 文章表 | user_id, title, content, status |
| `t_category` | 分类表 | category_name |
| `t_tag` | 标签表 | tag_name |
| `t_article_tag` | 文章-标签关联 | article_id, tag_id |
| `t_comment` | 评论表 | type, type_id, parent_id |
| `t_leave_word` | 留言板 | user_id, content |
| `t_tree_hole` | 树洞 | user_id, content (匿名) |
| `t_like` | 点赞表 | user_id, type, type_id |
| `t_favorite` | 收藏表 | user_id, type, type_id |
| `t_link` | 友链表 | name, url, description |
| `t_photo` | 相册表 | user_id, name, url, parent_id |
| `t_banners` | 轮播图表 | path, sort_order |
| `t_black_list` | 黑名单表 | user_id, ip, reason |

#### 3. 定时任务表 (QRTZ_)

基于 Quartz 框架的定时任务调度系统：
- `QRTZ_JOB_DETAILS` - 任务详情
- `QRTZ_TRIGGERS` - 触发器
- `QRTZ_CRON_TRIGGERS` - Cron触发器
- `QRTZ_SIMPLE_TRIGGERS` - 简单触发器
- `QRTZ_FIRED_TRIGGERS` - 已触发任务
- `QRTZ_LOCKS` - 锁
- `QRTZ_SCHEDULER_STATE` - 调度器状态

### ER 关系图

```
sys_user (用户)
    │
    ├── t_article (文章)
    │       ├── t_category (分类)
    │       ├── t_tag (标签) ── t_article_tag (关联)
    │       ├── t_comment (评论)
    │       │       ├── t_like (点赞)
    │       │       └── t_favorite (收藏)
    │       └── t_photo (相册)
    │
    ├── t_leave_word (留言)
    ├── t_tree_hole (树洞)
    ├── t_link (友链)
    ├── t_banners (轮播图)
    └── t_black_list (黑名单)

sys_user ── sys_user_role ── sys_role
                              ├── sys_role_menu ── sys_menu
                              └── sys_role_permission ── sys_permission
```

### 核心表结构详情

#### sys_user (用户表)

```sql
CREATE TABLE sys_user (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT,
    nickname        VARCHAR(50)     COMMENT '用户昵称',
    username        VARCHAR(50)     COMMENT '用户名',
    password        VARCHAR(100)    COMMENT '密码(BCrypt加密)',
    avatar          VARCHAR(255)    COMMENT '头像',
    email           VARCHAR(50)     COMMENT '邮箱',
    gender          TINYINT         COMMENT '性别(0未定义1男2女)',
    intro           VARCHAR(255)    COMMENT '个人简介',
    register_type   TINYINT         COMMENT '注册方式(0邮箱1Gitee2Github)',
    register_ip     VARCHAR(50)     COMMENT '注册IP',
    login_ip        VARCHAR(50)     COMMENT '登录IP',
    is_disable      TINYINT         COMMENT '是否禁用(0否1是)',
    login_time      DATETIME        COMMENT '最近登录时间',
    create_time     DATETIME        COMMENT '创建时间',
    update_time     DATETIME        COMMENT '更新时间',
    is_deleted      TINYINT         COMMENT '是否删除(0否1是)'
) COMMENT '用户表';
```

#### t_article (文章表)

```sql
CREATE TABLE t_article (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id         BIGINT          COMMENT '作者ID',
    category_id     BIGINT          COMMENT '分类ID',
    article_cover   VARCHAR(1024)   COMMENT '封面图',
    article_title   VARCHAR(100)    COMMENT '标题',
    article_content LONGTEXT        COMMENT '内容(Markdown)',
    article_type    TINYINT         COMMENT '类型(1原创2转载3翻译)',
    is_top          TINYINT         COMMENT '是否置顶(0否1是)',
    status          TINYINT         COMMENT '状态(1公开2私密3草稿)',
    visit_count     BIGINT DEFAULT 0 COMMENT '访问量',
    create_time     DATETIME        COMMENT '创建时间',
    update_time     DATETIME        COMMENT '更新时间',
    is_deleted      TINYINT         COMMENT '是否删除(0否1是)'
) COMMENT '文章表';
```

#### t_comment (评论表)

```sql
CREATE TABLE t_comment (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT,
    type            TINYINT         COMMENT '类型(1文章2留言板)',
    type_id         BIGINT          COMMENT '目标ID',
    parent_id       BIGINT          COMMENT '父评论ID',
    reply_id        BIGINT          COMMENT '回复评论ID',
    comment_content TEXT            COMMENT '评论内容',
    comment_user_id BIGINT          COMMENT '评论用户ID',
    reply_user_id   BIGINT          COMMENT '被回复用户ID',
    is_check        TINYINT         COMMENT '审核状态(0未通过1通过)',
    create_time     DATETIME        COMMENT '评论时间',
    update_time     DATETIME        COMMENT '更新时间',
    is_deleted      TINYINT         COMMENT '是否删除(0否1是)'
) COMMENT '评论表';
```

---

## API接口文档

### 接口概览

| 模块 | 接口数 | 主要功能 |
|------|--------|----------|
| 文章 | 15+ | 列表、详情、搜索、推荐、归档 |
| 用户 | 10+ | 登录、注册、信息修改、第三方登录 |
| 评论 | 8+ | 列表、发布、回复、审核 |
| 分类标签 | 5+ | 分类列表、标签列表 |
| 互动 | 10+ | 点赞、收藏、浏览量统计 |
| 文件 | 5+ | 上传、删除、MinIO集成 |
| 系统 | 10+ | 网站信息、日志、监控、黑名单 |
| 特色 | 10+ | 树洞、留言板、友链、相册 |

### 核心接口列表

#### 文章模块 (ArticleController)

| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/article/list` | 文章列表 | 公开 |
| GET | `/article/{id}` | 文章详情 | 公开 |
| GET | `/article/search` | 文章搜索 | 公开 |
| GET | `/article/recommend` | 文章推荐 | 公开 |
| GET | `/article/featured` | 精选文章 | 公开 |
| GET | `/article/timeline` | 时间轴归档 | 公开 |
| POST | `/article` | 发布文章 | 需认证 |
| PUT | `/article` | 更新文章 | 需认证 |
| DELETE | `/article/{id}` | 删除文章 | 需认证 |

#### 用户模块 (UserController)

| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| POST | `/user/login` | 账号密码登录 | 公开 |
| POST | `/user/register` | 用户注册 | 公开 |
| POST | `/user/logout` | 退出登录 | 需认证 |
| GET | `/user/info` | 获取用户信息 | 需认证 |
| PUT | `/user/info` | 更新用户信息 | 需认证 |
| PUT | `/user/password` | 修改密码 | 需认证 |
| GET | `/user/list` | 用户列表 | 管理员 |
| PUT | `/user/disable` | 禁用/启用用户 | 管理员 |

#### 认证模块 (OauthController)

| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/oauth/gitee` | Gitee登录 | 公开 |
| GET | `/oauth/github` | GitHub登录 | 公开 |
| GET | `/oauth/callback` | 回调处理 | 公开 |

#### 评论模块 (CommentController)

| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/comment/list` | 评论列表 | 公开 |
| POST | `/comment` | 发布评论 | 需认证 |
| PUT | `/comment/{id}` | 更新评论 | 需认证 |
| DELETE | `/comment/{id}` | 删除评论 | 需认证 |
| GET | `/comment/admin/list` | 管理评论列表 | 管理员 |
| PUT | `/comment/check` | 审核评论 | 管理员 |

#### 系统模块 (ServerController)

| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/server/info` | 服务器信息 | 管理员 |
| GET | `/server/cpu` | CPU信息 | 管理员 |
| GET | `/server/memory` | 内存信息 | 管理员 |
| GET | `/server/disk` | 磁盘信息 | 管理员 |

### API 文档访问

项目启动后，可通过以下地址访问在线API文档：

```
http://localhost:8088/doc.html
```

文档基于 Knife4j 提供完整的接口说明、参数校验、响应示例。

---

## 前端架构

### 博客前台 (kuailemao-blog)

#### 技术栈

- **框架**: Vue 3 + TypeScript
- **构建工具**: Vite 5.x
- **UI组件**: Element Plus
- **样式**: Tailwind CSS
- **状态管理**: Pinia
- **路由**: Vue Router 4
- **HTTP**: Axios
- **编辑器**: md-editor-v3 (Markdown)

#### 目录结构

```
kuailemao-blog/src/
├── apis/                    # API接口层
│   ├── article/            # 文章API
│   ├── user/               # 用户API
│   ├── comment/            # 评论API
│   ├── category/           # 分类API
│   ├── tag/                # 标签API
│   ├── photo/              # 相册API
│   ├── link/               # 友链API
│   ├── treeHole/           # 树洞API
│   ├── leaveWord/          # 留言API
│   └── ...
│
├── assets/                 # 静态资源
│   ├── icons/              # SVG图标
│   ├── images/             # 图片资源
│   └── cursor/             # 鼠标指针
│
├── components/             # 公共组件
│   ├── Layout/             # 布局组件
│   │   ├── Header/         # 头部导航
│   │   ├── SideBar/        # 侧边栏
│   │   └── Footer/         # 底部
│   ├── Card/               # 卡片组件
│   │   ├── RandomArticle/  # 随机文章
│   │   ├── SiteVisitCard/  # 访问统计
│   │   └── TagListCard/    # 标签列表
│   ├── Comment/            # 评论组件
│   ├── Banner/             # 轮播图
│   ├── Search/             # 搜索框
│   ├── DayNightToggle/     # 昼夜切换
│   ├── MouseTrail/         # 鼠标轨迹
│   └── Particles/          # 粒子特效
│
├── views/                  # 页面组件
│   ├── Home/               # 首页
│   ├── Article/            # 文章详情
│   ├── Pigeonhole/         # 归档页
│   │   ├── TimeLine/       # 时间轴
│   │   ├── Category/       # 分类
│   │   └── Tags/           # 标签
│   ├── Amusement/          # 娱乐模块
│   │   ├── TreeHole/       # 树洞
│   │   └── Message/        # 留言板
│   ├── Photo/              # 相册
│   ├── Link/               # 友链
│   ├── AiChat/             # AI问答
│   └── About/              # 关于
│
├── store/                  # Pinia状态管理
│   ├── modules/
│   │   ├── user.ts         # 用户状态
│   │   └── website.ts      # 网站配置
│   └── index.ts
│
├── router/                 # 路由配置
│   ├── index.ts            # 路由实例
│   └── routers.ts          # 路由定义
│
├── styles/                 # 样式文件
│   ├── index.scss          # 全局样式入口
│   ├── theme.scss          # 主题配色
│   ├── variable.scss       # 变量定义
│   └── cursor.scss         # 鼠标样式
│
├── utils/                  # 工具函数
│   ├── http.ts             # HTTP请求封装
│   ├── auth.ts             # 认证工具
│   ├── tool.ts             # 通用工具
│   ├── mouseTrail.ts       # 鼠标轨迹
│   └── optimize.ts         # 性能优化
│
├── directives/             # 自定义指令
│   ├── vLazy.ts            # 懒加载
│   └── vViewRequest.ts     # 浏览量统计
│
└── App.vue                 # 根组件
```

#### 路由结构

```
根布局 (/)
├── 首页 (/)
├── 时间轴 (/timeline)
├── 分类 (/category/:id?)
├── 标签 (/tags/:id?)
├── 树洞 (/tree-hole)
├── 留言板 (/message)
├── 友链 (/link)
├── AI问答 (/ai)
├── 关于 (/about)
├── 相册 (/photo)
│
独立路由
├── 文章详情 (/article/:id)
├── 欢迎页 (/welcome) - 登录/注册/重置
└── 用户设置 (/setting)
```

#### 页面布局

**首页三段式设计：**
```
┌─────────────────────────────────────┐
│           Header (头部导航)           │
├─────────────────────────────────────┤
│                                     │
│    ┌──────────────────────────┐     │
│    │     Banner (轮播图)       │     │
│    └──────────────────────────┘     │
│                                     │
│    ┌──────────────────────────┐     │
│    │    Brand (品牌介绍区)      │     │
│    └──────────────────────────┘     │
│                                     │
│    ┌──────────────────────────┐     │
│    │   Main (文章推荐主体)      │     │
│    └──────────────────────────┘     │
│                                     │
├─────────────────────────────────────┤
│       SideBar (侧边栏卡片)           │
│  ┌─────────────────────────────┐    │
│  │ 随机文章 | 标签云 | 访问统计 │    │
│  │ 天气位置 | 公告通知          │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│           Footer (底部)              │
└─────────────────────────────────────┘
```

### 管理后台 (kuailemao-admin)

#### 技术栈

- **框架**: Vue 3 + TypeScript
- **UI库**: Ant Design Vue 4.x
- **样式**: UnoCSS
- **国际化**: Vue I18n

#### 核心功能模块

| 模块 | 功能 |
|------|------|
| **博客管理** | 文章、分类、标签、评论、相册、友链、树洞、留言、轮播图 |
| **系统管理** | 用户、角色、权限、菜单、日志、服务器监控 |
| **数据大屏** | 访问统计、用户行为分析、图表展示 |

---

## 核心功能

### 1. 认证授权体系

#### 功能特性

| 特性 | 说明 |
|------|------|
| **JWT认证** | 无状态Token认证，支持自动续期 |
| **多种登录方式** | 账号密码、邮箱注册、第三方登录(Gitee/GitHub) |
| **RBAC权限模型** | 基于角色的访问控制，细粒度权限管理 |
| **黑名单机制** | IP封禁、用户禁用、接口防刷 |
| **操作日志** | AOP记录用户操作，支持异步写入 |

#### 权限控制粒度

```
角色 (Role)
    └── 权限 (Permission)
            └── 菜单 (Menu)
                    └── 按钮/操作
```

### 2. 文章管理系统

#### 功能清单

| 功能 | 说明 |
|------|------|
| **Markdown编辑器** | 支持图片上传、代码高亮、实时预览 |
| **文章类型** | 原创、转载、翻译 |
| **分类管理** | 一级分类，支持排序 |
| **标签系统** | 多标签支持，热门标签展示 |
| **文章置顶** | 支持置顶排序 |
| **访问统计** | 记录文章访问量 |
| **阅读模式** | 专注阅读模式切换 |
| **目录导航** | 自动生成文章目录 |

#### 文章搜索

```typescript
// 支持多种搜索方式
- 关键词搜索（标题+内容）
- 分类筛选
- 标签筛选
- 时间范围筛选
- 排序方式（时间/访问量/热度）
```

### 3. 评论系统

#### 功能特性

| 特性 | 说明 |
|------|------|
| **多级评论** | 支持无限层级嵌套回复 |
| **评论审核** | 管理员审核机制 |
| **表情支持** | Emoji + 自定义表情包 |
| **点赞评论** | 对评论点赞 |
| **邮件通知** | 评论回复邮件通知 |

#### 评论结构

```json
{
  "id": 1,
  "content": "评论内容",
  "user": { "id": 1, "nickname": "用户名", "avatar": "头像" },
  "replyUser": { "id": 2, "nickname": "回复用户" },
  "children": [
    {
      "id": 2,
      "content": "回复内容",
      "parentId": 1,
      "replyUser": { "id": 1, "nickname": "原评论用户" }
    }
  ]
}
```

### 4. 互动功能

#### 点赞系统

| 类型 | 说明 |
|------|------|
| 文章点赞 | 对文章点赞/取消点赞 |
| 评论点赞 | 对评论点赞 |

#### 收藏系统

| 功能 | 说明 |
|------|------|
| 收藏文章 | 收藏/取消收藏 |
| 收藏列表 | 查看我的收藏 |

### 5. 特色功能

#### 树洞 (TreeHole)

```
功能描述：
- 匿名发布想法
- 审核机制
- 随机展示
```

#### 留言板 (Message)

```
功能描述：
- 用户留言
- 管理员回复
- 审核机制
```

#### 友链管理 (Link)

```
功能描述：
- 友链申请
- 审核流程
- 前台展示
```

#### 相册系统 (Photo)

```
功能描述：
- 多级相册目录
- 图片上传
- 图片预览
- 分类管理
```

### 6. 文件上传

#### 存储方案

| 组件 | 说明 |
|------|------|
| MinIO | 对象存储服务 |
| 支持格式 | 图片、视频、文件 |
| 限制大小 | 100MB |

#### 上传类型

```
- 用户头像上传
- 文章封面上传
- 文章内容图片上传
- 相册图片上传
```

### 7. 性能优化

#### 缓存策略

| 层级 | 技术 | 说明 |
|------|------|------|
| 一级缓存 | Caffeine | 本地缓存，容量1024，过期10分钟 |
| 二级缓存 | Redis | 分布式缓存，过期1小时 |
| 缓存预热 | Quartz定时任务 | 每5分钟刷新热点数据 |

#### 常用缓存Key

```
RuyuBlogCache:article      # 文章缓存
RuyuBlogCache:tag          # 标签缓存
RuyuBlogCache:category     # 分类缓存
RuyuBlogCache:website      # 网站配置缓存
RuyuBlogCache:user         # 用户信息缓存
```

#### 性能优化措施

| 措施 | 说明 |
|------|------|
| 批量查询 | 文章、评论等支持批量查询 |
| 异步处理 | RabbitMQ异步写入日志、发送邮件 |
| 接口限流 | 基于令牌桶算法，防止恶意请求 |
| 防重复提交 | Token机制防止重复提交 |
| 图片懒加载 | 基于IntersectionObserver |
| 代码分割 | Vue路由懒加载 |

### 8. 系统监控

#### 监控指标

| 指标 | 说明 |
|------|------|
| CPU使用率 | 实时CPU占用 |
| 内存使用 | JVM内存状态 |
| 磁盘空间 | 磁盘使用情况 |
| 系统信息 | OS、JVM版本等 |
| 访问日志 | 请求日志记录 |
| 登录日志 | 用户登录记录 |

---

## 项目结构

```
Ruyu-Blog/
├── blog-backend/                  # 后端项目(Spring Boot)
│   ├── src/main/
│   │   ├── java/xyz/kuailemao/
│   │   │   ├── annotation/       # 自定义注解
│   │   │   │   ├── AccessLimit.java
│   │   │   │   ├── LogAnnotation.java
│   │   │   │   └── PreventDuplicateSubmit.java
│   │   │   ├── aop/              # 切面编程
│   │   │   │   ├── LogAspect.java
│   │   │   │   └── RepeatSubmitAspect.java
│   │   │   ├── cache/            # 缓存配置
│   │   │   │   ├── CaffeineConfig.java
│   │   │   │   └── RedisConfig.java
│   │   │   ├── config/           # 配置类
│   │   │   │   ├── SecurityConfig.java
│   │   │   │   ├── RabbitMQConfig.java
│   │   │   │   ├── MinIOConfig.java
│   │   │   │   └── CorsConfig.java
│   │   │   ├── constant/         # 常量定义
│   │   │   ├── controller/       # 控制器层(24个)
│   │   │   │   ├── ArticleController.java
│   │   │   │   ├── UserController.java
│   │   │   │   ├── CommentController.java
│   │   │   │   ├── OauthController.java
│   │   │   │   └── ...
│   │   │   ├── domain/           # 实体类
│   │   │   │   ├── entity/
│   │   │   │   ├── vo/
│   │   │   │   └── dto/
│   │   │   ├── enums/            # 枚举类
│   │   │   ├── exception/        # 异常处理
│   │   │   ├── filter/           # 过滤器
│   │   │   ├── handler/          # 处理器
│   │   │   ├── interceptor/      # 拦截器
│   │   │   ├── mapper/           # 数据访问层
│   │   │   ├── quartz/           # 定时任务
│   │   │   ├── service/          # 业务逻辑层
│   │   │   └── utils/            # 工具类
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       └── mapper/           # MyBatis XML
│   ├── pom.xml
│   └── Dockerfile
│
├── blog-frontend/                 # 前端项目
│   ├── kuailemao-blog/           # 博客前台
│   │   ├── src/
│   │   │   ├── apis/
│   │   │   ├── assets/
│   │   │   ├── components/
│   │   │   ├── views/
│   │   │   ├── store/
│   │   │   ├── router/
│   │   │   ├── styles/
│   │   │   ├── utils/
│   │   │   ├── directives/
│   │   │   ├── App.vue
│   │   │   └── main.ts
│   │   ├── index.html
│   │   ├── vite.config.ts
│   │   ├── tailwind.config.js
│   │   ├── tsconfig.json
│   │   ├── package.json
│   │   └── Dockerfile
│   │
│   └── kuailemao-admin/          # 管理后台
│       ├── src/
│       │   ├── api/
│       │   ├── pages/
│       │   ├── layouts/
│       │   ├── components/
│       │   ├── stores/
│       │   ├── router/
│       │   ├── locales/
│       │   └── ...
│       ├── index.html
│       ├── vite.config.ts
│       ├── package.json
│       └── Dockerfile
│
├── sql/                          # 数据库脚本
│   ├── Ruyu-Blog.sql            # 初始化脚本
│   ├── v1.6.0/
│   │   └── update.sql           # 版本升级脚本
│   └── README.md
│
├── img/                          # 文档图片
├── docs/                         # 文档
│   └── redis-serialization-fix.md
│
├── docker-compose.yml            # Docker编排
├── .gitignore
├── README.md                     # 项目说明
└── LICENSE                       # 许可证
```

---

## 快速开始

### 环境要求

| 环境 | 版本要求 |
|------|----------|
| JDK | 17+ |
| MySQL | 8.0+ |
| Redis | 6.0+ |
| RabbitMQ | 3.8+ |
| Maven | 3.6+ |
| Node.js | 16+ |
| pnpm | 8.x+ |

### 方式一：本地开发部署

#### 1. 克隆项目

```bash
git clone https://github.com/kuailemao/Ruyu-Blog.git
cd Ruyu-Blog
```

#### 2. 初始化数据库

```bash
# 1. 创建数据库
mysql -u root -p
CREATE DATABASE ruyu_blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 2. 导入初始化脚本
mysql -u root -p ruyu_blog < sql/Ruyu-Blog.sql

# 3. 如需导入版本升级脚本
mysql -u root -p ruyu_blog < sql/v1.6.0/update.sql
```

#### 3. 配置后端

```bash
cd blog-backend

# 修改配置文件
# 文件位置: src/main/resources/application-dev.yml

# 配置数据库连接
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ruyu_blog
    username: root
    password: your_password

# 配置Redis
  redis:
    host: localhost
    port: 6379
    password: your_redis_password

# 配置RabbitMQ
  rabbitmq:
    host: localhost
    port: 5672
    username: admin
    password: admin

# 配置MinIO
minio:
  endpoint: http://localhost:9000
  accessKey: minioadmin
  secretKey: minioadmin
  bucketName: ruyu-blog

# 配置JWT
jwt:
  secret: your_jwt_secret_key
  expiration: 86400000
```

#### 4. 启动后端

```bash
# Maven启动
mvn spring-boot:run

# 或打包后运行
mvn clean package -DskipTests
java -jar target/blog-backend.jar
```

**后端服务启动成功后：**
- 接口地址: `http://localhost:8088`
- API文档: `http://localhost:8088/doc.html`

#### 5. 配置并启动前端

**博客前台：**

```bash
cd blog-frontend/kuailemao-blog

# 安装依赖
pnpm install

# 配置环境变量
# 文件: .env.development
VITE_APP_BASE_URL=http://localhost:8088
VITE_APP_BASE_API=/api

# 启动开发服务器
pnpm run dev
```

访问 `http://localhost:5173` 查看前台

**管理后台：**

```bash
cd blog-frontend/kuailemao-admin

# 安装依赖
pnpm install

# 启动开发服务器
pnpm run dev
```

访问 `http://localhost:99` 查看后台

### 方式二：Docker Compose 一键部署

```bash
# 在项目根目录执行
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

**默认账号：**
- 管理员: `admin` (密码见数据库初始化脚本)

---

## 配置说明

### 后端配置

#### application.yml

```yaml
server:
  port: 8088
  servlet:
    context-path: /

spring:
  profiles:
    active: dev  # 环境: dev/prod

  # 数据源配置
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      minimum-idle: 5
      maximum-pool-size: 20
      idle-timeout: 30000
      pool-name: RuyuBlogHikariCP
      max-lifetime: 1800000

  # Redis配置
  data:
    redis:
      host: localhost
      port: 6379
      database: 1
      timeout: 10000ms

  # RabbitMQ配置
  rabbitmq:
    host: localhost
    port: 5672
    username: admin
    password: admin
    virtual-host: /

  # 文件上传
  servlet:
    multipart:
      max-file-size: 100MB
      max-request-size: 100MB

# MyBatis Plus配置
mybatis-plus:
  mapper-locations: classpath*:/mapper/**/*.xml
  type-aliases-package: xyz.kuailemao.domain.entity
  global-config:
    db-config:
      id-type: auto
      logic-delete-field: isDeleted
      logic-delete-value: 1
      logic-not-delete-value: 0

# Knife4j配置
springdoc:
  swagger-ui:
    path: /swagger-ui.html
    tags-sorter: alpha
    operations-sorter: alpha
  api-docs:
    path: /v3/api-docs
  group-configs:
    - group: 'default'
      paths-to-match: '/**'
      packages-to-scan: xyz.kuailemao.controller

# 日志配置
logging:
  level:
    root: INFO
    xyz.kuailemao: DEBUG
  file:
    name: logs/ruyu-blog.log

# JWT配置
jwt:
  secret: your_jwt_secret_key_here_must_be_long_enough
  expiration: 86400000  # 24小时

# MinIO配置
minio:
  endpoint: http://localhost:9000
  accessKey: minioadmin
  secretKey: minioadmin
  bucketName: ruyu-blog

# 缓存配置
cache:
  caffeine:
    spec: maximumSize=1024,expireAfterWrite=10m
  redis:
    expire: 1h
```

#### 环境配置文件

**开发环境 (application-dev.yml):**
- 使用本地数据库
- 开启详细日志
- 开启调试模式

**生产环境 (application-prod.yml):**
- 使用生产数据库
- 优化日志级别
- 性能优化配置

### 前端配置

#### 环境变量 (.env.development)

```env
# API基础地址
VITE_APP_BASE_URL=http://localhost:8088
VITE_APP_BASE_API=/api

# 是否开启Mock
VITE_APP_USE_MOCK=false

# 应用标题
VITE_APP_TITLE=Ruyu-Blog
```

#### 环境变量 (.env.production)

```env
# API基础地址
VITE_APP_BASE_URL=https://your-api-domain.com
VITE_APP_BASE_API=/api

# 是否开启Mock
VITE_APP_USE_MOCK=false
```

---

## 开发指南

### 代码规范

#### 后端规范 (Java)

```java
// 1. 分层命名规范
// Controller: XxxController.java
// Service: XxxService.java, XxxServiceImpl.java
// Mapper: XxxMapper.java
// Entity: Xxx.java
// VO: XxxVO.java
// DTO: XxxDTO.java
// Request: XxxRequest.java

// 2. 方法命名规范
// 查询: getXxx / listXxx
// 新增: saveXxx / addXxx
// 修改: updateXxx / editXxx
// 删除: removeXxx / deleteXxx

// 3. 注解使用
// @Tag(name = "模块名称")  // API分组
// @Operation(summary = "接口描述")  // 接口说明
// @PreAuthorize("hasPermission('', 'xxx')")  // 权限控制
```

#### 前端规范 (Vue + TypeScript)

```typescript
// 1. 组件命名: PascalCase
// MyComponent.vue

// 2. Props类型定义
interface Props {
  title: string;
  disabled?: boolean;
}

// 3. API接口命名
// apis/article/index.ts
export const getArticleList = (params: ArticleQuery) => {
  return http.get('/article/list', { params });
};

// 4. Store模块命名
// store/modules/user.ts
export const useUserStore = defineStore('user', () => {
  // ...
});
```

### 分支管理

| 分支 | 说明 |
|------|------|
| main | 主分支，稳定版本 |
| dev | 开发分支，最新功能 |
| feature/* | 功能分支 |
| bugfix/* | 修复分支 |
| hotfix/* | 热修复分支 |

### 提交规范

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建/工具相关
perf: 性能优化
```

### 常用命令

```bash
# 后端
mvn clean package -DskipTests    # 打包
mvn spring-boot:run              # 启动
mvn test                         # 运行测试

# 前台
pnpm install                     # 安装依赖
pnpm run dev                     # 开发模式
pnpm run build                   # 生产构建
pnpm run lint                    # 代码检查

# 后台
pnpm install
pnpm run dev
pnpm run build
```

---

## 常见问题

### 1. 后端启动失败

**问题**: 数据库连接失败

```bash
# 检查MySQL是否启动
mysql -u root -p

# 检查数据库配置
# 确保url、username、password正确
```

**问题**: Redis连接失败

```bash
# 检查Redis服务
redis-cli ping

# 检查Redis密码配置
```

### 2. 前端启动失败

**问题**: `Cannot read properties of null (reading 'split')`

```bash
# 解决方案
# 1. 检查.env.development文件是否存在
# 2. 确保VITE_APP_BASE_URL不为空
# 3. 删除node_modules重新安装
rm -rf node_modules
pnpm install
```

### 3. Redis序列化问题

**问题**: `/tag/list` 接口报500错误

```bash
# 解决方案
# 1. 清空Redis缓存
redis-cli FLUSHDB

# 2. 检查Redis配置
# 3. 确保实体类实现Serializable接口
# 4. 重启后端服务
```

### 4. 文件上传失败

**问题**: MinIO文件上传失败

```bash
# 解决方案
# 1. 检查MinIO服务是否启动
# 2. 检查bucket是否创建
# 3. 检查文件大小限制
# 4. 查看后端日志
```

### 5. 接口返回401

**问题**: 未授权访问

```bash
# 解决方案
# 1. 检查Token是否有效
# 2. 检查登录状态
# 3. 清除缓存重新登录
```

---

## 路线图

### 已完成

- [x] 基础功能开发
- [x] 前后端分离架构
- [x] Docker容器化支持
- [x] JWT认证授权
- [x] RBAC权限系统
- [x] 评论系统
- [x] 树洞功能
- [x] 相册功能
- [x] 第三方登录
- [x] API文档集成

### 待开发

- [ ] 单元测试覆盖
- [ ] 性能优化
- [ ] 移动端适配优化
- [ ] 微服务架构迁移
- [ ] 国际化支持
- [ ] 主题切换功能
- [ ] SSR服务端渲染
- [ ] 更多第三方登录
- [ ] 评论邮件通知
- [ ] 数据统计分析

---

## 贡献者

感谢所有为这个项目做出贡献的开发者！

<a href="https://github.com/kuailemao/Ruyu-Blog/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=kuailemao/Ruyu-Blog" />
</a>

### 贡献方式

1. **提交问题**: 发现bug或有新功能建议，请提交 [Issue](https://github.com/kuailemao/Ruyu-Blog/issues)
2. **贡献代码**:
   - Fork本仓库
   - 创建功能分支 (`git checkout -b feature/AmazingFeature`)
   - 提交修改 (`git commit -m 'feat: Add some AmazingFeature'`)
   - 推送到分支 (`git push origin feature/AmazingFeature`)
   - 提交Pull Request
3. **完善文档**: 帮助改进文档，修正错别字
4. **分享反馈**: 使用过程中的建议和意见

---

## 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

这意味着你可以自由地：
- 使用本项目进行商业或非商业用途
- 修改源代码
- 分发和再授权

但你必须：
- 在你的副本中包含原始版权声明
- 包含许可证副本

---

## 交流与反馈

### 联系方式

- **GitHub Issues**: [提交问题](https://github.com/kuailemao/Ruyu-Blog/issues)
- **Pull Requests**: [贡献代码](https://github.com/kuailemao/Ruyu-Blog/pulls)
- **邮箱**: your-email@example.com

---

<div align="center">

**如果这个项目对你有帮助，请点个 Star 支持一下！**

Made with ❤️ by [快乐猫](https://github.com/kuailemao)

*文档版本: 2.0*
*最后更新: 2025-12-28*

</div>
