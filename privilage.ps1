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

exit 0