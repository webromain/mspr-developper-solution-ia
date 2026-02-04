#!/bin/bash
# ============================================================================
# HealthAI Coach - Start Frontend Only (Linux/Mac)
# ============================================================================
# Démarre le serveur React Vite seul (http://localhost:5173)
# ============================================================================

echo ""
echo "============================================================================"
echo "   HealthAI Coach - Frontend Server"
echo "============================================================================"
echo ""

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo "❌ ERROR: Node.js not found. Please install Node.js 18+"
    echo "   https://nodejs.org/"
    exit 1
fi

echo "📦 Starting React development server..."
echo ""

cd frontend

# Vérifier node_modules
if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install
fi

echo "Starting Vite dev server (http://localhost:5173)"
echo ""

npm run dev
