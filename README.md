# 開發環境建立腳本

## 聲明

此腳本僅供學習與研究使用，僅經過虛擬環境簡單測試，不保證能在所有環境下正常運作，由於腳本會直接覆蓋舊資料，包含 VSCode 設定檔、環境變數，**建議在新的環境下執行此腳本**，使用者需自行承擔風險。

## `install.ps1` 會為新電腦安裝以下軟體

* Chocolatey - 如同 Linux 下 APT、Pacman、yum 的 Windows 軟體套件管理器
* Notepad++ - 更好的記事本
* 7zip - 好用的壓縮包管理器
* .Net SDK - 基本的 .Net 開發環境支援（可選）
* Git - 版本控制軟體
* VSCode - IDE

## `install_IDEA.ps1` 會為新電腦安裝以下軟體

* Chocolatey - 如同 Linux 下 APT、Pacman、yum 的 Windows 軟體套件管理器
* IntelliJ IDEA Community - Java 開發 IDE

## 編譯器

使用 [Winlibs](https://winlibs.com) 的編譯器

腳本會試著搜尋最新版本的編譯器，預設下載為 `MinGW-w64 GCC`、`Win64`、`POSIX` 執行緒標準、`LLVM`、`Clang`、`UCRT` 標準庫的編譯器版本。

若要指定其他版本請自行修改 Pattern：

```ps
$file_pattern = "^winlibs-x86_64-posix-seh-gcc-[\d\w.]+-mingw-w64ucrt-[\d\w.-]+\.7z$"
```

## 編譯器安裝位置

腳本會將編譯器裝在 `C:\MingW64` 下，並設定好 PATH 以及相關配置

若要修改安裝位置，請自行修改

```ps
$dir = "C:\"
# 將會在 C:\ 下建立 MingW64 資料夾，並將編譯器安裝在此
```

以及環境變數、VSCode 的相關設定，參考以下連結：

[VSCode 設定 C++ 教學](https://ja-errorpro.codes/posts/2022/vscode_cpp_setup/)

[我的 VSCode 設定檔](https://github.com/ja-errorpro/My-Vscode-setting)

在安裝完成後，腳本會自行覆寫 `%APPDATA%\Code\User\settings.json`，即 VSCode 的預設設定檔，建議安裝前請先備份原本的設定檔。

## VSCode 擴充套件

`install.ps1` 會安裝以下 VSCode 擴充套件：

* Code Runner
* C/C++ 相關套件
* 繁體中文語言包
* Remote SSH 遠端開發套件
* GitLens - Git 工具
* Snippet-Creator - 用於建立程式碼片段

## 使用方式

### VSCode

1. 下載 `install.ps1`
2. 以系統管理員身分執行 PowerShell，並切換到 `install.ps1` 所在的資料夾
3. 輸入以下指令以允許執行腳本

```ps
Set-ExecutionPolicy Bypass -Scope Process -Force
```

4. 使用 `.\install.ps1` 執行腳本
5. 開始使用 VSCode！

### IntelliJ IDEA

1. 下載 `install_IDEA.ps1`
2. 以系統管理員身分執行 PowerShell，並切換到 `install_IDEA.ps1` 所在的資料夾
3. 輸入以下指令以允許執行腳本

```ps
Set-ExecutionPolicy Bypass -Scope Process -Force
```

4. 使用 `.\install_IDEA.ps1` 執行腳本
5. 開始使用 IntelliJ IDEA！