#!/bin/bash
# ============================================================================
# HealthAI Coach - Cleanup Script (Linux/Mac)
# ============================================================================
# Nettoie le projet: caches, logs, build artifacts, etc.
# ============================================================================

echo ""
echo "============================================================================"
echo "   HealthAI Coach - Cleanup"
echo "============================================================================"
echo ""

read -p "Êtes-vous sûr de vouloir nettoyer (y/n)? " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Opération annulée."
    exit 0
fi

echo ""
echo "Suppression des fichiers temporaires..."

# Python caches
echo "- Nettoyage Python caches..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true

# Node caches
echo "- Nettoyage Node caches..."
rm -rf frontend/node_modules/.cache 2>/dev/null || true
rm -rf frontend/.vite 2>/dev/null || true

# Logs
echo "- Nettoyage logs..."
rm -rf logs 2>/dev/null || true
find . -type f -name "*.log" -delete 2>/dev/null || true

# Reports temporaires
echo "- Nettoyage reports..."
rm -f reports/etl_report_*.json 2>/dev/null || true

# Env files
echo "- Nettoyage .env files..."
rm -f .env.local 2>/dev/null || true

# IDE
echo "- Nettoyage IDE caches..."
rm -rf .vscode/.settings 2>/dev/null || true
rm -rf .idea 2>/dev/null || true

# Database files (careful!)
echo "- Nettoyage database fichiers..."
rm -f backend/db.sqlite3 2>/dev/null || true
rm -f backend/db.sqlite3-journal 2>/dev/null || true

echo ""
echo "============================================================================"
echo "   ✅ Cleanup Complete!"
echo "============================================================================"
echo ""
echo "Note: Fichiers supprimés:"
echo "   - __pycache__ directories"
echo "   - *.pyc files"
echo "   - Node caches"
echo "   - Logs"
echo "   - ETL reports temporaires"
echo "   - .env.local"
echo "   - SQLite database (dev only)"
echo ""
