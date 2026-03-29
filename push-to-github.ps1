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

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "未找到 git 命令。请先安装 Git 并确保已加入 PATH，然后重新运行本脚本。" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

$hasRemote = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    git remote add origin $RemoteUrl
} else {
    git remote set-url origin $RemoteUrl
}

git add -A
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "没有需要提交的更改。" -ForegroundColor Yellow
} else {
    git commit -m "Update Card Strategy Saga site ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
}

Write-Host "正在尝试推送到 origin main ..." -ForegroundColor Cyan
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "推送失败。若远程已有提交，可先执行：" -ForegroundColor Yellow
    Write-Host "  git pull origin main --allow-unrelated-histories" -ForegroundColor Gray
    Write-Host "解决冲突后再 git push。若确认用本地覆盖远程（慎用）：" -ForegroundColor Yellow
    Write-Host "  git push -u origin main --force" -ForegroundColor Gray
    exit 1
}

Write-Host "完成。几分钟后访问: https://ideacreatorgames.github.io/cardstrategysaga.github.io/" -ForegroundColor Green
