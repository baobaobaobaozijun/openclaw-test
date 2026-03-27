#!/bin/bash
set -e

echo "🚀 开始部署包子铺博客系统..."

# 1. 进入部署目录
cd /opt/baozipu

# 2. 停止现有服务
echo "⏹️  停止现有服务..."
docker-compose down

# 3. 拉取最新镜像
echo "📥 拉取最新镜像..."
docker-compose pull

# 4. 启动服务
echo "▶️  启动服务..."
docker-compose up -d

# 5. 健康检查
echo "🏥 健康检查..."
sleep 10
curl -f http://localhost:8081/actuator/health || exit 1

echo "✅ 部署完成!"
docker-compose ps