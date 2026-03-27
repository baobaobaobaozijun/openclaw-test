# 包子铺博客系统部署文档

## 环境要求
- Java 21
- MySQL 8.0+
- Redis 7.0+
- Docker 20.10+
- Docker Compose 1.29+

## 快速部署

### 1. 准备环境变量
```bash
echo 'DB_PASSWORD=你的密码' > .env
```

### 2. 执行部署脚本
```bash
chmod +x deploy.sh
./deploy.sh
```

### 3. 健康检查
```bash
./health-check.sh
```

## 服务端口
| 服务 | 端口 | 说明 |
|------|------|------|
| 前端 | 80 | Nginx |
| 后端 | 8081 | Spring Boot |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |

## API 文档
访问 http://localhost:8081/swagger-ui.html

## 日志位置
- 后端：/opt/baozipu/backend/app.log
- 前端：/opt/baozipu/frontend/