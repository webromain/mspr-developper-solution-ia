@echo off
REM ============================================================================
REM HealthAI Coach - Setup Initial Script (Windows)
REM ============================================================================
REM Ce script configure le projet pour la première fois:
REM 1. Crée l'environnement Python
REM 2. Installe les dépendances Python
REM 3. Installe les dépendances Node.js
REM 4. Initialise la base de données
REM 5. Lance Docker Compose
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   HealthAI Coach - Setup Initial
echo ============================================================================
echo.

REM Vérifier Python
echo [1/7] Vérification Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Python not found. Please install Python 3.11+
    echo    https://www.python.org/downloads/
    pause
    exit /b 1
)
echo ✅ Python found

REM Vérifier Node.js
echo [2/7] Vérification Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Node.js not found. Please install Node.js 18+
    echo    https://nodejs.org/
    pause
    exit /b 1
)
echo ✅ Node.js found

REM Créer venv Python
echo [3/7] Création environnement Python...
if not exist ".venv" (
    python -m venv .venv
    if errorlevel 1 (
        echo ❌ ERROR: Failed to create venv
        pause
        exit /b 1
    )
)
call .venv\Scripts\activate.bat
echo ✅ Python venv créé et activé

REM Installer dépendances Python
echo [4/7] Installation dépendances Python...
pip install --upgrade pip setuptools wheel >nul 2>&1
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ ERROR: Failed to install Python dependencies
    pause
    exit /b 1
)
echo ✅ Dépendances Python installées

REM Installer dépendances Node.js
echo [5/7] Installation dépendances Node.js...
cd frontend
call npm install
if errorlevel 1 (
    echo ❌ ERROR: Failed to install Node.js dependencies
    cd ..
    pause
    exit /b 1
)
cd ..
echo ✅ Dépendances Node.js installées

REM Initialiser base de données Django
echo [6/7] Initialisation base de données Django...
cd backend
call ..\..\.venv\Scripts\activate.bat
python manage.py migrate
if errorlevel 1 (
    echo ❌ ERROR: Database migration failed
    cd ..
    pause
    exit /b 1
)
python manage.py collectstatic --noinput >nul 2>&1
cd ..
echo ✅ Base de données initialisée

REM Vérifier Docker
echo [7/7] Vérification Docker Compose...
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  WARNING: Docker not found. Some services may not work offline.
    echo    Install Docker from: https://www.docker.com/products/docker-desktop
    echo.
) else (
    echo ✅ Docker Compose trouvé
)

echo.
echo ============================================================================
echo   ✅ Setup Complete!
echo ============================================================================
echo.
echo Prochaines étapes:
echo   1. Lancer le projet: .\scripts\start.bat
echo   2. Frontend:  http://localhost:5173
echo   3. Backend:   http://localhost:8000/api
echo   4. Admin:     http://localhost:8000/admin
echo.
echo Docs: Consulter doc/INDEX.md pour navigation complète
echo.
pause
