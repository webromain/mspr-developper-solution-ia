#!/bin/bash
# ============================================================================
# HealthAI Coach - Start Project Script (Linux/Mac)
# ============================================================================
# Démarre le projet avec Docker Compose (frontend + backend + databases)
# Utilise venv pour backend seul si Docker n'est pas disponible
# ============================================================================

set -e

echo ""
echo "============================================================================"
echo "   HealthAI Coach - Start Project"
echo "============================================================================"
echo ""

# Vérifier si Docker est disponible
if ! command -v docker-compose &> /dev/null; then
    echo "⚠️  Docker not found. Utilisation du mode développement local..."
    echo ""
    goto_local=true
else
    goto_local=false
fi

if [ "$goto_local" = false ]; then
    echo "🐳 Lancement avec Docker Compose..."
    echo ""

    # Démarrer les services Docker
    docker-compose up -d

    echo ""
    echo "============================================================================"
    echo "   ✅ Tous les services démarrés!"
    echo "============================================================================"
    echo ""
    echo "📍 Accès aux services:"
    echo "   Frontend:    http://localhost:5173"
    echo "   Backend API: http://localhost:8000/api"
    echo "   Swagger UI:  http://localhost:8000/api/schema/swagger-ui/"
    echo "   Admin Panel: http://localhost:8000/admin"
    echo ""
    echo "🗄️  Bases de données:"
    echo "   PostgreSQL: localhost:5432"
    echo "   MongoDB:    localhost:27017"
    echo "   Redis:      localhost:6379"
    echo ""
    echo "Logs:"
    echo "   docker-compose logs -f                (tous les services)"
    echo "   docker-compose logs -f backend        (backend seul)"
    echo "   docker-compose logs -f frontend       (frontend seul)"
    echo ""
    echo "Pour arrêter: docker-compose down"
    echo ""
else
    echo ""
    echo "💻 Mode développement local (sans Docker)"
    echo ""

    # Vérifier venv
    if [ ! -d ".venv" ]; then
        echo "❌ ERROR: .venv not found. Run ./scripts/setup.sh first"
        exit 1
    fi
    source .venv/bin/activate

    # Lancer backend
    echo "Démarrage Backend Django (http://localhost:8000)..."
    (cd backend && python manage.py runserver 0.0.0.0:8000) &
    BACKEND_PID=$!

    # Lancer frontend
    echo "Démarrage Frontend React (http://localhost:5173)..."
    (cd frontend && npm run dev) &
    FRONTEND_PID=$!

    echo ""
    echo "============================================================================"
    echo "   ✅ Services démarrés en mode local!"
    echo "============================================================================"
    echo ""
    echo "📍 Accès aux services:"
    echo "   Frontend:    http://localhost:5173"
    echo "   Backend API: http://localhost:8000/api"
    echo "   Admin Panel: http://localhost:8000/admin"
    echo ""
    echo "Note: Bases de données non disponibles sans Docker"
    echo ""
    echo "Pour arrêter: Ctrl+C ou kill $BACKEND_PID && kill $FRONTEND_PID"
    echo ""

    # Attendre Ctrl+C
    wait
fi
