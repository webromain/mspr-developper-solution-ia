@echo off
REM ============================================================================
REM HealthAI Coach - Start Backend Only (Windows)
REM ============================================================================
REM Démarre le serveur Django backend seul (http://localhost:8000)
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   HealthAI Coach - Backend Server
echo ============================================================================
echo.

REM Vérifier si Docker est disponible
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo 💻 Utilisation du mode développement local...
    goto START_LOCAL
)

echo 🐳 Lancement Backend avec Docker...
echo.

docker-compose up -d postgres mongo redis backend

if errorlevel 1 (
    echo ❌ ERROR: Docker Compose failed
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo   ✅ Backend démarré!
echo ============================================================================
echo.
echo 📍 Backend API: http://localhost:8000/api
echo    Swagger UI:  http://localhost:8000/api/schema/swagger-ui/
echo    Admin Panel: http://localhost:8000/admin
echo.
echo Logs: docker-compose logs -f backend
echo.
pause
exit /b 0

:START_LOCAL
echo.

REM Activer venv
if not exist ".venv" (
    echo ❌ ERROR: .venv not found. Run .\scripts\setup.bat first
    pause
    exit /b 1
)
call .venv\Scripts\activate.bat

REM Lancer backend
cd backend
echo Démarrage Django sur http://localhost:8000
echo.
python manage.py runserver 0.0.0.0:8000

pause
