# Ruyu-Blog 开源博客系统

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/kuailemao/Ruyu-Blog?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/kuailemao/Ruyu-Blog?style=flat-square)
![GitHub license](https://img.shields.io/github/license/kuailemao/Ruyu-Blog?style=flat-square)
![Java Version](https://img.shields.io/badge/Java-17+-blue?style=flat-square)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1.4-green?style=flat-square)
![Vue](https://img.shields.io/badge/Vue-3.x-brightgreen?style=flat-square)

[在线演示](http://your-demo-url.com) · [使用文档](https://github.com/kuailemao/Ruyu-Blog/wiki) · [反馈问题](https://github.com/kuailemao/Ruyu-Blog/issues)

![GitHub 贡献贪吃蛇](https://raw.githubusercontent.com/yuaotian/yuaotian/refs/heads/output/github-contribution-grid-snake.svg)

</div>

## 📋 项目概览

**Ruyu-Blog** 是一个基于 Spring Boot 3.1.4 + Vue 3 构建的现代化全栈博客系统。系统采用前后端分离架构,集成了完整的用户管理、内容管理、权限控制、消息队列、缓存系统等企业级功能,为个人博客和内容创作提供开箱即用的一站式解决方案。

**核心亮点:**
- ✅ 完整的前后端分离架构,双前端设计(博客前台 + 管理后台)
- ✅ 企业级技术栈,开箱即用的完整功能模块
- ✅ 多级缓存策略和消息队列,高性能架构设计
- ✅ 容器化部署支持,一键启动开发/生产环境
- ✅ 详细的代码注释和API文档,便于学习和二次开发

### 🏗️ 系统架构

- **🔄 前后端分离** - 后端提供 RESTful API,前端独立部署
- **🏢 后端单体架构** - 所有功能模块集成在一个 Spring Boot 应用中
- **🌐 双前端设计** - 包含博客前台展示和管理后台两个独立前端项目
- **📦 容器化部署** - 支持 Docker 容器化部署,简化运维流程

#### 后端架构图

![后端架构图](img/backend_architecture.svg)

后端采用经典的三层架构设计,包括控制层(Controller)、业务层(Service)和数据访问层(Mapper),并整合了缓存(Redis)、消息队列(RabbitMQ)、对象存储(MinIO)等中间件,实现高性能、高可用的博客系统后端服务。

#### 前端架构图

![前端架构图](img/frontend_architecture.svg)

前端采用Vue 3 + Vite + TypeScript技术栈,使用Pinia进行状态管理,Vue Router处理路由,结合Tailwind CSS实现响应式UI设计,构建了高性能、现代化的用户界面。

## 🎨 项目预览

### 前台展示
![前台首页](img/前台首页.jpg)
![前台文章](img/前台文章.jpg)
![前台中心](img/前台中心.jpg)

### 后台管理
![后台发布文章](img/后台发布文章.jpg)
![后台文章列表](img/后台文章列表.jpg)

## 🛠️ 技术栈

### 后端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.1.4 | 基础框架,提供自动配置和快速开发能力 |
| Spring Security | 6.x | 安全框架,处理认证和授权 |
| Spring AOP | - | 面向切面编程,实现日志和权限控制 |
| MyBatis-Plus | 3.5.3 | ORM框架,简化数据库操作 |
| MySQL | 8.0+ | 关系型数据库,存储业务数据 |
| Redis | 6.0+ | 缓存数据库,提供高性能数据访问 |
| MinIO | - | 对象存储服务,处理文件上传和管理 |
| RabbitMQ | 3.8+ | 消息队列,处理异步任务和系统解耦 |
| JWT | - | 无状态身份验证 |
| Knife4j | - | API文档生成和在线测试工具 |
| Lombok | - | 简化Java代码编写 |
| Hutool | - | Java工具类库 |
| FastJSON | - | JSON序列化和反序列化 |

### 前端技术栈

| 技术 | 说明 |
|------|------|
| Vue 3 | 渐进式JavaScript框架 |
| Vite | 下一代前端构建工具 |
| TypeScript | 静态类型检查 |
| Tailwind CSS / UnoCSS | 实用优先的CSS框架 |
| Pinia | 状态管理 |
| Vue Router | 路由管理 |
| Axios | HTTP请求库 |

## ✨ 核心功能

### 🔐 完整的认证授权体系
- JWT + Spring Security + RBAC权限模型
- 支持邮箱注册、第三方登录(Gitee/GitHub)
- 细粒度的权限控制机制
- 黑名单系统、IP限制、接口防刷

### 📝 丰富的内容管理功能
- **文章系统**: 文章发布、编辑、分类、标签管理、Markdown编辑器
- **评论系统**: 多级评论、回复通知、评论审核
- **分类管理**: 文章分类、层级结构
- **标签系统**: 文章标签、热门标签展示
- **友链管理**: 友链申请、审核、展示
- **树洞功能**: 匿名留言、情感分享
- **留言板**: 访客留言、管理员回复

### 🚀 高性能与可靠性
- **多级缓存策略**: Redis缓存 + 本地缓存,提升访问速度
- **接口访问限流**: 基于令牌桶算法,防止恶意请求
- **异步消息处理**: RabbitMQ处理邮件通知等异步任务
- **安全防护机制**: 黑名单系统、IP限制、XSS防护

### 📊 完善的日志与监控
- AOP统一日志记录
- 操作审计追踪
- 全局异常捕获与处理
- 访问统计分析

### 🛠️ 开发与部署支持
- 多环境配置(开发、测试、生产)
- Docker容器化支持
- API文档自动生成(Knife4j)
- 完整的异常处理和错误提示

## 📁 项目结构

```
Ruyu-Blog/
├── blog-backend/          # 后端项目(Spring Boot)
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/xyz/kuailemao/
│   │   │   │   ├── annotation/      # 自定义注解
│   │   │   │   ├── aop/             # 切面编程
│   │   │   │   ├── config/          # 配置类
│   │   │   │   ├── controller/      # 控制器层
│   │   │   │   ├── service/         # 业务逻辑层
│   │   │   │   ├── mapper/          # 数据访问层
│   │   │   │   ├── domain/          # 数据模型
│   │   │   │   ├── utils/           # 工具类
│   │   │   │   └── ...
│   │   │   └── resources/
│   │   │       ├── application.yml  # 主配置文件
│   │   │       ├── application-dev.yml   # 开发环境配置
│   │   │       └── application-prod.yml  # 生产环境配置
│   ├── pom.xml            # Maven依赖配置
│   └── Dockerfile         # Docker构建文件
├── blog-frontend/         # 前端项目目录
│   ├── kuailemao-admin/   # 管理后台前端(Vue 3)
│   │   ├── src/
│   │   ├── package.json
│   │   ├── vite.config.ts
│   │   └── Dockerfile
│   └── kuailemao-blog/    # 博客前台前端(Vue 3)
│       ├── src/
│       ├── package.json
│       ├── vite.config.ts
│       └── Dockerfile
├── sql/                   # 数据库脚本
│   ├── Ruyu-Blog.sql      # 初始化脚本
│   └── v1.6.0/            # 版本更新脚本
├── img/                   # 项目截图和文档图片
└── README.md              # 项目文档
```

## 🚀 快速开始

### 环境要求

| 环境 | 版本要求 |
|------|---------|
| JDK | 17+ |
| MySQL | 8.0+ |
| Redis | 6.0+ |
| RabbitMQ | 3.8+ |
| Maven | 3.6+ |
| Node.js | 16+ |
| pnpm/npm | 最新版 |

### 方式一: 本地开发部署

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

# 3. 如果需要,导入版本更新脚本
mysql -u root -p ruyu_blog < sql/v1.6.0/update.sql
```

#### 3. 配置并启动后端

```bash
# 1. 进入后端目录
cd blog-backend

# 2. 修改配置文件 src/main/resources/application-dev.yml
# 配置数据库连接、Redis、RabbitMQ、MinIO等中间件信息

# 3. 启动后端服务
mvn spring-boot:run

# 或者打包后运行
mvn clean package -DskipTests
java -jar target/blog-backend.jar
```

**后端服务启动成功后,访问以下地址:**
- 后端接口: `http://localhost:8088`
- API文档: `http://localhost:8088/doc.html`

#### 4. 配置并启动前端

**管理后台:**

```bash
# 1. 进入管理后台目录
cd blog-frontend/kuailemao-admin

# 2. 安装依赖
pnpm install  # 或 npm install

# 3. 配置环境变量 .env.development
# VITE_APP_BASE_URL=http://localhost:8088
# VITE_APP_BASE_API=/api

# 4. 启动开发服务器
pnpm run dev  # 或 npm run dev
```

访问 `http://localhost:99` 查看管理后台

**博客前台:**

```bash
# 1. 进入博客前台目录
cd blog-frontend/kuailemao-blog

# 2. 安装依赖
pnpm install  # 或 npm install

# 3. 配置环境变量 .env.development
# VITE_APP_BASE_URL=http://localhost:8088
# VITE_APP_BASE_API=/api

# 4. 启动开发服务器
pnpm run dev  # 或 npm run dev
```

访问 `http://localhost:5173` 查看博客前台

### 方式二: Docker Compose 一键部署(推荐)

```bash
# 1. 确保已安装 Docker 和 Docker Compose

# 2. 在项目根目录创建 docker-compose.yml(参考示例)

# 3. 一键启动所有服务
docker-compose up -d

# 4. 查看服务状态
docker-compose ps

# 5. 查看日志
docker-compose logs -f

# 6. 停止所有服务
docker-compose down
```

### Docker Compose 示例配置

在项目根目录创建 `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: ruyu-mysql
    environment:
      MYSQL_ROOT_PASSWORD: your_password
      MYSQL_DATABASE: ruyu_blog
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./sql/Ruyu-Blog.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - ruyu-network

  redis:
    image: redis:6.0-alpine
    container_name: ruyu-redis
    ports:
      - "6379:6379"
    networks:
      - ruyu-network

  rabbitmq:
    image: rabbitmq:3.8-management-alpine
    container_name: ruyu-rabbitmq
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: admin
      RABBITMQ_DEFAULT_PASS: admin
    networks:
      - ruyu-network

  minio:
    image: minio/minio
    container_name: ruyu-minio
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    command: server /data --console-address ":9001"
    volumes:
      - minio-data:/data
    networks:
      - ruyu-network

  backend:
    build: ./blog-backend
    container_name: ruyu-backend
    ports:
      - "8088:8088"
    depends_on:
      - mysql
      - redis
      - rabbitmq
      - minio
    environment:
      SPRING_PROFILES_ACTIVE: prod
    networks:
      - ruyu-network

  admin-frontend:
    build: ./blog-frontend/kuailemao-admin
    container_name: ruyu-admin
    ports:
      - "99:80"
    depends_on:
      - backend
    networks:
      - ruyu-network

  blog-frontend:
    build: ./blog-frontend/kuailemao-blog
    container_name: ruyu-blog
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - ruyu-network

volumes:
  mysql-data:
  minio-data:

networks:
  ruyu-network:
    driver: bridge
```

### 默认账号密码

**管理后台登录:**
- 账号: `admin`
- 密码: 查看数据库初始化脚本

## 🔧 配置说明

### 后端配置文件

主要配置文件位于 `blog-backend/src/main/resources/`:

1. **application.yml** - 主配置文件
2. **application-dev.yml** - 开发环境配置
3. **application-prod.yml** - 生产环境配置

**关键配置项:**

```yaml
# 数据库配置
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ruyu_blog
    username: root
    password: your_password

# Redis配置
  redis:
    host: localhost
    port: 6379
    password: your_redis_password

# RabbitMQ配置
  rabbitmq:
    host: localhost
    port: 5672
    username: admin
    password: admin

# MinIO配置
minio:
  endpoint: http://localhost:9000
  accessKey: minioadmin
  secretKey: minioadmin
  bucketName: ruyu-blog

# JWT配置
jwt:
  secret: your_jwt_secret_key
  expiration: 86400000  # 24小时
```

### 前端配置文件

前端环境变量配置文件:

**开发环境** - `.env.development`:
```env
VITE_APP_BASE_URL=http://localhost:8088
VITE_APP_BASE_API=/api
```

**生产环境** - `.env.production`:
```env
VITE_APP_BASE_URL=https://your-api-domain.com
VITE_APP_BASE_API=/api
```

## 🚨 常见问题

### 1. 后端启动失败

**问题**: 数据库连接失败
**解决**: 检查 MySQL 是否启动,数据库名称、用户名、密码是否正确

**问题**: Redis 连接失败
**解决**: 检查 Redis 是否启动,端口是否正确,如果有密码需要配置密码

**问题**: RabbitMQ 连接失败
**解决**: 检查 RabbitMQ 是否启动,用户名密码是否正确

### 2. 前端启动失败

**问题**: `Cannot read properties of null (reading 'split')` 错误
**解决**:
1. 检查 `.env.development` 文件是否存在
2. 确保所有环境变量配置不为空
3. 删除 `node_modules` 重新安装依赖

**问题**: `husky - .git can't be found` 错误
**解决**:
```bash
cd 项目根目录
git init  # 初始化git仓库
```

### 3. Redis 序列化问题

**问题**: `/tag/list` 接口报 500 错误,Redis序列化失败
**解决**:
1. 清空 Redis 缓存: `redis-cli FLUSHDB`
2. 检查后端 Redis 序列化配置
3. 确保实体类实现了 `Serializable` 接口
4. 重启后端服务

详细解决方案参见: [Redis序列化问题修复指南](docs/redis-serialization-fix.md)

### 4. 文件上传失败

**问题**: MinIO 文件上传失败
**解决**:
1. 检查 MinIO 是否启动
2. 检查 MinIO 配置是否正确
3. 确保 bucket 已创建
4. 检查文件大小是否超过限制

## 📚 开发指南

### 代码规范

- **Java代码**: 遵循阿里巴巴Java开发手册
- **前端代码**: 使用 ESLint + Prettier 格式化
- **提交规范**: 遵循 Conventional Commits 规范

### 分支管理

- `main` - 主分支,稳定版本
- `dev` - 开发分支,最新功能
- `feature/*` - 功能分支
- `bugfix/*` - 修复分支

### 提交规范

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建/工具相关
```

示例:
```bash
git commit -m "feat: 添加文章点赞功能"
git commit -m "fix: 修复评论无法删除的问题"
```

## 🤝 参与贡献

我们非常欢迎你的贡献!你可以通过以下方式参与到项目中:

1. **提交问题**: 发现 bug 或有新功能建议,请提交 [Issue](https://github.com/kuailemao/Ruyu-Blog/issues)
2. **贡献代码**:
   - Fork 本仓库
   - 创建功能分支 (`git checkout -b feature/AmazingFeature`)
   - 提交你的修改 (`git commit -m 'feat: Add some AmazingFeature'`)
   - 推送到分支 (`git push origin feature/AmazingFeature`)
   - 提交 Pull Request

3. **完善文档**: 帮助改进文档,修正错别字,补充说明
4. **分享反馈**: 使用过程中的建议和意见

### 贡献者

感谢所有为这个项目做出贡献的开发者!

<a href="https://github.com/kuailemao/Ruyu-Blog/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=kuailemao/Ruyu-Blog" />
</a>

## 📊 项目统计

![Alt](https://repobeats.axiom.co/api/embed/your-repo-id.svg "Repobeats analytics image")

## 🗺️ 开发路线图

- [x] 基础功能开发
- [x] 前后端分离架构
- [x] Docker 容器化支持
- [ ] 单元测试覆盖
- [ ] 性能优化
- [ ] 移动端适配优化
- [ ] 微服务架构迁移
- [ ] 国际化支持
- [ ] 主题切换功能
- [ ] SSR服务端渲染

## 📄 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

这意味着你可以自由地:
- 使用本项目进行商业或非商业用途
- 修改源代码
- 分发和再授权

但你必须:
- 在你的副本中包含原始版权声明
- 包含许可证副本

## 💬 交流与反馈

如有问题、建议或者想参与讨论,欢迎通过以下方式联系我们:

### 加入交流群

<div align="center">
  <img src="img/Ruyu开源博客交流群群聊二维码.png" alt="交流群二维码" width="300">
  <p>扫码加入 Ruyu 开源博客交流群</p>
</div>

### 联系方式

- **GitHub Issues**: [提交问题](https://github.com/kuailemao/Ruyu-Blog/issues)
- **Pull Requests**: [贡献代码](https://github.com/kuailemao/Ruyu-Blog/pulls)
- **邮箱**: your-email@example.com

## ⭐ Star History

如果这个项目对你有帮助,请给个 Star 支持一下!

[![Star History Chart](https://api.star-history.com/svg?repos=kuailemao/Ruyu-Blog&type=Date)](https://star-history.com/#kuailemao/Ruyu-Blog&Date)

## 🙏 鸣谢

感谢以下开源项目和工具:

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue.js](https://vuejs.org/)
- [MyBatis-Plus](https://baomidou.com/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Vite](https://vitejs.dev/)

---

<div align="center">

**如果这个项目对你有帮助,请点个 Star ⭐ 支持一下!**

Made with ❤️ by [快乐猫](https://github.com/kuailemao)

*文档持续更新中,最后更新时间: 2025-11-16*

</div>
