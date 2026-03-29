# 将本站推送到 GitHub Pages 仓库
# 仓库: https://github.com/ideacreatorgames/cardstrategysaga.github.io
# 站点: https://ideacreatorgames.github.io/cardstrategysaga.github.io/
#
# 使用前请安装 Git for Windows: https://git-scm.com/download/win
# 在 PowerShell 中执行: 先 cd 到本脚本所在目录，再运行:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; .\push-to-github.ps1

$ErrorActionPreference = "Stop"
$RemoteUrl = "https://github.com/ideacreatorgames/cardstrategysaga.github.io.git"
$Root = $PSScriptRoot
Set-Location $Root

$GitExe = $null
if (Get-Command git -ErrorAction SilentlyContinue) {
    $GitExe = "git"
} elseif (Test-Path "C:\Program Files\Git\bin\git.exe") {
    $GitExe = "C:\Program Files\Git\bin\git.exe"
}
if (-not $GitExe) {
    Write-Host "未找到 git。请安装 Git for Windows: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

function Invoke-Git { & $GitExe @args }

if (-not (Test-Path ".git")) {
    Invoke-Git init
    Invoke-Git branch -M main
}

$null = Invoke-Git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Invoke-Git remote add origin $RemoteUrl
} else {
    Invoke-Git remote set-url origin $RemoteUrl
}

Invoke-Git add -A
$status = Invoke-Git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "没有需要提交的更改。" -ForegroundColor Yellow
} else {
    Invoke-Git commit -m "Update Card Strategy Saga site ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
}

Write-Host "正在尝试推送到 origin main ..." -ForegroundColor Cyan
Invoke-Git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "推送失败。若远程已有提交，可先执行：" -ForegroundColor Yellow
    Write-Host "  git pull origin main --allow-unrelated-histories" -ForegroundColor Gray
    Write-Host "解决冲突后再 git push。若确认用本地覆盖远程（慎用）：" -ForegroundColor Yellow
    Write-Host "  git push -u origin main --force" -ForegroundColor Gray
    exit 1
}

Write-Host "完成。几分钟后访问: https://ideacreatorgames.github.io/cardstrategysaga.github.io/" -ForegroundColor Green
