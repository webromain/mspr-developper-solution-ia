@echo off
REM ============================================================================
REM HealthAI Coach - Start Project Script (Windows)
REM ============================================================================
REM Démarre le projet avec Docker Compose (frontend + backend + databases)
REM Utilise venv pour backend seul si Docker n'est pas disponible
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   HealthAI Coach - Start Project
echo ============================================================================
echo.

REM Vérifier si Docker est disponible
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Docker not found. Utilisation du mode développement local...
    echo.
    goto START_LOCAL
)

echo 🐳 Lancement avec Docker Compose...
echo.

REM Démarrer les services Docker
docker-compose up -d

if errorlevel 1 (
    echo ❌ ERROR: Docker Compose failed
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo   ✅ Tous les services démarrés!
echo ============================================================================
echo.
echo 📍 Accès aux services:
echo    Frontend:    http://localhost:5173
echo    Backend API: http://localhost:8000/api
echo    Swagger UI:  http://localhost:8000/api/schema/swagger-ui/
echo    Admin Panel: http://localhost:8000/admin
echo.
echo 🗄️  Bases de données:
echo    PostgreSQL: localhost:5432
echo    MongoDB:    localhost:27017
echo    Redis:      localhost:6379
echo.
echo Logs:
echo    docker-compose logs -f                (tous les services)
echo    docker-compose logs -f backend        (backend seul)
echo    docker-compose logs -f frontend       (frontend seul)
echo.
echo Pour arrêter: docker-compose down
echo.
pause
exit /b 0

:START_LOCAL
echo.
echo 💻 Mode développement local (sans Docker)
echo.

REM Activer venv
if not exist ".venv" (
    echo ❌ ERROR: .venv not found. Run .\scripts\setup.bat first
    pause
    exit /b 1
)
call .venv\Scripts\activate.bat

REM Lancer backend
echo Démarrage Backend Django (http://localhost:8000)...
start "HealthAI Backend" cmd /k "cd backend && python manage.py runserver 0.0.0.0:8000"

REM Lancer frontend
echo Démarrage Frontend React (http://localhost:5173)...
start "HealthAI Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo ============================================================================
echo   ✅ Services démarrés en mode local!
echo ============================================================================
echo.
echo 📍 Accès aux services:
echo    Frontend:    http://localhost:5173
echo    Backend API: http://localhost:8000/api
echo    Admin Panel: http://localhost:8000/admin
echo.
echo Note: Bases de données non disponibles sans Docker
echo.
pause
