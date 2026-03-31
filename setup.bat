@echo off

echo.
echo ===================================
echo   keyword-monitor 环境配置
echo ===================================
echo.

echo 正在检查 Node.js...
node -v > nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Node.js，请先安装 Node.js 20 以上版本
    echo 下载地址：https://nodejs.org/zh-cn/
    echo.
    pause
    exit /b 1
)
echo [OK] Node.js 已就绪

echo.
echo 正在安装 opencli...
npm list -g @jackwener/opencli > nul 2>&1
if %errorlevel% neq 0 (
    npm install -g @jackwener/opencli
) else (
    echo [OK] opencli 已安装，跳过
)

echo.
echo 正在安装项目依赖...
npm install
echo [OK] 依赖安装完成

echo.
echo ===================================
echo   配置完成！
echo ===================================
echo.
echo 下一步：
echo   1. 用记事本打开 config.js，填入邮箱和关键词
echo   2. 双击 install-extension.bat 安装 Chrome 扩展
echo   3. 双击 test.bat 测试运行
echo   4. 双击 setup-task.bat 设置每天自动运行
echo.
pause
