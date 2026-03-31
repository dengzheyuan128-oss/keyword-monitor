@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════╗
echo ║     keyword-monitor 环境配置       ║
echo ╚════════════════════════════════════╝
echo.

:: 检查 Node.js
echo ▸ 检查 Node.js...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ 未找到 Node.js，请先安装 Node.js ^>= 20
    echo   下载地址：https://nodejs.org/zh-cn/
    pause
    exit /b 1
)

for /f "tokens=1 delims=v." %%a in ('node -v') do set NODE_MAJOR=%%a
for /f "tokens=2 delims=v." %%a in ('node -v') do set NODE_MAJOR=%%a
if %NODE_MAJOR% LSS 20 (
    echo ✗ Node.js 版本过低，请升级到 v20 以上
    echo   下载地址：https://nodejs.org/zh-cn/
    pause
    exit /b 1
)
echo ✓ Node.js 已就绪

:: 安装 opencli
echo.
echo ▸ 安装 opencli...
call npm list -g @jackwener/opencli >nul 2>&1
if %errorlevel% neq 0 (
    call npm install -g @jackwener/opencli
) else (
    echo ✓ opencli 已安装
)

:: 安装项目依赖
echo.
echo ▸ 安装项目依赖...
call npm install
echo ✓ 依赖安装完成

:: 检查配置文件
echo.
echo ▸ 检查配置文件...
findstr /c:"your_address@qq.com" config.js >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠  请用记事本打开 config.js，填入你的邮箱和关键词！
) else (
    echo ✓ 配置文件已填写
)

echo.
echo ════════════════════════════════════
echo.
echo ✅ 环境配置完成！
echo.
echo 下一步：
echo   1. 用记事本打开 config.js 填入配置
echo   2. 双击 test.bat 测试运行
echo   3. 双击 setup-task.bat 设置定时任务
echo.
pause
