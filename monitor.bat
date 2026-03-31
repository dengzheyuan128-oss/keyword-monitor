@echo off
cd /d "%~dp0"

set DATE=%date:~0,4%%date:~5,2%%date:~8,2%
set OUTFILE=%~dp0results\%DATE%.txt

if not exist "%~dp0results" mkdir "%~dp0results"

echo ==========================================  >> "%OUTFILE%"
echo   keyword-monitor results %DATE%           >> "%OUTFILE%"
echo ==========================================  >> "%OUTFILE%"
echo.                                           >> "%OUTFILE%"

set KEYWORDS=AI Agent AI ??? Claude

for %%K in (%KEYWORDS%) do (
    echo [zhihu] %%K >> "%OUTFILE%"
    opencli zhihu search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [weibo] %%K >> "%OUTFILE%"
    opencli weibo search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [xiaohongshu] %%K >> "%OUTFILE%"
    opencli xiaohongshu search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [twitter] %%K >> "%OUTFILE%"
    opencli twitter search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [reddit] %%K >> "%OUTFILE%"
    opencli reddit search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [hackernews] %%K >> "%OUTFILE%"
    opencli hackernews search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [bilibili] %%K >> "%OUTFILE%"
    opencli bilibili search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"

    echo [github] %%K >> "%OUTFILE%"
    opencli github search "%%K" -f md >> "%OUTFILE%" 2>&1
    echo. >> "%OUTFILE%"
)

echo Done. Results saved to %OUTFILE%
