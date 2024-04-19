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
Write-Host "`n--- VSC 開發環境自動建置腳本 by {ja-errorpro} ---`n" -ForegroundColor Green

# Add env
function AddENV {
	param(
		[string]$InstallFolder
	)
	try {
		$registryKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $false)
		$originalPath = $registryKey.GetValue(`
			'PATH', `
			'', `
			[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames `
		)
		$pathParts = $originalPath -split ';'

		if (!($pathParts -contains $InstallFolder)) {
			Write-Host "`n正在新增 $InstallFolder 到 PATH`n" -ForegroundColor Green

			# SetEnvironmentVariable broadcasts the "Environment" change to
			# Windows and is NOT destructive (e.g. expanding variables)
			[Environment]::SetEnvironmentVariable(
				'PATH', `
				"$originalPath;$InstallFolder", `
				[EnvironmentVariableTarget]::User`
			)

			# Also add the path to the current session
			$env:PATH += ";$InstallFolder"
		} else {
			Write-Host "`n$InstallFolder 已經在 PATH 裡了ヾ(≧▽≦*)o`n" -ForegroundColor Green
		}
	}finally {
		if ($registryKey) {
			$registryKey.Close()
		}
	}
}

Write-Host "`n開始安裝 Chocolatey...`n" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install basic softwares and sdk
Write-Host "`n開始安裝 Notepad++...`n" -ForegroundColor Green
choco install -y notepadplusplus
Write-Host "`n開始安裝 7zip...`n" -ForegroundColor Green
choco install -y 7zip
Write-Host "`n開始安裝 .Net SDK...`n" -ForegroundColor Green
choco install -y dotnet-sdk
Write-Host "`n開始安裝 Git...`n" -ForegroundColor Green
choco install -y git
Write-Host "`n開始安裝 Python...`n" -ForegroundColor Green
choco install -y python
Write-Host "`n開始安裝 VSCode...`n" -ForegroundColor Green
choco install -y vscode

# Setup C-Cpp Compiler(Winlibs)
Write-Host "`n正在準備下載 C-C++ 編譯器...`n" -ForegroundColor Green
$winlibs_URL = "https://api.github.com/repos/brechtsanders/winlibs_mingw/releases"

# Choose the latest, proper compiler
$file_pattern = "^winlibs-x86_64-posix-seh-gcc-[\d\w.]+-llvm-[\d\w.]+-mingw-w64ucrt-[\d\w.-]+\.7z$"
$winlibs_download_URL = ((Invoke-RestMethod -Method GET -Uri $winlibs_URL).assets | Where-Object name -match $file_pattern ).browser_download_url

if ($winlibs_download_URL -le 0) {
	Write-Host "`n錯誤：找不到最新版本的編譯器`n" -BackgroundColor Red
	pause
	exit
}

$winlibs_download_URL = $winlibs_download_URL[0]

$file = "MingW64.7z"
$filename = $("MingW64.7z" -split '\.')[0]
Write-Host "`n開始下載 C-C++ 編譯器...`n" -ForegroundColor Green
Invoke-WebRequest -Uri $winlibs_download_URL -Out $file

$dir = "C:\"
# Clean up target dir
Write-Host "`n正在移除舊版編譯器...`n" -ForegroundColor Green
Remove-Item -Path $dir\$filename -Recurse -Force -ErrorAction SilentlyContinue

# Move file from tmp to target dir
Write-Host "`n正在準備解壓縮...`n" -ForegroundColor Green
Move-Item $file -Destination $dir -Force

# Extract 7z 
Write-Host "`n正在解壓縮檔案...`n" -ForegroundColor Green
$seven_zip = "7z.exe"
$seven_zip_param = @( "x", "$dir\$file", "-o$dir$filename")
&$seven_zip @seven_zip_param

# Remove 7z
Write-Host "`n正在移除暫存資料...`n" -ForegroundColor Green
Remove-Item $dir\$file -Force -ErrorAction SilentlyContinue

# Add compiler path to ENV

$VSCFolder = "C:\Program Files\Microsoft VS Code\bin"
$CompilerPath = $dir + $filename + "\mingw64\bin"

AddENV $VSCFolder
AddENV $CompilerPath



# Setup vscode
Write-Host "`n正在安裝 VSCode 擴充套件...`n" -ForegroundColor Green
Write-Host "`n正在安裝 Code-Runner...`n" -ForegroundColor Green
code --install-extension formulahendry.code-runner
Write-Host "`n正在安裝 C-C++ 支援套件...`n" -ForegroundColor Green
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension ms-vscode.cpptools-themes
Write-Host "`n正在安裝繁體中文套件...`n" -ForegroundColor Green
code --install-extension MS-CEINTL.vscode-language-pack-zh-hant
Write-Host "`n正在安裝遠端操作功能...`n" -ForegroundColor Green
code --install-extension ms-vscode-remote.remote-ssh
Write-Host "`n正在安裝 Git 支援套件...`n" -ForegroundColor Green
code --install-extension eamodio.gitlens
Write-Host "`n正在安裝程式碼縮寫套件...`n" -ForegroundColor Green
code --install-extension wware.snippet-creator

# Setup VSCode Profile
$target_profile = "$Env:APPDATA\Code\User\settings.json"
$Profile_url = "https://gist.githubusercontent.com/ja-errorpro/fd6d7db2a15239f877ac2bc9cab008c0/raw/638d40b948883f739e2fb1e86b89cbd0cfd4700e/settings_VSC_PowerShellScript.json"
Invoke-WebRequest -Uri $Profile_url -Out $target_profile

# Enjoy your coding time...
Write-Host "`n你的 VSCode 已經設定好了~！╰(*°▽°*)╯`n" -ForegroundColor Green