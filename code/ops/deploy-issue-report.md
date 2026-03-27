# 部署问题报告

**时间:** 2026-03-27 10:45
**服务器:** 8.137.175.240
**问题:** Docker 未安装

## 检查结果
- docker 命令：❌ 未找到
- docker-compose 命令：❌ 未找到

## 解决方案
1. 安装 Docker Engine
2. 安装 Docker Compose 插件
3. 重新执行部署脚本

## 安装命令 (需 PM 执行)
```bash
# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 安装 Docker Compose
apt-get install docker-compose-plugin

# 验证安装
docker --version
docker compose version
```