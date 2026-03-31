@echo off

echo.
echo ===================================
echo   下载 opencli Chrome 扩展
echo ===================================
echo.

set INSTALL_DIR=%USERPROFILE%\.opencli-extension

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo 正在下载扩展文件...
powershell -Command "& { $rel = Invoke-RestMethod 'https://api.github.com/repos/jackwener/opencli/releases/latest'; $url = ($rel.assets | Where-Object { $_.name -like '*extension*' }).browser_download_url; Invoke-WebRequest -Uri $url -OutFile '%INSTALL_DIR%\opencli-extension.zip' }"

if %errorlevel% neq 0 (
    echo [错误] 下载失败，请手动访问以下地址下载 opencli-extension.zip：
    echo https://github.com/jackwener/opencli/releases
    pause
    exit /b 1
)

echo 正在解压...
powershell -Command "Expand-Archive -Path '%INSTALL_DIR%\opencli-extension.zip' -DestinationPath '%INSTALL_DIR%\extension' -Force"
del "%INSTALL_DIR%\opencli-extension.zip"
echo [OK] 解压完成

echo.
echo ===================================
echo   请在 Chrome 里完成最后一步
echo ===================================
echo.
echo 1. 打开 Chrome，地址栏输入：chrome://extensions
echo 2. 右上角打开「开发者模式」
echo 3. 点击「加载已解压的扩展程序」
echo    选择下面这个文件夹（窗口已自动打开）：
echo    %INSTALL_DIR%\extension
echo 4. 扩展出现在列表中即安装成功
echo.
echo 装好之后，打开命令提示符运行：opencli doctor
echo 看到 Connected 就成功了
echo.

explorer "%INSTALL_DIR%\extension"
pause
