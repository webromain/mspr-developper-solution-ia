#!/bin/bash
# ============================================================================
# HealthAI Coach - Run ETL Pipeline (Linux/Mac)
# ============================================================================
# Lance le pipeline ETL complet
# ============================================================================

set -e

echo ""
echo "============================================================================"
echo "   HealthAI Coach - ETL Pipeline"
echo "============================================================================"
echo ""

# Vérifier fichiers CSV
echo "[1/3] Vérification fichiers CSV requis..."
if [ ! -f "daily_food_nutrition.csv" ]; then
    echo "❌ ERROR: daily_food_nutrition.csv not found"
    exit 1
fi
if [ ! -f "gym_members_exercise.csv" ]; then
    echo "❌ ERROR: gym_members_exercise.csv not found"
    exit 1
fi
if [ ! -f "diet_recommendations.csv" ]; then
    echo "❌ ERROR: diet_recommendations.csv not found"
    exit 1
fi
echo "✅ Tous les fichiers CSV trouvés"

# Activer venv
echo "[2/3] Activation Python environment..."
if [ ! -d ".venv" ]; then
    echo "❌ ERROR: .venv not found. Run ./scripts/setup.sh first"
    exit 1
fi
source .venv/bin/activate
echo "✅ Environnement Python activé"

# Lancer ETL
echo "[3/3] Lancement pipeline ETL..."
echo ""

python run_pipeline.py "$@"

echo ""
echo "============================================================================"
echo "   ✅ ETL Pipeline Complété!"
echo "============================================================================"
echo ""
echo "Rapport généré: reports/"
echo ""
