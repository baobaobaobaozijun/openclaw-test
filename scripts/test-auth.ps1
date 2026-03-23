# Auth API 测试脚本
# 用法: .\test-auth.ps1 [-BaseUrl "http://8.137.175.240/api"]

param(
    [string]$BaseUrl = "http://8.137.175.240/api"
)

$passed = 0
$failed = 0

function Test-API($name, $method, $url, $body, $expectedStatus) {
    try {
        $params = @{ Uri = $url; Method = $method; ContentType = "application/json" }
        if ($body) { $params.Body = ($body | ConvertTo-Json) }
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

Write-Host "=== Auth API Tests ===" -ForegroundColor Cyan
Write-Host "Base URL: $BaseUrl"
Write-Host ""

# Test 1: 注册新用户
$phone = "138" + (Get-Random -Minimum 10000000 -Maximum 99999999)
Write-Host "[Test 1] Register new user ($phone)"
$regResult = Test-API "Register" "POST" "$BaseUrl/auth/register" @{phone=$phone; password="test123456"} 200

# Test 2: 登录已注册用户
Write-Host "[Test 2] Login registered user"
$loginResult = Test-API "Login" "POST" "$BaseUrl/auth/login" @{phone=$phone; password="test123456"} 200

# Test 3: 登录错误密码
Write-Host "[Test 3] Login wrong password"
Test-API "Wrong password" "POST" "$BaseUrl/auth/login" @{phone=$phone; password="wrongpass"} 401

# Test 4: 无效手机号
Write-Host "[Test 4] Invalid phone"
Test-API "Invalid phone" "POST" "$BaseUrl/auth/login" @{phone="123"; password="test"} 400

Write-Host ""
Write-Host "=== Results: $passed passed, $failed failed ===" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })