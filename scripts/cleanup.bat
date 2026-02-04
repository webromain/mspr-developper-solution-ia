@echo off
REM ============================================================================
REM HealthAI Coach - Cleanup Script (Windows)
REM ============================================================================
REM Nettoie le projet: caches, logs, build artifacts, etc.
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   HealthAI Coach - Cleanup
echo ============================================================================
echo.

set /p confirm="Êtes-vous sûr de vouloir nettoyer (y/n)? "
if /i not "%confirm%"=="y" (
    echo Opération annulée.
    exit /b 0
)

echo.
echo Suppression des fichiers temporaires...

REM Python caches
echo - Nettoyage Python caches...
for /d /r . %%d in (__pycache__) do @if exist "%%d" rd /s /q "%%d"
for /r . %%f in (*.pyc) do @if exist "%%f" del /q "%%f"
for /r . %%f in (.pytest_cache) do @if exist "%%f" rd /s /q "%%f"

REM Node caches
echo - Nettoyage Node caches...
if exist "frontend\node_modules\.cache" rd /s /q "frontend\node_modules\.cache" 2>nul
if exist "frontend\.vite" rd /s /q "frontend\.vite" 2>nul

REM Logs
echo - Nettoyage logs...
if exist "logs" rd /s /q "logs" 2>nul
for /r . %%f in (*.log) do @if exist "%%f" del /q "%%f" 2>nul

REM Reports temporaires
echo - Nettoyage reports...
if exist "reports" (
    for /f %%f in ('dir /b reports\etl_report_*.json ^| findstr /r "^etl_report_[0-9]*_[0-9]*\.json$"') do (
        del /q "reports\%%f" 2>nul
    )
)

REM Env files
echo - Nettoyage .env files...
if exist ".env.local" del /q ".env.local" 2>nul

REM IDE
echo - Nettoyage IDE caches...
if exist ".vscode\.settings" rd /s /q ".vscode\.settings" 2>nul
if exist ".idea" rd /s /q ".idea" 2>nul

REM Database files (careful!)
echo - Nettoyage database fichiers...
if exist "backend\db.sqlite3" del /q "backend\db.sqlite3" 2>nul
if exist "backend\db.sqlite3-journal" del /q "backend\db.sqlite3-journal" 2>nul

echo.
echo ============================================================================
echo   ✅ Cleanup Complete!
echo ============================================================================
echo.
echo Note: Fichiers supprimés:
echo   - __pycache__ directories
echo   - *.pyc files
echo   - Node caches
echo   - Logs
echo   - ETL reports temporaires
echo   - .env.local
echo   - SQLite database (dev only)
echo.
pause
