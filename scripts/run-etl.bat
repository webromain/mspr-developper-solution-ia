@echo off
REM ============================================================================
REM HealthAI Coach - Run ETL Pipeline (Windows)
REM ============================================================================
REM Lance le pipeline ETL complet
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   HealthAI Coach - ETL Pipeline
echo ============================================================================
echo.

REM Vérifier fichiers CSV
echo [1/3] Vérification fichiers CSV requis...
if not exist "daily_food_nutrition.csv" (
    echo ❌ ERROR: daily_food_nutrition.csv not found
    pause
    exit /b 1
)
if not exist "gym_members_exercise.csv" (
    echo ❌ ERROR: gym_members_exercise.csv not found
    pause
    exit /b 1
)
if not exist "diet_recommendations.csv" (
    echo ❌ ERROR: diet_recommendations.csv not found
    pause
    exit /b 1
)
echo ✅ Tous les fichiers CSV trouvés

REM Activer venv
echo [2/3] Activation Python environment...
if not exist ".venv" (
    echo ❌ ERROR: .venv not found. Run .\scripts\setup.bat first
    pause
    exit /b 1
)
call .venv\Scripts\activate.bat
echo ✅ Environnement Python activé

REM Lancer ETL
echo [3/3] Lancement pipeline ETL...
echo.

python run_pipeline.py %*

if errorlevel 1 (
    echo.
    echo ❌ ERROR: ETL pipeline failed
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo   ✅ ETL Pipeline Complété!
echo ============================================================================
echo.
echo Rapport généré: reports\
echo.
pause
