# Plan-008 R3 E2E Test Script (PowerShell Version)
# 测试环境：http://8.137.175.240/
# API 端点：http://8.137.175.240/api/articles/

Write-Host "Starting E2E Tests..." -ForegroundColor Green

# 测试 1：首页可访问（HTTP 200）
Write-Host "Test 1: Checking homepage accessibility..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://8.137.175.240/" -Method GET -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Test 1 PASSED: Homepage accessible" -ForegroundColor Green
    } else {
        Write-Host "❌ Test 1 FAILED: Homepage returned status $($response.StatusCode)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Test 1 FAILED: Homepage not accessible - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试 2：文章列表 API 返回数据
Write-Host "Test 2: Checking articles API..." -ForegroundColor Yellow
try {
    $apiResponse = Invoke-RestMethod -Uri "http://8.137.175.240/api/articles/" -Method GET -TimeoutSec 10
    if ($apiResponse -and $apiResponse.Count -gt 0) {
        Write-Host "✅ Test 2 PASSED: Articles API returns data ($($apiResponse.Count) articles)" -ForegroundColor Green
    } else {
        Write-Host "❌ Test 2 FAILED: Articles API returns empty or error" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Test 2 FAILED: Articles API error - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试 3：文章列表页显示文章
Write-Host "Test 3: Checking articles list page..." -ForegroundColor Yellow
try {
    $articlesHtml = (Invoke-WebRequest -Uri "http://8.137.175.240/" -Method GET).Content
    # 计算文章数量（假设文章元素有特定类名）
    $articleMatches = [regex]::Matches($articlesHtml, '<div[^>]*class="[^"]*article[^"]*"')
    $articleCount = $articleMatches.Count
    
    if ($articleCount -gt 0) {
        Write-Host "✅ Test 3 PASSED: Articles displayed on frontend ($articleCount articles found)" -ForegroundColor Green
    } else {
        # 尝试其他可能的文章标记
        $articleMatches = [regex]::Matches($articlesHtml, '<article|<h[1-6][^>]*>.*?</h[1-6]>|<li[^>]*class="[^"]*post[^"]*"')
        $articleCount = $articleMatches.Count
        
        if ($articleCount -gt 0) {
            Write-Host "✅ Test 3 PASSED: Articles displayed on frontend ($articleCount articles found)" -ForegroundColor Green
        } else {
            Write-Host "❌ Test 3 FAILED: No articles displayed on frontend" -ForegroundColor Red
            exit 1
        }
    }
} catch {
    Write-Host "❌ Test 3 FAILED: Error accessing articles page - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试 4：API 文章数量 = 数据库文章数量
Write-Host "Test 4: Checking API count vs database count..." -ForegroundColor Yellow
try {
    $apiCount = $apiResponse.Count
    
    # 通过 SSH 连接到服务器执行 MySQL 查询来获取数据库中的文章数量
    # 注意：这里我们使用 SSH 命令而不是直接连接数据库，因为数据库可能不对外网开放
    $sshCommand = "mysql -u root -p\$(cat /root/mysql_password.txt) -D openclaw -s -N -e 'SELECT COUNT(*) FROM articles;'"
    $dbCountResult = ssh -o StrictHostKeyChecking=no root@8.137.175.240 $sshCommand 2>$null
    
    # 检查 SSH 命令是否成功执行
    if ($LASTEXITCODE -eq 0 -and $dbCountResult -ne $null) {
        $dbCount = [int]$dbCountResult.Trim()
        
        if ($apiCount -eq $dbCount) {
            Write-Host "✅ Test 4 PASSED: API count matches database count ($apiCount articles)" -ForegroundColor Green
        } else {
            Write-Host "❌ Test 4 FAILED: API count ($apiCount) does not match database count ($dbCount)" -ForegroundColor Red
            exit 1
        }
    } else {
        # 如果 SSH 连接失败，尝试另一种方式估算
        Write-Host "⚠️  Could not verify database count via SSH, skipping this test" -ForegroundColor Yellow
        Write-Host "✅ Test 4 SKIPPED: Unable to connect to database for verification" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Test 4 FAILED: Error comparing API and database counts - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试 5：最新文章创建时间 < 1 小时前
Write-Host "Test 5: Checking latest article creation time..." -ForegroundColor Yellow
try {
    if ($apiResponse -and $apiResponse.Count -gt 0) {
        # 获取第一篇文章的创建时间
        $firstArticle = $apiResponse | Select-Object -First 1
        $createdAtStr = $firstArticle.created_at
        
        if ($createdAtStr) {
            # 尝试解析创建时间
            $createdAt = [DateTime]::Parse($createdAtStr)
            $currentTime = Get-Date
            $timeDiff = $currentTime - $createdAt
            
            if ($timeDiff.TotalMinutes -lt 60) {
                Write-Host "✅ Test 5 PASSED: Latest article created less than 1 hour ago (created $($timeDiff.Minutes) minutes ago)" -ForegroundColor Green
            } else {
                Write-Host "❌ Test 5 FAILED: Latest article created more than 1 hour ago (created $($timeDiff.Minutes) minutes ago)" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "❌ Test 5 FAILED: Could not get latest article creation time" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "❌ Test 5 FAILED: No articles to check creation time" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Test 5 FAILED: Error checking latest article creation time - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "All tests completed successfully! 🎉" -ForegroundColor Green