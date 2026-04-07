#!/bin/bash

# Plan-008 R3 E2E Test Script
# 测试环境：http://8.137.175.240/
# API 端点：http://8.137.175.240/api/articles/

set -e

echo "Starting E2E Tests..."

# 测试 1：首页可访问（HTTP 200）
echo "Test 1: Checking homepage accessibility..."
if curl -s -o /dev/null -w "%{http_code}" http://8.137.175.240/ | grep -q "200"; then
    echo "✅ Test 1 PASSED: Homepage accessible"
else
    echo "❌ Test 1 FAILED: Homepage not accessible"
    exit 1
fi

# 测试 2：文章列表 API 返回数据
echo "Test 2: Checking articles API..."
api_response=$(curl -s http://8.137.175.240/api/articles/)
if [[ -n "$api_response" && "$api_response" != "[]" ]]; then
    echo "✅ Test 2 PASSED: Articles API returns data"
else
    echo "❌ Test 2 FAILED: Articles API returns empty or error"
    exit 1
fi

# 测试 3：文章列表页显示文章
echo "Test 3: Checking articles list page..."
articles_html=$(curl -s http://8.137.175.240/)
article_count=$(echo "$articles_html" | grep -o '<div class="article"' | wc -l)
if [[ $article_count -gt 0 ]]; then
    echo "✅ Test 3 PASSED: Articles displayed on frontend ($article_count articles found)"
else
    echo "❌ Test 3 FAILED: No articles displayed on frontend"
    exit 1
fi

# 测试 4：API 文章数量 = 数据库文章数量
echo "Test 4: Checking API count vs database count..."
api_count=$(echo "$api_response" | jq '. | length' 2>/dev/null || echo "${#api_response}")

# 获取数据库中的文章数量（通过 SSH 连接到服务器执行 MySQL 查询）
db_count=$(ssh -o StrictHostKeyChecking=no root@8.137.175.240 "mysql -u root -p\$(cat /root/mysql_password.txt) -D openclaw -s -N -e 'SELECT COUNT(*) FROM articles;'")

if [[ $api_count == $db_count ]]; then
    echo "✅ Test 4 PASSED: API count matches database count ($api_count articles)"
else
    echo "❌ Test 4 FAILED: API count ($api_count) does not match database count ($db_count)"
    exit 1
fi

# 测试 5：最新文章创建时间 < 1 小时前
echo "Test 5: Checking latest article creation time..."
latest_article_time=$(echo "$api_response" | jq -r '.[0].created_at' 2>/dev/null | head -1)
if [[ -n "$latest_article_time" && "$latest_article_time" != "null" ]]; then
    # 将时间转换为秒级时间戳进行比较
    latest_timestamp=$(date -d "$latest_article_time" +%s)
    current_timestamp=$(date +%s)
    time_diff=$((current_timestamp - latest_timestamp))
    
    if [[ $time_diff -lt 3600 ]]; then
        echo "✅ Test 5 PASSED: Latest article created less than 1 hour ago"
    else
        echo "❌ Test 5 FAILED: Latest article created more than 1 hour ago"
        exit 1
    fi
else
    echo "❌ Test 5 FAILED: Could not get latest article creation time"
    exit 1
fi

echo "All tests passed! 🎉"