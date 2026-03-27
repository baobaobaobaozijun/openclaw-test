#!/bin/bash
set -e

echo "🏥 包子铺博客系统健康检查..."

# 检查后端
echo "检查后端服务 (8081)..."
curl -sf http://localhost:8081/actuator/health > /dev/null && echo "✅ 后端正常" || echo "❌ 后端异常"

# 检查前端
echo "检查前端服务 (80)..."
curl -sf http://localhost:80/ > /dev/null && echo "✅ 前端正常" || echo "❌ 前端异常"

# 检查 API
echo "检查文章 API..."
curl -sf http://localhost:8081/api/articles > /dev/null && echo "✅ API 正常" || echo "❌ API 异常"

echo "健康检查完成!"