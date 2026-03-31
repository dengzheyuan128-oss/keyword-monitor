@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════╗
echo ║     下载 opencli Chrome 扩展       ║
echo ╚════════════════════════════════════╝
echo.

set INSTALL_DIR=%USERPROFILE%\.opencli-extension

:: 创建目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 下载扩展
echo ▸ 正在下载扩展文件...
echo   （如果下载失败，请手动访问 https://github.com/jackwener/opencli/releases 下载）
echo.

powershell -Command "& {$url = (Invoke-RestMethod 'https://api.github.com/repos/jackwener/opencli/releases/latest').assets | Where-Object {$_.name -like '*extension*'} | Select-Object -ExpandProperty browser_download_url; Invoke-WebRequest -Uri $url -OutFile '%INSTALL_DIR%\opencli-extension.zip'}"

if %errorlevel% neq 0 (
    echo ✗ 自动下载失败，请手动操作：
    echo   1. 打开 https://github.com/jackwener/opencli/releases
    echo   2. 下载 opencli-extension.zip
    echo   3. 解压到任意文件夹
    echo   4. 在 Chrome 中加载该文件夹
    pause
    exit /b 1
)

:: 解压
echo ▸ 正在解压...
powershell -Command "Expand-Archive -Path '%INSTALL_DIR%\opencli-extension.zip' -DestinationPath '%INSTALL_DIR%\extension' -Force"
del "%INSTALL_DIR%\opencli-extension.zip"
echo ✓ 解压完成

echo.
echo ════════════════════════════════════
echo.
echo ✅ 扩展文件已准备好！
echo.
echo 接下来在 Chrome 里加载（30 秒搞定）：
echo.
echo   1. 打开 Chrome，地址栏输入：
echo      chrome://extensions
echo.
echo   2. 右上角打开「开发者模式」
echo.
echo   3. 点击「加载已解压的扩展程序」
echo      选择这个文件夹：
echo      %INSTALL_DIR%\extension
echo.
echo   4. 扩展出现在列表中即安装成功
echo.
echo 装好之后，打开命令提示符运行以下命令验证：
echo      opencli doctor
echo.

:: 自动打开文件夹方便用户找到路径
explorer "%INSTALL_DIR%\extension"

pause
