#!/bin/bash
# ============================================================================
# HealthAI Coach - Setup Initial Script (Linux/Mac)
# ============================================================================
# Ce script configure le projet pour la première fois:
# 1. Crée l'environnement Python
# 2. Installe les dépendances Python
# 3. Installe les dépendances Node.js
# 4. Initialise la base de données
# 5. Lance Docker Compose
# ============================================================================

set -e  # Exit on error

echo ""
echo "============================================================================"
echo "   HealthAI Coach - Setup Initial"
echo "============================================================================"
echo ""

# Vérifier Python
echo "[1/7] Vérification Python..."
if ! command -v python3 &> /dev/null; then
    echo "❌ ERROR: Python 3 not found. Please install Python 3.11+"
    echo "   https://www.python.org/downloads/"
    exit 1
fi
echo "✅ Python found: $(python3 --version)"

# Vérifier Node.js
echo "[2/7] Vérification Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ ERROR: Node.js not found. Please install Node.js 18+"
    echo "   https://nodejs.org/"
    exit 1
fi
echo "✅ Node.js found: $(node --version)"

# Créer venv Python
echo "[3/7] Création environnement Python..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate
echo "✅ Python venv créé et activé"

# Installer dépendances Python
echo "[4/7] Installation dépendances Python..."
pip install --upgrade pip setuptools wheel > /dev/null 2>&1
pip install -r requirements.txt
echo "✅ Dépendances Python installées"

# Installer dépendances Node.js
echo "[5/7] Installation dépendances Node.js..."
cd frontend
npm install
cd ..
echo "✅ Dépendances Node.js installées"

# Initialiser base de données Django
echo "[6/7] Initialisation base de données Django..."
cd backend
python manage.py migrate
python manage.py collectstatic --noinput > /dev/null 2>&1
cd ..
echo "✅ Base de données initialisée"

# Vérifier Docker
echo "[7/7] Vérification Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    echo "⚠️  WARNING: Docker not found. Some services may not work offline."
    echo "   Install Docker from: https://www.docker.com/products/docker-desktop"
else
    echo "✅ Docker Compose trouvé: $(docker-compose --version)"
fi

echo ""
echo "============================================================================"
echo "   ✅ Setup Complete!"
echo "============================================================================"
echo ""
echo "Prochaines étapes:"
echo "  1. Lancer le projet:  ./scripts/start.sh"
echo "  2. Frontend:          http://localhost:5173"
echo "  3. Backend:           http://localhost:8000/api"
echo "  4. Admin:             http://localhost:8000/admin"
echo ""
echo "Docs: Consulter doc/INDEX.md pour navigation complète"
echo ""
