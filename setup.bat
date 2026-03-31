@echo off

echo.
echo ===================================
echo   keyword-monitor setup
echo ===================================
echo.

echo Checking Node.js...
node -v > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found.
    echo Please install Node.js 20+ from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)
echo [OK] Node.js found

echo.
echo Installing opencli...
npm list -g @jackwener/opencli > nul 2>&1
if %errorlevel% neq 0 (
    npm install -g @jackwener/opencli
) else (
    echo [OK] opencli already installed, skipping
)

echo.
echo Installing project dependencies...
npm install
echo [OK] Done

echo.
echo ===================================
echo   Setup complete!
echo ===================================
echo.
echo Next steps:
echo   1. Open config.js with Notepad, fill in your email and keywords
echo   2. Double-click install-extension.bat
echo   3. Double-click test.bat to run a test
echo   4. Double-click setup-task.bat to schedule daily runs
echo.
pause
