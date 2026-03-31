@echo off

echo.
echo ===================================
echo   Schedule automatic daily run
echo ===================================
echo.
echo Choose frequency:
echo   1. Every day at 8:00 AM
echo   2. Twice a day (8:00 AM and 6:00 PM)
echo   3. Every 6 hours
echo.
set /p choice=Enter number [1/2/3], default 1:
if "%choice%"=="" set choice=1

set SCRIPT_DIR=%~dp0
set TASK_NAME=keyword-monitor

schtasks /delete /tn "%TASK_NAME%" /f > nul 2>&1
schtasks /delete /tn "%TASK_NAME%-evening" /f > nul 2>&1

if "%choice%"=="1" (
    schtasks /create /tn "%TASK_NAME%" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc daily /st 08:00 /f > nul
    echo [OK] Scheduled: every day at 8:00 AM
)
if "%choice%"=="2" (
    schtasks /create /tn "%TASK_NAME%" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc daily /st 08:00 /f > nul
    schtasks /create /tn "%TASK_NAME%-evening" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc daily /st 18:00 /f > nul
    echo [OK] Scheduled: every day at 8:00 AM and 6:00 PM
)
if "%choice%"=="3" (
    schtasks /create /tn "%TASK_NAME%" /tr "node \"%SCRIPT_DIR%monitor.js\"" /sc hourly /mo 6 /f > nul
    echo [OK] Scheduled: every 6 hours
)

echo.
echo To cancel: search for Task Scheduler, find keyword-monitor and delete it.
echo.
pause
