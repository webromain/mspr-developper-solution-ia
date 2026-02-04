@echo off
REM ============================================================================
REM HealthAI Coach - Start Frontend Only (Windows)
REM ============================================================================
REM Démarre le serveur React Vite seul (http://localhost:5173)
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   HealthAI Coach - Frontend Server
echo ============================================================================
echo.

REM Vérifier Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Node.js not found. Please install Node.js 18+
    echo    https://nodejs.org/
    pause
    exit /b 1
)

echo 📦 Starting React development server...
echo.

cd frontend

REM Vérifier node_modules
if not exist "node_modules" (
    echo Installing npm dependencies...
    call npm install
    if errorlevel 1 (
        echo ❌ ERROR: npm install failed
        pause
        exit /b 1
    )
)

echo Starting Vite dev server (http://localhost:5173)
echo.

call npm run dev

pause
