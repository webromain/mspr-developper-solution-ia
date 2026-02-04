# 🚀 Scripts - HealthAI Coach

Scripts automatisés pour setup, lancer et gérer le projet HealthAI Coach.

---

## 📋 Liste des scripts

### 1️⃣ Setup Initial (Premier lancement)

**Windows:**

```bash
.\scripts\setup.bat
```

**Linux/Mac:**

```bash
./scripts/setup.sh
```

**Actions:**

- ✅ Vérifie Python 3.11+, Node.js 18+
- ✅ Crée environnement Python (`venv`)
- ✅ Installe dépendances Python (`pip install`)
- ✅ Installe dépendances Node.js (`npm install`)
- ✅ Initialise base de données Django (`migrate`)
- ✅ Vérifiie Docker Compose

**Quand:** À la première utilisation du projet

---

### 2️⃣ Démarrer le projet (Mode normal)

**Windows:**

```bash
.\scripts\start.bat
```

**Linux/Mac:**

```bash
./scripts/start.sh
```

**Actions:**

- 🐳 Démarre Docker Compose (si disponible)
  - Frontend sur http://localhost:5173
  - Backend sur http://localhost:8000
  - PostgreSQL, MongoDB, Redis
- 💻 Sinon: démarre backend & frontend localement

**Quand:** À chaque développement (après setup)

---

### 3️⃣ Démarrer Backend seul

**Windows:**

```bash
.\scripts\start-backend.bat
```

**Linux/Mac:**

```bash
./scripts/start-backend.sh
```

**Actions:**

- 🐳 Lance Django backend + databases (si Docker)
- 📍 Backend sur http://localhost:8000/api

**Quand:** Pour tester backend indépendamment du frontend

---

### 4️⃣ Démarrer Frontend seul

**Windows:**

```bash
.\scripts\start-frontend.bat
```

**Linux/Mac:**

```bash
./scripts/start-frontend.sh
```

**Actions:**

- 📦 Lance React Vite dev server
- 📍 Frontend sur http://localhost:5173

**Quand:** Pour tester frontend indépendamment du backend

---

### 5️⃣ Lancer ETL Pipeline

**Windows:**

```bash
.\scripts\run-etl.bat
```

**Linux/Mac:**

```bash
./scripts/run-etl.sh
```

**Actions:**

- 🔄 Vérifie CSV requis (daily_food_nutrition.csv, gym_members_exercise.csv, diet_recommendations.csv)
- 📊 Lance pipeline 6-étapes
- 📝 Génère rapport JSON dans `reports/`

**Quand:** Pour charger/actualiser données

**Paramètres:**

```bash
.\scripts\run-etl.bat --data-dir ./data --output-dir ./reports
```

---

### 6️⃣ Nettoyer le projet

**Windows:**

```bash
.\scripts\cleanup.bat
```

**Linux/Mac:**

```bash
./scripts/cleanup.sh
```

**Actions:**

- 🗑️ Supprime caches Python (`__pycache__`, `*.pyc`)
- 🗑️ Supprime caches Node.js (`.vite`, `node_modules/.cache`)
- 🗑️ Supprime logs
- 🗑️ Supprime db.sqlite3 (dev)
- 🗑️ Supprime .env.local

**Quand:** Pour nettoyer avant un commit ou après problèmes

---

## 🔄 Workflows typiques

### Premier lancement (First time)

```bash
# Windows
.\scripts\setup.bat
.\scripts\start.bat

# Linux/Mac
./scripts/setup.sh
./scripts/start.sh
```

Puis accéder à:

- Frontend: http://localhost:5173
- Backend: http://localhost:8000/api
- Admin: http://localhost:8000/admin

### Développement normal

```bash
# Windows
.\scripts\start.bat

# Linux/Mac
./scripts/start.sh
```

### Tester backend seul

```bash
# Windows
.\scripts\start-backend.bat
# Autres terminal:
.\scripts\start-frontend.bat

# Linux/Mac
./scripts/start-backend.sh &
./scripts/start-frontend.sh
```

### Charger nouvelles données

```bash
# Ajouter CSV dans racine
# Puis lancer ETL

# Windows
.\scripts\run-etl.bat

# Linux/Mac
./scripts/run-etl.sh
```

### Nettoyer et recommencer

```bash
# Windows
.\scripts\cleanup.bat
.\scripts\setup.bat
.\scripts\start.bat

# Linux/Mac
./scripts/cleanup.sh
./scripts/setup.sh
./scripts/start.sh
```

---

## 🔧 Prérequis

Avant d'utiliser les scripts, installer:

### Windows

- Python 3.11+ (https://www.python.org/)
- Node.js 18+ (https://nodejs.org/)
- Docker Desktop (recommandé) (https://www.docker.com/)

### Linux/Mac

```bash
# Ubuntu/Debian
sudo apt-get install python3.11 python3-venv nodejs npm

# macOS (with Homebrew)
brew install python node
brew install --cask docker
```

---

## 📍 Accès aux services

Après démarrage (`start.bat` ou `start.sh`):

| Service     | URL                                          | Notes           |
| ----------- | -------------------------------------------- | --------------- |
| Frontend    | http://localhost:5173                        | React Vite dev  |
| Backend API | http://localhost:8000/api                    | Django REST     |
| Swagger API | http://localhost:8000/api/schema/swagger-ui/ | OpenAPI docs    |
| Admin Panel | http://localhost:8000/admin                  | Django admin    |
| PostgreSQL  | localhost:5432                               | user: postgres  |
| MongoDB     | localhost:27017                              | No auth (local) |
| Redis       | localhost:6379                               | No auth (local) |

---

## 🆘 Troubleshooting

### Python not found

```bash
# Windows - Ajouter Python au PATH ou:
python --version

# Si erreur, installer depuis:
# https://www.python.org/downloads/
```

### Node not found

```bash
# Installer Node.js:
# https://nodejs.org/
```

### Docker not found

```bash
# Scripts fonctionnent sans Docker (mode local)
# Mais databases ne seront pas disponibles

# Installer Docker:
# https://www.docker.com/products/docker-desktop
```

### Port déjà en utilisation

```bash
# Frontend (5173)
npm run dev -- --port 3000

# Backend (8000)
python manage.py runserver 8001
```

### Permission denied (Linux/Mac)

```bash
# Rendre scripts exécutables:
chmod +x scripts/*.sh
```

### ETL échoue

```bash
# Vérifier CSV présents:
ls -la *.csv

# Vérifier chemin:
.\scripts\run-etl.bat --verbose
```

---

## 📚 Documentation

Pour plus d'infos:

- 📖 [README principal](../README.md)
- 📋 [INDEX documentation](../doc/INDEX.md)
- 🏗️ [Architecture](../doc/mspr1/MSPR1_Architecture.md)
- 🔄 [ETL Pipeline](../doc/mspr1/MSPR1_ETL_Pipeline.md)

---

## 💡 Quick Reference

```bash
# Setup + Start (first time)
.\scripts\setup.bat && .\scripts\start.bat

# Start only
.\scripts\start.bat

# Backend + Frontend separately
.\scripts\start-backend.bat  # Terminal 1
.\scripts\start-frontend.bat # Terminal 2

# Run ETL
.\scripts\run-etl.bat

# Clean
.\scripts\cleanup.bat
```

---

**Pour aide:** Consulter [doc/INDEX.md](../doc/INDEX.md) pour documentation complète.
