@echo off
REM Sets the title of the command prompt window
TITLE Next.js Dev

echo Checking dependencies...

echo Terminating any previous Next.js processes...
REM Kill any running Node.js processes (which includes next dev). Errors will be shown below.
taskkill /f /im node.exe
echo Done attempting termination.

echo Checking dependencies...

@REM REM Check for Node.js
@REM where node > nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo Error: Node.js is not installed or not found in PATH. Please install Node.js.
@REM     echo Error: pnpm is not installed or not found in PATH. Please install pnpm.
@REM     pause
@REM     exit /b 1
@REM ) else (
@REM     echo Node.js found.
@REM     echo pnpm found.
@REM )

@REM REM Check for pnpm
@REM where pnpm > nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo Error: pnpm is not installed or not found in PATH. Please install pnpm (e.g., using 'npm install -g pnpm').
@REM     pause
@REM     exit /b 1
@REM ) else (
@REM     echo pnpm found.
@REM )

REM Check if node_modules exists, run pnpm install if not
if not exist "node_modules" (
    echo node_modules directory not found. Running pnpm install...
    call pnpm install
    if %errorlevel% neq 0 (
        echo Error running pnpm install. Please check for errors.
        pause
        exit /b 1
    )
    echo pnpm install completed.
) else (
    echo node_modules directory found. Skipping pnpm install.
)

echo.
echo ========================================
echo Starting development environment...
echo ========================================
echo.

echo [1/3] Starting Next.js development server in a new window...
REM Starts pnpm run dev in a new command prompt window.
start "Next.js Dev Server" cmd /c pnpm run dev

echo [2/3] Waiting for server to initialize...
REM Waits for 8 seconds without user interruption to allow the server to start
timeout /t 8 /nobreak > nul

echo [3/3] Opening development site in browser...
REM Try to find Brave in common installation locations
set "BRAVE_PATH=%PROGRAMFILES%\BraveSoftware\Brave-Browser\Application\brave.exe"
if not exist "%BRAVE_PATH%" set "BRAVE_PATH=%PROGRAMFILES(X86)%\BraveSoftware\Brave-Browser\Application\brave.exe"
if not exist "%BRAVE_PATH%" set "BRAVE_PATH=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"

REM Try to find Chrome in common installation locations
set "CHROME_PATH=%PROGRAMFILES%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_PATH%" set "CHROME_PATH=%PROGRAMFILES(X86)%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_PATH%" set "CHROME_PATH=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"

REM Try to find Edge in common installation locations
set "EDGE_PATH=%PROGRAMFILES(X86)%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE_PATH%" set "EDGE_PATH=%PROGRAMFILES%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE_PATH%" set "EDGE_PATH=%LOCALAPPDATA%\Microsoft\Edge\Application\msedge.exe"

if exist "%BRAVE_PATH%" (
    echo       Opening in Brave app mode...
    start "" "%BRAVE_PATH%" --app=http://localhost:5173/ --app-icon="%CD%\public\GeminiCoder.ico"
) else if exist "%CHROME_PATH%" (
    echo       Opening in Chrome app mode...
    start "" "%CHROME_PATH%" --app=http://localhost:5173/ --app-icon="%CD%\public\GeminiCoder.ico"
) else if exist "%EDGE_PATH%" (
    echo       Opening in Edge app mode...
    start "" "%EDGE_PATH%" --app=http://localhost:5173/ --app-icon="%CD%\public\GeminiCoder.ico"
) else (
    echo       No supported browsers found. Opening in your default browser...
    echo       Note: For a better development experience, consider installing Brave, Chrome, or Edge
    echo       to use the app mode feature.
    start http://localhost:5173/
)

echo.
echo ========================================
echo Development Environment Ready!
echo ========================================
echo.
echo Local Development URL: http://localhost:5173/
echo.
echo Tips:
echo - Use http://localhost:5173/ for local development
echo - Close the "Next.js Dev Server" window to stop the server
echo.

echo Script finished. The development server is running in a separate window.
REM The main script execution ends here. The server continues running in the background tab.
