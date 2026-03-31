@echo off
cd /d "%~dp0"

echo.
echo ===================================
echo   Schedule daily keyword monitor
echo ===================================
echo.
echo Choose time:
echo   1. Every day at 8:00 AM
echo   2. Every day at 9:00 AM
echo   3. Every day at 7:00 AM
echo.
set /p choice=Enter number [1/2/3], default 1:
if "%choice%"=="" set choice=1

if "%choice%"=="1" set TASKTIME=08:00
if "%choice%"=="2" set TASKTIME=09:00
if "%choice%"=="3" set TASKTIME=07:00

set TASK_NAME=keyword-monitor
set MONITOR_PATH=%~dp0monitor.bat

schtasks /delete /tn "%TASK_NAME%" /f > nul 2>&1
schtasks /create /tn "%TASK_NAME%" /tr "%MONITOR_PATH%" /sc daily /st %TASKTIME% /f > nul

echo.
echo [OK] Scheduled: every day at %TASKTIME%
echo Results will be saved to: %~dp0results\
echo.
echo To run manually now: double-click monitor.bat
echo To cancel: search Task Scheduler, find keyword-monitor and delete it.
echo.
pause
