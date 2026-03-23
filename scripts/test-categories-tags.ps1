param([string]$BaseUrl = "http://{SERVER_IP}/api")
$passed = 0; $failed = 0
function Test-API($name, $method, $url, $expected) {
    try {
        $r = Invoke-WebRequest -Uri $url -Method $method -ContentType "application/json" -ErrorAction Stop
        if ($r.StatusCode -eq $expected) { Write-Host "  PASS: $name" -ForegroundColor Green; $script:passed++ }
        else { Write-Host "  FAIL: $name (got $($r.StatusCode))" -ForegroundColor Red; $script:failed++ }
    } catch { Write-Host "  FAIL: $name ($($_.Exception.Message))" -ForegroundColor Red; $script:failed++ }
}
Write-Host "=== Category & Tag Tests ===" -ForegroundColor Cyan
Test-API "Get categories" "GET" "$BaseUrl/categories" 200
Test-API "Get tags" "GET" "$BaseUrl/tags" 200
Write-Host "`n=== Results: $passed passed, $failed failed ==="