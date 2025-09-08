# Ruyu-Blog 后端项目

## 📋 项目介绍

Ruyu-Blog 后端是一个基于 Spring Boot 3.x 构建的现代化博客系统后端服务，提供完整的 RESTful API，支持用户管理、内容发布、评论互动、权限控制等核心功能。系统采用单体架构设计，集成了 Redis、RabbitMQ、MinIO 等中间件，实现高性能、可扩展的博客服务。

## 🛠️ 技术栈

- **核心框架**：Spring Boot 3.1.4
- **安全框架**：Spring Security 6.x + JWT
- **ORM 框架**：MyBatis-Plus 3.5.3
- **数据库**：MySQL 8.0+
- **缓存**：Redis 6.0+
- **消息队列**：RabbitMQ 3.8+
- **对象存储**：MinIO
- **开发工具**：
  - Lombok - 简化 Java 代码
  - Hutool - Java 工具类库
  - FastJSON - JSON 处理
  - Knife4j - API 文档
- **容器化**：Docker

## 📁 项目结构

```
blog-backend/src/main/java/xyz/kuailemao/
├── BlogBackendApplication.java  # 应用启动类
├── annotation/                  # 自定义注解
│   ├── AccessLimit.java         # 访问限制注解
│   ├── Log.java                 # 日志记录注解
│   └── ...
├── aop/                         # 切面编程实现
│   ├── LogAspect.java           # 日志处理切面
│   ├── AccessLimitAspect.java   # 访问限制切面
│   └── ...
├── cache/                       # 缓存相关配置和实现
├── config/                      # 系统配置类
│   ├── SecurityConfig.java      # 安全配置
│   ├── RedisConfig.java         # Redis 配置
│   ├── RabbitMQConfig.java      # 消息队列配置
│   └── ...
├── constants/                   # 常量定义
├── controller/                  # 控制器层（处理HTTP请求）
│   ├── ArticleController.java   # 文章相关接口
│   ├── UserController.java      # 用户相关接口
│   └── ...
├── domain/                      # 数据模型层
│   ├── dto/                     # 数据传输对象
│   ├── entity/                  # 实体类
│   └── vo/                      # 视图对象
├── enums/                       # 枚举类
├── exceptions/                  # 异常处理
│   ├── GlobalExceptionHandler.java  # 全局异常处理器
│   └── ...
├── filter/                      # 过滤器
├── handler/                     # 处理器
├── interceptor/                 # 拦截器
├── listener/                    # 监听器
├── mapper/                      # 数据访问层
├── quartz/                      # 定时任务
├── service/                     # 业务逻辑层
│   ├── impl/                    # 业务实现类
│   ├── ArticleService.java      # 文章服务接口
│   ├── UserService.java         # 用户服务接口
│   └── ...
├── task/                        # 任务相关
├── tasks/                       # 定时任务
└── utils/                       # 工具类
```

## 🏗️ 系统架构详解

### 整体架构

Ruyu-Blog 后端采用经典的三层架构设计，结合现代微服务思想，构建高性能、可扩展的博客系统后端服务。

![后端架构图](https://raw.githubusercontent.com/kuailemao/Ruyu-Blog/master/img/backend_architecture.svg)

### 分层设计

1. **表示层（Controller）**
   - 处理 HTTP 请求，接收前端参数
   - 调用业务层服务，返回处理结果
   - 实现 RESTful API 接口设计

2. **业务逻辑层（Service）**
   - 封装核心业务逻辑
   - 处理数据校验和业务规则
   - 调用数据访问层进行数据操作

3. **数据访问层（Mapper）**
   - 基于 MyBatis-Plus 实现数据库操作
   - 处理数据持久化和查询

4. **基础设施层**
   - 缓存系统（Redis）：提高数据访问性能
   - 消息队列（RabbitMQ）：处理异步任务和解耦系统
   - 对象存储（MinIO）：管理图片等静态资源
   - 安全框架（Spring Security）：处理认证和授权

## ✨ 核心功能模块

### 🔐 用户与权限管理
- JWT + Spring Security 实现认证授权
- RBAC 权限模型，支持细粒度权限控制
- 支持邮箱注册、第三方登录（Gitee/GitHub）
- 黑名单系统、IP 访问限制

### 📝 内容管理
- 文章管理：发布、编辑、删除、分类、标签
- 评论系统：多级评论、回复通知、评论审核
- 分类管理：多级分类结构
- 标签系统：文章标签、热门标签
- 友链管理：友链申请、审核、展示
- 树洞功能：匿名留言、情感分享
- 留言板：访客留言、管理员回复

### 🚀 性能优化
- 多级缓存策略：Redis 缓存 + 本地缓存
- 接口访问限流：基于令牌桶算法
- 异步消息处理：邮件通知、日志记录等异步任务
- 图片存储：MinIO 对象存储，支持图片上传和 CDN 加速

### 📊 系统监控
- AOP 统一日志记录
- 操作审计追踪
- 访问统计分析
- 系统资源监控

## 🚀 快速开始

### 环境要求
- JDK 17+
- MySQL 8.0+
- Redis 6.0+
- RabbitMQ 3.8+
- MinIO
- Maven 3.6+

### 1. 初始化数据库

执行 `../sql/Ruyu-Blog.sql` 脚本初始化数据库。

### 2. 配置环境变量

在 `blog-backend/src/main/resources/application.yml` 中配置以下信息：

```yaml
# 数据库配置
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/blog?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
    username: root
    password: password

# Redis 配置
  data:
    redis:
      host: localhost
      port: 6379
      password: 
      database: 0

# RabbitMQ 配置
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest

# MinIO 配置
minio:
  endpoint: http://localhost:9000
  access-key: minioadmin
  secret-key: minioadmin
  bucket-name: blog

# JWT 配置
jwt:
  secret: your-secret-key
  expiration: 3600000
```

### 3. 启动后端服务

```bash
# 开发环境启动
mvn spring-boot:run

# 构建打包
mvn clean package

# 运行 jar 包
java -jar target/blog-backend.jar
```

服务启动后，可访问 `http://localhost:8088/doc.html` 查看 API 文档。

## 🐳 Docker 部署

### 构建 Docker 镜像

```bash
cd blog-backend

docker build -t ruyu-blog-backend .
```

### 运行 Docker 容器

```bash
docker run -d -p 8088:8088 --name ruyu-blog-backend \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/blog \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=password \
  -e SPRING_REDIS_HOST=redis \
  -e SPRING_RABBITMQ_HOST=rabbitmq \
  --link mysql:mysql \
  --link redis:redis \
  --link rabbitmq:rabbitmq \
  ruyu-blog-backend
```

### 使用 Docker Compose

推荐使用 Docker Compose 进行整体部署，详见项目根目录的 `docker-compose.yml` 文件。

## 🔧 开发指南

### 代码规范
- 遵循 Spring Boot 最佳实践
- 方法和类添加完整的 JavaDoc 注释
- 使用 Lombok 简化代码
- 业务逻辑尽可能封装在 Service 层

### API 设计规范
- 遵循 RESTful 风格
- 使用统一的响应格式
- 添加适当的参数校验
- 实现接口限流和防刷

### 日志管理
- 使用 @Log 注解记录关键操作日志
- 异常日志统一处理
- 重要业务流程添加详细日志

## 🤝 贡献指南

1. Fork 本项目
2. 创建新的分支（git checkout -b feature/your-feature）
3. 提交你的修改（git commit -am 'Add some feature'）
4. 推送到分支（git push origin feature/your-feature）
5. 创建 Pull Request

## 📝 许可证

本项目采用 Apache License 2.0 许可证。详情请查看 [LICENSE](LICENSE) 文件。

