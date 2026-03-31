@echo off

echo.
echo ===================================
echo   Download opencli Chrome extension
echo ===================================
echo.

set INSTALL_DIR=%USERPROFILE%\.opencli-extension
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo Downloading extension...
powershell -Command "& { $rel = Invoke-RestMethod 'https://api.github.com/repos/jackwener/opencli/releases/latest'; $url = ($rel.assets | Where-Object { $_.name -like '*extension*' }).browser_download_url; Invoke-WebRequest -Uri $url -OutFile '%INSTALL_DIR%\opencli-extension.zip' }"

if %errorlevel% neq 0 (
    echo [ERROR] Download failed.
    echo Please manually download opencli-extension.zip from:
    echo https://github.com/jackwener/opencli/releases
    pause
    exit /b 1
)

echo Extracting...
powershell -Command "Expand-Archive -Path '%INSTALL_DIR%\opencli-extension.zip' -DestinationPath '%INSTALL_DIR%\extension' -Force"
del "%INSTALL_DIR%\opencli-extension.zip"
echo [OK] Done

echo.
echo ===================================
echo   Now load the extension in Chrome
echo ===================================
echo.
echo 1. Open Chrome, go to: chrome://extensions
echo 2. Enable Developer mode (top right)
echo 3. Click "Load unpacked", select this folder:
echo    %INSTALL_DIR%\extension
echo 4. Extension installed successfully
echo.
echo After installing, run in terminal: opencli doctor
echo You should see: Connected
echo.

explorer "%INSTALL_DIR%\extension"
pause
