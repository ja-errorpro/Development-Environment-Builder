# Privilage to Administrator

$ErrorActionPreference = 'STOP'
$wp = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not $wp.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Write-Host "`n<!>此腳本需要系統管理員權限才可使用，即將退出腳本<!>`n" -BackgroundColor DarkRed
	pause
	exit 1
}

# Set Encoding to utf-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
# Install Chocolatey
Write-Host "`n--- IDEA 開發環境自動建置腳本 by {ja-errorpro} ---`n" -ForegroundColor Green

Write-Host "`n開始安裝 Chocolatey...`n" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "`n開始安裝 OpenJDK...`n" -ForegroundColor Green
choco install -y openjdk
Write-Host "`n開始安裝 Maven 專案管理工具...`n" -ForegroundColor Green
choco install -y maven
Write-Host "`n開始安裝 Gradle 專案管理工具...`n" -ForegroundColor Green
choco install -y gradle
Write-Host "`n開始安裝 IDEA Community...`n" -ForegroundColor Green
choco install -y intellijidea-community