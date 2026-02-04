# 🏥 HealthAI Coach - Platform IA de Recommandations Santé

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Status](https://img.shields.io/badge/status-MSPR%201%20%26%202%20Documentation%20Ready-brightgreen)
![Python](https://img.shields.io/badge/python-3.11+-blue)
![Node.js](https://img.shields.io/badge/node-18+-green)
![License](https://img.shields.io/badge/license-MIT-orange)

HealthAI Coach est une plateforme web intelligente de suivi santé et recommandations personnalisées basée sur l'IA. Le projet est structuré en deux phases (MSPR 1 & 2) avec des livrables progressifs.

---

## 📋 Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Structure du projet](#structure-du-projet)
- [Setup rapide](#setup-rapide)
- [Lancer l'ETL](#lancer-letl)
- [Stack technologique](#stack-technologique)
- [Documentation complète](#documentation-complète)
- [Architecture](#architecture)
- [Développement](#développement)
- [Déploiement](#déploiement)
- [Support & Contribution](#support--contribution)

---

## 👀 Vue d'ensemble

### Phase 1 - MSPR 1 (Semaines 1-2)

✅ **Status: 85% Complet**

- 📊 Tableau de bord santé avec visualisations
- 🔄 Pipeline ETL robuste (6 étapes)
- 🏋️ Suivi activité physique & nutrition
- 👥 Gestion patients avec métriques KPI
- 🔐 API REST sécurisée (OpenAPI)
- ♿ Conformité WCAG 2.1 AA

**Données:** 50k patients | Metrics: BMI, cholestérol, glucose, adhésion régime

### Phase 2 - MSPR 2 (Semaines 3-7)

⏳ **Status: Documentation & Architecture Prête**

- 🤖 Micro-service IA avec recommandations
- 📸 Vision IA pour analyse repas
- 💪 Recommandations workout personnalisées
- 🧠 Prédictions trajectoire santé
- 🎯 Accessibilité WCAG AAA
- 📈 Advanced analytics & ML

---

## 📁 Structure du projet

```
mspr-developper-solution-ia/
│
├── 📄 README.md                          ← Vous êtes ici
├── 📄 requirements.txt                   ← Dépendances Python
├── 📄 docker-compose.yml                 ← Stack locale (6 services)
│
├── 🗂️ doc/                               ← 📍 DOCUMENTATION COMPLÈTE
│   ├── INDEX.md                          ← Point d'entrée navigation
│   ├── SUMMARY.md                        ← Résumé exécutif
│   ├── DOCUMENTATION_RECAP.md            ← Récapitulatif création
│   ├── mspr1/
│   │   ├── MSPR1_Architecture.md         (3-layers, 5 ViewSets, ETL pipeline)
│   │   ├── MSPR1_DataModel.md            (ER diagram, 5 tables SQL)
│   │   ├── MSPR1_ETL_Pipeline.md         (6 étapes + code examples)
│   │   └── MSPR1_Technical_Stack.md      (Dependencies, Docker, AWS, CI/CD)
│   ├── mspr2/
│   │   ├── MSPR2_Architecture.md         (Micro-service IA, recommandations)
│   │   └── MSPR2_DataModel_NoSQL.md      (MongoDB collections)
│   ├── api-specs/
│   │   └── MSPR1_API_OpenAPI.yaml        (30+ endpoints, Swagger)
│   ├── guides/
│   │   ├── WCAG_RGAA_Accessibility.md    (Standards WCAG AA/AAA)
│   │   ├── Frontend_Benchmarks.md        (Tech choices justification)
│   │   └── Change_Management.md          (À venir MSPR 2)
│   └── schemas/                          (Diagrammes Mermaid/SVG)
│
├── 🗂️ backend/
│   ├── manage.py
│   ├── requirements.txt
│   ├── config/                           (Django settings, urls, wsgi)
│   ├── api/                              (Models, ViewSets, Serializers)
│   └── migrations/
│
├── 🗂️ frontend/
│   ├── package.json
│   ├── src/
│   │   ├── pages/                        (Dashboard, Analytics, etc.)
│   │   ├── components/                   (Charts, StatCard, etc.)
│   │   ├── services/
│   │   │   └── api.js                    (Axios client)
│   │   └── styles/
│   ├── vite.config.js
│   └── public/
│
├── 🗂️ Pipelines/
│   ├── __init__.py
│   ├── pipeline.py                       (Orchestration ETL)
│   ├── transformers.py                   (Transformation logic)
│   ├── validators.py                     (Validation rules)
│   ├── metrics.py                        (KPI calculations)
│   └── rules.py                          (Business rules)
│
├── 📊 Data CSV sources (input)
│   ├── daily_food_nutrition.csv
│   ├── gym_members_exercise.csv
│   └── diet_recommendations.csv
│
├── 📊 reports/                           (Rapports ETL JSON)
│
├── 🗂️ BDD.sql                            (SQL script database init)
│
└── 📄 run_pipeline.py                    (Script launcher ETL)
```

### Accès rapide documentation par rôle

| Rôle                           | Point d'entrée                                                                  | Fichiers clés                            |
| ------------------------------ | ------------------------------------------------------------------------------- | ---------------------------------------- |
| 👨‍💼 **PO / Stakeholder**        | [SUMMARY.md](doc/SUMMARY.md)                                                    | Business case, metrics, ROI              |
| 👨‍💻 **Frontend Developer**      | [INDEX.md](doc/INDEX.md#frontend)                                               | Tech_Stack, Benchmarks, Accessibility    |
| 🧑‍💻 **Backend Developer**       | [INDEX.md](doc/INDEX.md#backend)                                                | Architecture, DataModel, API OpenAPI     |
| 📊 **Data Engineer**           | [INDEX.md](doc/INDEX.md#data)                                                   | ETL_Pipeline, DataModel, Technical_Stack |
| 🤖 **Data Scientist (MSPR 2)** | [MSPR2_Architecture.md](doc/mspr2/MSPR2_Architecture.md)                        | ML pipelines, models, recommendations    |
| 🚀 **DevOps / Infra**          | [Technical_Stack.md](doc/mspr1/MSPR1_Technical_Stack.md#déploiement-production) | Docker, AWS, CI/CD, Terraform            |
| ♿ **Accessibility Lead**      | [WCAG_RGAA_Accessibility.md](doc/guides/WCAG_RGAA_Accessibility.md)             | Standards, checklists, testing           |

---

## 🚀 Setup rapide

### Prérequis

- **Python 3.11+**
- **Node.js 18+** & npm
- **Docker & Docker Compose** (recommandé)
- **Git**

### Installation locale (option 1: Python seul)

```bash
# 1. Clone repo
git clone https://github.com/healthai-coach/mspr-develop.git
cd mspr-developper-solution-ia

# 2. Python venv setup
python3 -m venv .venv
source .venv/bin/activate  # Linux/Mac
# ou
.venv\Scripts\activate     # Windows

# 3. Install dependencies
pip install -r requirements.txt

# 4. Vérifier installation
python -c "import pandas, django; print('✅ Dependencies OK')"
```

### Installation avec Docker (option 2: Recommandé)

```bash
# 1. Clone repo
git clone https://github.com/healthai-coach/mspr-develop.git
cd mspr-developper-solution-ia

# 2. Lancer stack complète (frontend, backend, databases, redis)
docker-compose up -d

# 3. Vérifier services
docker-compose ps

# 4. Accès services
# Frontend:     http://localhost:5173
# Backend API:  http://localhost:8000/api
# Swagger API:  http://localhost:8000/api/docs
# PostgreSQL:   localhost:5432
# MongoDB:      localhost:27017
# Redis:        localhost:6379
```

---

## 🔄 Lancer l'ETL

### Pipeline ETL 6 étapes

Le pipeline charge, nettoie, valide et transforme 3 fichiers CSV dans la base de données.

```
Extraction → Nettoyage → Validation → Transformation → Chargement DB → Rapport JSON
```

### Exécution

#### Option 1: Script Python simple

```bash
# À partir du répertoire racine
python run_pipeline.py

# Ou avec arguments
python run_pipeline.py --data-dir ./data --output-dir ./reports
```

#### Option 2: Depuis Docker

```bash
# Exécuter dans conteneur backend
docker-compose exec backend python run_pipeline.py
```

#### Option 3: Depuis le module Pipelines

```bash
# Mode développement
python -m Pipelines.pipeline
```

### Fichiers d'entrée requis

⚠️ Les 3 fichiers CSV doivent être présents dans le répertoire racine:

```
✓ daily_food_nutrition.csv      → Données nutritionnelles de référence
✓ gym_members_exercise.csv      → Sessions d'exercices gym
✓ diet_recommendations.csv      → Plans alimentaires recommandés
```

### Résultats

Après exécution réussie:

```
reports/
└── etl_report_YYYYMMDD_HHMMSS.json

Contenu rapport:
{
  "execution_start": "2026-02-04T10:30:00",
  "execution_end": "2026-02-04T10:35:00",
  "rows_extracted": 15000,
  "rows_cleaned": 14950,
  "rows_validated": 14920,
  "rows_transformed": 14920,
  "rows_loaded": 14920,
  "errors": 5,
  "warnings": 30,
  "success": true
}
```

### Paramètres du pipeline

```bash
python run_pipeline.py \
  --data-dir ./data              # Dossier CSV source (default: racine)
  --output-dir ./reports         # Dossier rapports (default: ./reports)
  --db-url postgresql://user:pwd@localhost/healthai  # URI base de données
  --workers 4                    # Nombre workers Spark (default: auto)
  --verbose                      # Mode debug
```

---

## 🏗️ Stack technologique

### Frontend

- **React 19** avec Vite (build 500ms)
- **Chart.js** pour visualisations
- **React Router v6** pour navigation
- **Axios** pour requêtes HTTP
- **CSS modules** pour styles

### Backend

- **Django 4.2** + **Django REST Framework**
- **PostgreSQL 15** (données relationnelles)
- **MongoDB 7** (cache, recommandations MSPR 2)
- **Redis 7** (caching sessions)
- **Pandas & NumPy** (data processing)
- **Pyspark** (ETL parallélisé)

### DevOps

- **Docker & Docker Compose** (local development)
- **AWS**: ECS, RDS, ElastiCache, S3, CloudFront, ALB
- **GitHub Actions** (CI/CD: test → build → deploy)
- **Terraform** (Infrastructure as Code)

### Monitoring

- **Sentry** (error tracking)
- **Prometheus** (metrics)
- **Jaeger** (distributed tracing)
- **CloudWatch** (AWS logging)

**Justification détaillée:** Voir [Frontend_Benchmarks.md](doc/guides/Frontend_Benchmarks.md)

---

## 📚 Documentation complète

### 📖 Point d'entrée principal

**👉 Commencer par:** [**doc/INDEX.md**](doc/INDEX.md)

Navigation par rôle, domaine, et FAQ.

### 📋 Documents MSPR 1

| Document                                                       | Pages | Contenu                                     |
| -------------------------------------------------------------- | ----- | ------------------------------------------- |
| [MSPR1_Architecture.md](doc/mspr1/MSPR1_Architecture.md)       | 2000+ | 3-layers design, componentes, flux données  |
| [MSPR1_DataModel.md](doc/mspr1/MSPR1_DataModel.md)             | 1500+ | ER diagram, 5 tables SQL, contraintes       |
| [MSPR1_ETL_Pipeline.md](doc/mspr1/MSPR1_ETL_Pipeline.md)       | 2500+ | 6 étapes détaillées + code Python           |
| [MSPR1_Technical_Stack.md](doc/mspr1/MSPR1_Technical_Stack.md) | 2000+ | Dependencies, Docker, AWS, Terraform, CI/CD |

### 📋 Documents MSPR 2

| Document                                                       | Pages | Contenu                                         |
| -------------------------------------------------------------- | ----- | ----------------------------------------------- |
| [MSPR2_Architecture.md](doc/mspr2/MSPR2_Architecture.md)       | 2000+ | Micro-service IA, recommandations, ML pipelines |
| [MSPR2_DataModel_NoSQL.md](doc/mspr2/MSPR2_DataModel_NoSQL.md) | 1500+ | MongoDB collections, sharding, aggregations     |

### 📋 Spécifications API

| Document                                                       | Endpoints | Format                  |
| -------------------------------------------------------------- | --------- | ----------------------- |
| [MSPR1_API_OpenAPI.yaml](doc/api-specs/MSPR1_API_OpenAPI.yaml) | 30+       | OpenAPI 3.0.0 (Swagger) |

### 📋 Guides transversaux

| Guide                                                               | Topics                                                   |
| ------------------------------------------------------------------- | -------------------------------------------------------- |
| [WCAG_RGAA_Accessibility.md](doc/guides/WCAG_RGAA_Accessibility.md) | WCAG 2.1 AA/AAA, RGAA 4, ARIA, exemples HTML/CSS         |
| [Frontend_Benchmarks.md](doc/guides/Frontend_Benchmarks.md)         | Tech choices, React vs Vue vs Angular, databases, DevOps |

### 📄 Resumes executifs

| Document                                             | Audience                    |
| ---------------------------------------------------- | --------------------------- |
| [SUMMARY.md](doc/SUMMARY.md)                         | Stakeholders, non-technical |
| [DOCUMENTATION_RECAP.md](doc/DOCUMENTATION_RECAP.md) | Overview création docs      |

---

## 🏛️ Architecture

### Architecture 3-layers MSPR 1

```
┌─────────────────────────────────────────────────────┐
│  Frontend (React 19 + Vite)                         │
│  - Dashboard / Analytics / Health / Nutrition       │
│  - Activity / Patients / KPIs                       │
└──────────────────┬──────────────────────────────────┘
                   │ HTTP/REST (Axios)
                   ↓
┌──────────────────────────────────────────────────────────┐
│  Backend API (Django 4.2 + DRF)                         │
│  - ViewSets: Patient, Santé, Nutrition, Activité, Gym   │
│  - KPI Endpoints: Health, Engagement, Conversion        │
│  - Pagination, Filtering, Error Handling                │
└──────┬──────────────────────────────────────────────┬────┘
       │                                              │
       ↓                                              ↓
┌─────────────────────────┐              ┌────────────────────┐
│ PostgreSQL (Primary)    │              │ Pipeline ETL       │
│ - 5 Tables relations    │              │ - Extraction CSV   │
│ - ACID transactions     │              │ - Nettoyage data   │
│ - Indices optimization  │              │ - Validation rules │
└─────────────────────────┘              │ - Transformation   │
                                         │ - Chargement DB    │
           ┌────────────────────────────────┐
           ↓                                ↓
    ┌─────────────┐            ┌───────────────────┐
    │ Redis Cache │            │ MongoDB (Cache)   │
    │ - Sessions  │            │ - Recommendations │
    │ - KPI cache │            │ - User profiles   │
    └─────────────┘            └───────────────────┘
```

**Détails complets:** [MSPR1_Architecture.md](doc/mspr1/MSPR1_Architecture.md)

---

## 💻 Développement

### Frontend

```bash
cd frontend

# Install dependencies
npm install

# Dev server (http://localhost:5173 avec HMR)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Linting
npm run lint

# Test
npm run test
```

### Backend

```bash
cd backend

# Migrations
python manage.py makemigrations
python manage.py migrate

# Dev server (http://localhost:8000)
python manage.py runserver

# Create superuser
python manage.py createsuperuser

# Admin panel
# → http://localhost:8000/admin

# Collect static files
python manage.py collectstatic

# Run tests
python manage.py test

# Code quality
black .
flake8 .
```

### ETL Pipeline

```bash
# Voir section "Lancer l'ETL" ci-dessus
python run_pipeline.py
```

---

## 🚀 Déploiement

### Production AWS (détails complets dans Technical_Stack.md)

#### 1. Architecture

```
┌─────────────────────────────────────────────────────┐
│  CloudFront CDN (Caching statique)                  │
└──────────────┬──────────────────────────────────────┘
               ↓
┌──────────────────────────────────────────────────────┐
│  ALB (Application Load Balancer)                     │
└──────────┬───────────────────────────┬───────────────┘
           ↓                           ↓
    ┌─────────────┐            ┌──────────────┐
    │ ECS Task    │  (Auto     │ ECS Task     │
    │ (Frontend)  │  Scaling)  │ (Backend)    │
    └─────────────┘  (min: 2   └──────────────┘
                     max: 10)
           ↓                           ↓
    ┌──────────────────────────────────────────┐
    │ RDS PostgreSQL (Multi-AZ)                │
    │ + ElastiCache Redis                      │
    │ + S3 (Backups, Media)                    │
    └──────────────────────────────────────────┘
```

#### 2. GitHub Actions CI/CD

```yaml
Test → Build Docker → Push ECR → Deploy ECS
↓         ↓              ↓          ↓
pytest    npm build    docker push  ecs-deploy
coverage  backend      registry     health-check
build        cleanup      smoke-test
```

#### 3. Commands

```bash
# Déployer avec Terraform
cd infrastructure
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Déployer manuellement
docker build -t healthai-backend:latest ./backend
docker push [AWS_ACCOUNT].dkr.ecr.[REGION].amazonaws.com/healthai-backend:latest

# Vérifier deployment
aws ecs describe-services --cluster production --services healthai-backend
```

**Documentation complète:** [MSPR1_Technical_Stack.md](doc/mspr1/MSPR1_Technical_Stack.md#déploiement-production)

---

## ♿ Accessibilité

✅ **MSPR 1:** WCAG 2.1 **AA** compliance  
✅ **MSPR 2:** WCAG 2.1 **AAA** compliance

### Checklist implementé MSPR 1

- [x] Text alternatives pour images
- [x] Keyboard navigation complète
- [x] Focus indicators visibles
- [x] Contraste 4.5:1 (WCAG AA)
- [x] Responsive design
- [x] ARIA labels & landmarks
- [x] HTML sémantique
- [x] Skip links
- [x] Error messages clairs
- [x] Abbr & definitions

### Testing

```bash
# Lighthouse audit
npm run audit

# axe DevTools
# → https://www.deque.com/axe/devtools/

# Pa11y
npx pa11y http://localhost:5173

# WAVE
# → https://wave.webaim.org/
```

**Guide complet:** [WCAG_RGAA_Accessibility.md](doc/guides/WCAG_RGAA_Accessibility.md)

---

## 📊 Bases de données

### Schémas

#### PostgreSQL (MSPR 1 - Relationnelle)

```sql
-- 5 Tables principales
patient (id, age, gender, weight, height, bmi_calc, created_at)
sante (id, patient_id, cholesterol, blood_pressure, disease, glucose, severity)
nutrition (id, patient_id, daily_intake, restrictions, allergies, adherence)
activite_physique (id, patient_id, level, weekly_hours)
gym_session (id, patient_id, date, duration, calories, bpm, fat_percent)
```

**ER Diagram & détails:** [MSPR1_DataModel.md](doc/mspr1/MSPR1_DataModel.md)

#### MongoDB (MSPR 2 - NoSQL)

```javascript
// Collections
recommendations; // { patient_id, meal_analysis, recommendations, personalization }
user_profiles; // { ai_profile, goals, preferences, constraints, behavior }
meal_analysis; // { meal_id, photo_url, vision_analysis, confidence }
predictions; // { prediction_id, model_info, predictions_7d_30d_90d }
feedback_audit; // { recommendation_id, user_action, rating, outcome }
```

**Schemas & Aggregations:** [MSPR2_DataModel_NoSQL.md](doc/mspr2/MSPR2_DataModel_NoSQL.md)

### Init base de données

```bash
# PostgreSQL (dev)
psql -U postgres -f BDD.sql

# Ou via Docker
docker-compose exec postgres psql -U postgres -f /BDD.sql

# Vérifier tables
\dt  -- list tables
```

---

## 🧪 Tests

### Frontend

```bash
cd frontend
npm run test:unit      # Vitest (>80% target)
npm run test:e2e       # Playwright
npm run coverage       # Coverage report
```

### Backend

```bash
cd backend
python manage.py test  # Pytest (>85% target)
pytest --cov=api      # Coverage report
pytest -v --lf        # Last failed
```

### Pipeline

```bash
python -m pytest Pipelines/tests/
```

---

## 🐛 Troubleshooting

### Frontend ne démarre pas

```bash
# Vérifier Node.js version
node --version  # Doit être 18+

# Nettoyer cache
rm -rf node_modules package-lock.json
npm install

# Port 5173 occupé?
npm run dev -- --port 3000
```

### Backend migration error

```bash
# Rollback migrations
python manage.py migrate api 0001

# Re-apply
python manage.py migrate

# Créer migration
python manage.py makemigrations
```

### ETL échoue

```bash
# Vérifier CSV présents
ls -la *.csv

# Vérifier path
python run_pipeline.py --data-dir ./

# Debug verbose
python run_pipeline.py --verbose

# Vérifier database connection
python -c "import django; django.setup(); print('✅ DB OK')"
```

### PostgreSQL connexion refuse

```bash
# Vérifier service Docker
docker-compose ps postgres

# Check logs
docker-compose logs postgres

# Restart
docker-compose restart postgres
```

---

## 📞 Support & Contribution

### Documentation

Pour questions ou améliorations documentation:

```
GitHub Issues → label `documentation`
GitHub Discussions → category `documentation`
```

### Rapporter bugs

```bash
GitHub Issues → label `bug`
Description:
- Reproduction steps
- Expected vs actual
- Logs/screenshots
- Environment (OS, browser, Python version)
```

### Pull Requests

```bash
# Workflow
1. Fork repo
2. Branch feature (git checkout -b feature/amazing)
3. Commit (git commit -m 'feat: amazing feature')
4. Push (git push origin feature/amazing)
5. Open PR avec description

# Checklist PR
- [ ] Tests pass (npm test, pytest)
- [ ] Code coverage ok
- [ ] Documentation updated
- [ ] No linting errors
```

### Contacts

| Rôle              | Contact                   |
| ----------------- | ------------------------- |
| **Tech Lead**     | tech@healthai-coach.com   |
| **Data Engineer** | data@healthai-coach.com   |
| **DevOps**        | devops@healthai-coach.com |

---

## 📄 Licence

MIT License - Voir LICENSE file

---

## 🎯 Prochaines étapes

### MSPR 1 (Actuellement)

- ✅ Documentation architecture
- ✅ Pipeline ETL fonctionnel
- ✅ Backend API + Frontend
- ⏳ Code review & testing
- ⏳ Soutenance (15 février)

### MSPR 2 (À partir semaine 3)

- ⏳ Développer micro-service IA (FastAPI)
- ⏳ Implémenter recommandations (nutrition + activité)
- ⏳ Intégrer Vision API & NLP
- ⏳ Advanced UI components
- ⏳ Accessibilité AAA compliance
- ⏳ Soutenance finale (avril)

---

## 📈 Métriques clés

| KPI                 | MSPR 1     | MSPR 2     |
| ------------------- | ---------- | ---------- |
| Users               | 50k        | 100k+      |
| Accessibility       | WCAG AA    | WCAG AAA   |
| API Latency         | <200ms     | <150ms     |
| Frontend Bundle     | 180KB      | 250KB      |
| Test Coverage       | >85%       | >90%       |
| DB Size             | 2GB        | 5GB+       |
| Response Time (API) | P95: 150ms | P95: 100ms |

---

## 📚 Ressources externes

- [Django Documentation](https://docs.djangoproject.com/)
- [React 19 Docs](https://react.dev/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [AWS ECS Guide](https://docs.aws.amazon.com/ecs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MongoDB Manual](https://docs.mongodb.com/manual/)

---

## 💡 Quick Reference

### Commandes fréquentes

```bash
# Setup
docker-compose up -d && docker-compose logs -f

# Dev frontend
cd frontend && npm run dev

# Dev backend
cd backend && python manage.py runserver

# Run ETL
python run_pipeline.py

# Tests
npm test && cd backend && pytest

# Lint
npm run lint && black . && flake8 .

# Deploy
git push → GitHub Actions → AWS
```

### URLs principales

```
Frontend:     http://localhost:5173
Backend API:  http://localhost:8000/api
Swagger UI:   http://localhost:8000/api/schema/swagger-ui/
Admin:        http://localhost:8000/admin (user: admin, pwd: admin)
PostgreSQL:   localhost:5432
MongoDB:      localhost:27017
Redis:        localhost:6379
```

---

**👉 Pour démarrer:** Consultez [**doc/INDEX.md**](doc/INDEX.md) pour navigation complète par rôle.

**Questions?** Ouvrez une issue ou consultez [SUMMARY.md](doc/SUMMARY.md) pour FAQ.

---

<div align="center">

**HealthAI Coach v1.0** | MSPR Semestre 2, 2026

![Made with ❤️](https://img.shields.io/badge/made%20with-❤️-red)

</div>
