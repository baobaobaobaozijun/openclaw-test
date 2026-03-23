Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  包子铺博客系统 - 全量测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& "$scriptDir\test-auth.ps1"
Write-Host ""
& "$scriptDir\test-articles.ps1"
Write-Host ""
& "$scriptDir\test-categories-tags.ps1"
Write-Host ""
& "$scriptDir\test-frontend-smoke.ps1"
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  全量测试完成" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan