@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════╗
echo ║     设置定时自动运行               ║
echo ╚════════════════════════════════════╝
echo.

set SCRIPT_DIR=%~dp0
set TASK_NAME=keyword-monitor

echo 请选择执行频率：
echo   1) 每天早上 8:00
echo   2) 每天早晚各一次（8:00 和 18:00）
echo   3) 每 6 小时一次
echo.
set /p choice=输入数字 [1-3]，默认 1：
if "%choice%"=="" set choice=1

:: 删除旧任务（如果存在）
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1
schtasks /delete /tn "%TASK_NAME%-evening" /f >nul 2>&1

if "%choice%"=="1" (
    schtasks /create /tn "%TASK_NAME%" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc daily /st 08:00 /f >nul
    echo ✅ 已设置：每天早上 8:00 自动运行
)

if "%choice%"=="2" (
    schtasks /create /tn "%TASK_NAME%" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc daily /st 08:00 /f >nul
    schtasks /create /tn "%TASK_NAME%-evening" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc daily /st 18:00 /f >nul
    echo ✅ 已设置：每天 8:00 和 18:00 自动运行
)

if "%choice%"=="3" (
    schtasks /create /tn "%TASK_NAME%" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc hourly /mo 6 /f >nul
    echo ✅ 已设置：每 6 小时自动运行
)

echo.
echo 其他操作：
echo   查看任务：在开始菜单搜索「任务计划程序」
echo   立即运行：双击 test.bat
echo   取消任务：在任务计划程序里找到 keyword-monitor 删除即可
echo.
pause
