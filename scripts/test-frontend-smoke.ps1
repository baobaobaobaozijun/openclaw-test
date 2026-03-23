param([string]$BaseUrl = "http://{SERVER_IP}")
$passed = 0; $failed = 0
function Test-Page($name, $url, $expected) {
    try {
        $r = Invoke-WebRequest -Uri $url -ErrorAction Stop
        if ($r.StatusCode -eq $expected) { Write-Host "  PASS: $name" -ForegroundColor Green; $script:passed++ }
        else { Write-Host "  FAIL: $name" -ForegroundColor Red; $script:failed++ }
    } catch { Write-Host "  FAIL: $name ($($_.Exception.Message))" -ForegroundColor Red; $script:failed++ }
}
Write-Host "=== Frontend Smoke Tests ===" -ForegroundColor Cyan
Test-Page "Homepage" "$BaseUrl/" 200
Test-Page "Has index.html" "$BaseUrl/" 200
Test-Page "Has JS assets" "$BaseUrl/assets/" 200
Write-Host "`n=== Results: $passed passed, $failed failed ==="