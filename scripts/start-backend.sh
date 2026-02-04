#!/bin/bash
# ============================================================================
# HealthAI Coach - Start Backend Only (Linux/Mac)
# ============================================================================
# Démarre le serveur Django backend seul (http://localhost:8000)
# ============================================================================

echo ""
echo "============================================================================"
echo "   HealthAI Coach - Backend Server"
echo "============================================================================"
echo ""

# Vérifier si Docker est disponible
if ! command -v docker-compose &> /dev/null; then
    echo "💻 Utilisation du mode développement local..."
    echo ""

    # Vérifier venv
    if [ ! -d ".venv" ]; then
        echo "❌ ERROR: .venv not found. Run ./scripts/setup.sh first"
        exit 1
    fi
    source .venv/bin/activate

    # Lancer backend
    cd backend
    echo "Démarrage Django sur http://localhost:8000"
    echo ""
    python manage.py runserver 0.0.0.0:8000
else
    echo "🐳 Lancement Backend avec Docker..."
    echo ""

    docker-compose up -d postgres mongo redis backend

    echo ""
    echo "============================================================================"
    echo "   ✅ Backend démarré!"
    echo "============================================================================"
    echo ""
    echo "📍 Backend API: http://localhost:8000/api"
    echo "   Swagger UI:  http://localhost:8000/api/schema/swagger-ui/"
    echo "   Admin Panel: http://localhost:8000/admin"
    echo ""
    echo "Logs: docker-compose logs -f backend"
    echo ""
fi
