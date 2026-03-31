@echo off
chcp 65001 > nul 2>&1
echo.
echo 正在运行关键词监控...
echo.
node monitor.js
echo.
pause
