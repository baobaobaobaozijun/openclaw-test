# Article API 测试脚本
param([string]$BaseUrl = "http://8.137.175.240/api")

$passed = 0; $failed = 0

function Test-API($name, $method, $url, $body, $expectedStatus, $headers) {
    try {
        $params = @{ Uri = $url; Method = $method; ContentType = "application/json" }
        if ($body) { $params.Body = ($body | ConvertTo-Json) }
        if ($headers) { $params.Headers = $headers }
        $response = Invoke-WebRequest @params -ErrorAction Stop
        if ($response.StatusCode -eq $expectedStatus) {
            Write-Host "  PASS: $name (HTTP $($response.StatusCode))" -ForegroundColor Green
            $script:passed++
            return ($response.Content | ConvertFrom-Json)
        } else {
            Write-Host "  FAIL: $name (expected $expectedStatus, got $($response.StatusCode))" -ForegroundColor Red
            $script:failed++
        }
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        if ($status -eq $expectedStatus) {
            Write-Host "  PASS: $name (HTTP $status as expected)" -ForegroundColor Green
            $script:passed++
        } else {
            Write-Host "  FAIL: $name ($($_.Exception.Message))" -ForegroundColor Red
            $script:failed++
        }
    }
}

Write-Host "=== Article API Tests ===" -ForegroundColor Cyan

# 先注册登录获取 token
$phone = "139" + (Get-Random -Minimum 10000000 -Maximum 99999999)
Write-Host "[Setup] Register + Login ($phone)"
$reg = Test-API "Setup-Register" "POST" "$BaseUrl/auth/register" @{phone=$phone;password="test123456"} 200
$login = Test-API "Setup-Login" "POST" "$BaseUrl/auth/login" @{phone=$phone;password="test123456"} 200
$token = if ($login.data.token) { $login.data.token } else { "mock-token" }
$authHeader = @{ Authorization = "Bearer $token" }

# Test 1: 获取文章列表（公开）
Write-Host "[Test 1] Get articles list"
Test-API "List articles" "GET" "$BaseUrl/articles?page=1&size=10" $null 200

# Test 2: 创建文章（需登录）
Write-Host "[Test 2] Create article"
$article = Test-API "Create article" "POST" "$BaseUrl/articles" @{title="测试文章";content="# Hello";categoryId=1} 200 $authHeader

# Test 3: 获取文章详情
if ($article.data.id) {
    Write-Host "[Test 3] Get article detail"
    Test-API "Article detail" "GET" "$BaseUrl/articles/$($article.data.id)" $null 200
}

# Test 4: 获取分类列表
Write-Host "[Test 4] Get categories"
Test-API "Categories" "GET" "$BaseUrl/categories" $null 200

# Test 5: 获取标签列表
Write-Host "[Test 5] Get tags"
Test-API "Tags" "GET" "$BaseUrl/tags" $null 200

# Test 6: 未登录创建文章（应拒绝）
Write-Host "[Test 6] Create article without auth"
Test-API "No auth create" "POST" "$BaseUrl/articles" @{title="test";content="test"} 401

Write-Host ""
Write-Host "=== Results: $passed passed, $failed failed ===" -ForegroundColor $(if ($failed -eq 0) {"Green"} else {"Red"})