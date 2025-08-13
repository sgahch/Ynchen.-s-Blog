# Ruyu-Blog 后端详细架构文档

![GitHub 贡献贪吃蛇](https://raw.githubusercontent.com/yuaotian/yuaotian/refs/heads/output/github-contribution-grid-snake.svg)

## 📋 项目概览

**Ruyu-Blog** 是一个基于 Spring Boot 3.x 构建的现代化博客系统后端，采用**单体应用架构**设计，前后端分离部署。项目集成了完整的用户管理、内容管理、权限控制、消息队列、缓存系统等企业级功能模块。

### 🏗️ 架构特点

- **🏢 单体应用架构** - 采用传统的单体应用模式，所有功能模块集成在一个应用中
- **🔄 前后端分离** - 后端提供RESTful API，前端独立部署
- **📦 模块化设计** - 虽然是单体架构，但代码结构清晰，模块职责分明
- **🚀 易于部署维护** - 单一部署单元，降低运维复杂度
- **⚡ 高性能优化** - 通过缓存、消息队列等技术提升性能

### 🏗️ 核心特性

- **🔐 完整的认证授权体系** - JWT + Spring Security + RBAC权限模型
- **📝 丰富的内容管理功能** - 文章、评论、标签、分类、友链等
- **🚀 高性能缓存策略** - Redis多级缓存 + 访问限流
- **📨 异步消息处理** - RabbitMQ消息队列 + 邮件通知
- **🛡️ 安全防护机制** - 黑名单系统 + IP限制 + 接口防刷
- **📊 完善的日志监控** - AOP日志切面 + 操作审计
- **🔧 灵活的配置管理** - 多环境配置 + 动态参数
- **📦 容器化部署** - Docker支持 + 生产环境优化

## 🛠️ 技术栈架构

### 核心框架
- **Spring Boot 3.1.4** - 主框架，提供自动配置和快速开发能力
- **Spring Security 6.x** - 安全框架，处理认证和授权
- **Spring AOP** - 面向切面编程，实现日志记录和权限控制
- **MyBatis-Plus 3.5.3** - ORM框架，简化数据库操作

### 数据存储
- **MySQL 8.0+** - 主数据库，存储业务数据
- **Redis 6.0+** - 缓存数据库，提供高性能数据访问
- **MinIO** - 对象存储服务，处理文件上传和管理

### 消息中间件
- **RabbitMQ** - 消息队列，处理异步任务和解耦系统

### 工具库
- **Lombok** - 简化Java代码编写
- **Hutool** - Java工具类库，提供丰富的工具方法
- **FastJSON** - JSON处理库
- **JWT** - 无状态身份验证
- **Knife4j** - API文档生成和测试工具

### 架构说明
- **🏢 单体应用架构** - 非微服务架构，所有功能集成在一个Spring Boot应用中
- **📡 RESTful API** - 提供标准的REST接口，支持前后端分离
- **🔄 异步处理** - 使用RabbitMQ处理邮件发送、日志记录等异步任务
- **💾 数据持久化** - MySQL主数据库 + Redis缓存 + MinIO对象存储
- **🛡️ 安全认证** - JWT + Spring Security实现无状态认证

## 📁 项目结构详解

```
blog-backend/
├── src/main/java/xyz/kuailemao/
│   ├── BlogBackendApplication.java          # 🚀 应用启动类
│   ├── annotation/                          # 📝 自定义注解
│   │   ├── AccessLimit.java                 # 接口访问限制注解
│   │   ├── CheckBlacklist.java              # 黑名单检查注解
│   │   └── LogAnnotation.java               # 日志记录注解
│   ├── aop/                                 # 🔄 切面编程
│   │   ├── AccessLimitAspect.java           # 访问限制切面
│   │   ├── BlacklistAspect.java             # 黑名单检查切面
│   │   └── LogAspect.java                   # 日志记录切面
│   ├── config/                              # ⚙️ 配置类
│   │   ├── SecurityConfig.java              # Spring Security配置
│   │   ├── RedisConfig.java                 # Redis配置
│   │   ├── RabbitConfig.java                # RabbitMQ配置
│   │   ├── MinioConfig.java                 # MinIO配置
│   │   ├── QuartzConfig.java                # 定时任务配置
│   │   └── Knife4jConfig.java               # API文档配置
│   ├── constants/                           # 📋 常量定义
│   │   ├── SecurityConst.java               # 安全相关常量
│   │   ├── RabbitConst.java                 # 消息队列常量
│   │   └── RedisConst.java                  # Redis键名常量
│   ├── controller/                          # 🎮 控制器层
│   │   ├── ArticleController.java           # 文章管理接口
│   │   ├── UserController.java              # 用户管理接口
│   │   ├── CommentController.java           # 评论管理接口
│   │   ├── CategoryController.java          # 分类管理接口
│   │   ├── TagController.java               # 标签管理接口
│   │   ├── LinkController.java              # 友链管理接口
│   │   ├── TreeHoleController.java          # 树洞功能接口
│   │   ├── LeaveWordController.java         # 留言板接口
│   │   ├── BlackListController.java         # 黑名单管理接口
│   │   ├── WebsiteInfoController.java       # 网站信息接口
│   │   └── PublicController.java            # 公共接口
│   ├── domain/                              # 📊 数据模型层
│   │   ├── entity/                          # 实体类
│   │   │   ├── User.java                    # 用户实体
│   │   │   ├── Article.java                 # 文章实体
│   │   │   ├── Comment.java                 # 评论实体
│   │   │   ├── Category.java                # 分类实体
│   │   │   ├── Tag.java                     # 标签实体
│   │   │   ├── BlackList.java               # 黑名单实体
│   │   │   └── ...                          # 其他实体类
│   │   ├── dto/                             # 数据传输对象
│   │   └── vo/                              # 视图对象
│   ├── enums/                               # 📝 枚举类
│   ├── exceptions/                          # ❌ 异常处理
│   ├── filter/                              # 🔍 过滤器
│   ├── handler/                             # 🛠️ 处理器
│   ├── interceptor/                         # 🚧 拦截器
│   ├── mapper/                              # 🗄️ 数据访问层
│   ├── quartz/                              # ⏰ 定时任务
│   ├── service/                             # 💼 业务逻辑层
│   │   ├── impl/                            # 业务实现类
│   │   └── ...                              # 业务接口
│   ├── tasks/                               # 📋 启动任务
│   └── utils/                               # 🔧 工具类
├── src/main/resources/
│   ├── application.yml                      # 主配置文件
│   ├── application-dev.yml                  # 开发环境配置
│   ├── application-prod.yml                 # 生产环境配置
│   ├── mapper/                              # MyBatis映射文件
│   ├── templates/                           # 邮件模板
│   └── banner.txt                           # 启动横幅
├── Dockerfile                               # Docker构建文件
└── pom.xml                                  # Maven依赖配置
```

## 🏛️ 系统架构设计

### 单体应用 vs 微服务

**为什么选择单体架构？**

本项目采用单体应用架构而非微服务架构，主要考虑因素：

- **🎯 业务复杂度适中** - 博客系统功能相对集中，不需要复杂的服务拆分
- **👥 团队规模较小** - 单体架构更适合小团队开发和维护
- **🚀 快速迭代需求** - 避免微服务带来的分布式复杂性，专注业务开发
- **💰 运维成本考虑** - 单体部署简单，降低基础设施和运维成本
- **📈 性能要求** - 通过缓存和优化可以满足中等规模的访问需求

**架构优势：**
- ✅ 开发调试简单，本地运行完整功能
- ✅ 部署运维简单，单一部署单元
- ✅ 事务处理简单，避免分布式事务复杂性
- ✅ 性能优异，避免网络调用开销
- ✅ 技术栈统一，降低学习成本

### 分层架构模式

项目采用经典的三层架构模式，各层职责清晰分离：

**1. 表现层 (Controller Layer)**
- 处理HTTP请求和响应
- 参数验证和数据转换
- 接口文档生成和测试支持

**2. 业务逻辑层 (Service Layer)**
- 核心业务逻辑处理
- 事务管理和数据一致性
- 缓存策略和性能优化

**3. 数据访问层 (Mapper Layer)**
- 数据库操作和SQL映射
- 数据持久化和查询优化
- 多数据源支持

### 横切关注点

**安全控制**
- JWT身份验证
- RBAC权限模型
- 接口访问控制

**日志监控**
- AOP统一日志记录
- 操作审计追踪
- 异常监控告警

**性能优化**
- Redis多级缓存
- 接口访问限流
- 数据库查询优化

## 🔧 核心功能模块

### 用户管理模块
- **注册登录**: 支持邮箱注册、第三方登录(Gitee/GitHub)
- **用户信息**: 个人资料管理、头像上传
- **权限控制**: 基于角色的访问控制(RBAC)

### 内容管理模块
- **文章系统**: 文章发布、编辑、分类、标签
- **评论系统**: 多级评论、回复通知
- **友链管理**: 友链申请、审核、展示

### 安全防护模块
- **黑名单系统**: IP封禁、用户封禁
- **访问限制**: 接口频率限制、防刷机制
- **安全审计**: 登录日志、操作记录

### 系统监控模块
- **日志管理**: 系统日志、操作日志
- **性能监控**: 接口响应时间、系统资源
- **异常处理**: 全局异常捕获、错误追踪

## 🚀 快速开始

### 环境要求
- JDK 17+
- MySQL 8.0+
- Redis 6.0+
- RabbitMQ 3.8+
- Maven 3.6+

### 配置说明
详细的配置文件说明请参考 `application.yml` 中的注释，主要配置项包括：
- 数据库连接配置
- Redis缓存配置  
- RabbitMQ消息队列配置
- JWT安全配置
- 文件存储配置

### 启动步骤
1. 克隆项目到本地
2. 配置数据库和中间件连接信息
3. 执行数据库初始化脚本
4. 运行 `BlogBackendApplication.java`
5. 访问 `http://localhost:8088/doc.html` 查看API文档

## 🚨 常见问题解决

### 前端启动错误
如果前端启动时遇到 `Cannot read properties of null (reading 'split')` 错误：

**问题原因**: 环境变量配置为空导致Vite代理配置失败

**解决方案**:
1. 检查 `blog-frontend/kuailemao-admin/.env.development` 文件
2. 确保以下配置不为空：
   ```bash
   VITE_APP_BASE_URL=http://localhost:8088
   VITE_APP_BASE_API=/api
   VITE_APP_DOMAIN_NAME_FRONT=http://localhost:99
   ```
3. 重新启动前端项目

### Git钩子问题
如果遇到 `husky - .git can't be found` 错误：
```bash
cd 项目根目录
git init  # 如果不是git仓库
```

---

*本文档持续更新中，如有问题请提交Issue或联系维护者*
