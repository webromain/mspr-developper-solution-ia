# Documentation HealthAI Coach - Index Principal

**Projets MSPR 1 & 2 - Bachelor Développeur IA & Data Science**

---

## 📚 Guide de Navigation

Bienvenue dans la documentation technique de **HealthAI Coach**, une plateforme de coaching santé et activité physique basée sur l'IA.

Ce projet comprend **2 MSPR (Missions Professionnelles Reconstituées)** suivies, chacune améliorant la précédente:

- **MSPR 1:** Infrastructure données, backend, ETL (Phase actuelle ✓)
- **MSPR 2:** API IA, recommandations personnalisées, interface avancée (À venir)

---

## 🎯 Démarrage rapide

### Pour le chef de projet / stakeholder

1. Lire [MSPR 1 - Architecture](mspr1/MSPR1_Architecture.md#1-vue-densemble-architecture)
2. Consulter [Résumé Executive](SUMMARY.md) (si existe)
3. Vérifier livrables: [Checklist MSPR 1](#livrables-mspr-1)

### Pour développeur frontend

1. [Stack technique MSPR 1](mspr1/MSPR1_Technical_Stack.md#2-stack-frontend)
2. [Architecture MSPR 1](mspr1/MSPR1_Architecture.md#23-frontend-react-19--vite)
3. [Benchmarks technologiques](guides/Frontend_Benchmarks.md)
4. [Guide d'accessibilité](guides/WCAG_RGAA_Accessibility.md)

### Pour développeur backend

1. [Architecture MSPR 1](mspr1/MSPR1_Architecture.md#22-backend-api-django-rest-framework)
2. [Modèle de données](mspr1/MSPR1_DataModel.md)
3. [API OpenAPI](api-specs/MSPR1_API_OpenAPI.yaml)
4. [Stack technique](mspr1/MSPR1_Technical_Stack.md#3-stack-backend)

### Pour data engineer / ETL

1. [Pipeline ETL MSPR 1](mspr1/MSPR1_ETL_Pipeline.md)
2. [Modèle de données](mspr1/MSPR1_DataModel.md)
3. [Stack technique - Données](mspr1/MSPR1_Technical_Stack.md#4-stack-données)

### Pour data scientist (MSPR 2)

1. [Architecture MSPR 2](mspr2/MSPR2_Architecture.md)
2. [Modèle de données NoSQL MSPR 2](mspr2/MSPR2_DataModel_NoSQL.md)
3. [Micro-service IA](mspr2/MSPR2_Architecture.md#31-micro-service-ia-core)

---

## 📖 Documentation MSPR 1

**Phase 1: Collection, nettoyage et visualisation des données**

### Architecture & Design

- [🏗️ Architecture globale MSPR 1](mspr1/MSPR1_Architecture.md)
  - Vue d'ensemble 3-couches
  - Composants principaux (Frontend, Backend, Pipeline ETL)
  - Flux de données
  - Intégrations externes
  - Roadmap MSPR 2

### Modèle de Données

- [📊 Modèle de données relationnel](mspr1/MSPR1_DataModel.md)
  - Diagramme ER avec 5 tables (patient, santé, nutrition, activité, gym_session)
  - Schéma SQL détaillé
  - Contraintes métier
  - Optimisations (indices, partitioning)
  - Évolution MSPR 2 (NoSQL)

### Pipeline ETL

- [🔄 Pipeline ETL 6 étapes](mspr1/MSPR1_ETL_Pipeline.md)
  - Extraction (CSV → DataFrames)
  - Nettoyage (doublons, imputation)
  - Validation (règles métier)
  - Transformation (enrichissement, calculs)
  - Chargement (persistance BD)
  - Reporting (JSON metrics)
  - Code source détaillé
  - Gestion d'erreurs & monitoring

### Stack Technique & Déploiement

- [🛠️ Stack technique MSPR 1](mspr1/MSPR1_Technical_Stack.md)
  - Dependencies Frontend (React 19, Vite, Chart.js)
  - Dependencies Backend (Django, DRF, Pandas)
  - Configuration Django settings.py
  - Docker Compose multi-service
  - Déploiement production AWS
  - CI/CD GitHub Actions
  - Checklist déploiement

### API REST Documentation

- [🔌 OpenAPI/Swagger MSPR 1](api-specs/MSPR1_API_OpenAPI.yaml)
  - Endpoints CRUD (Patients, Santé, Nutrition, Activité, Gym)
  - KPI aggregations (Health, Engagement, Conversion, Satisfaction)
  - Paramètres, requêtes, réponses
  - Codes d'erreur HTTP
  - Schémas JSON
  - Pagination & filtrage

---

## 🤖 Documentation MSPR 2

**Phase 2: API IA avec recommandations personnalisées**

### Architecture IA

- [🏗️ Architecture globale MSPR 2](mspr2/MSPR2_Architecture.md)
  - Micro-service IA (FastAPI)
  - Intégration MSPR 1 ↔ MSPR 2
  - Systèmes recommandations (nutrition + activité)
  - Pipeline ML/IA
  - Flux utilisateur (recommandations)
  - Déploiement & monitoring
  - Livrables finaux

### Modèle de Données NoSQL

- [📊 Collections MongoDB MSPR 2](mspr2/MSPR2_DataModel_NoSQL.md)
  - Structure collections (recommandations, user_profiles, predictions, feedback)
  - Documents détaillés (recommendation nutrition/activity)
  - Indices & sharding
  - Queries courantes (agrégations)
  - Synchronisation MSPR 1 ↔ MSPR 2

### API IA (À créer)

- [🔌 OpenAPI MSPR 2](api-specs/MSPR2_API_OpenAPI.yaml) - À documenter
  - Endpoints recommandations (POST /recommendations/meal, /recommendations/workout)
  - Endpoints analyse (POST /meal-analysis, /health-predictions)
  - Modèles requête/réponse
  - Authentification & rate limiting

---

## 📋 Guides Transversaux

### Accessibilité & Conformité

- [♿ Guide WCAG 2.1 AA & RGAA 4](guides/WCAG_RGAA_Accessibility.md)
  - 4 Principes fondamentaux (Perceptible, Utilisable, Compréhensible, Robuste)
  - Critères A/AA/AAA détaillés
  - Implémentation ARIA
  - Checklist conformité MSPR 1 & 2
  - Tools de testing (axe, WAVE, Lighthouse)
  - Audit externe RGAA France

### Benchmarks Technologiques

- [⚖️ Comparaison technologies](guides/Frontend_Benchmarks.md)
  - React 19 vs Vue 3 vs Angular (Framework)
  - Django vs FastAPI (Backend)
  - PostgreSQL vs MySQL (RDBMS)
  - MongoDB vs Firebase (NoSQL)
  - Justification choix pour MSPR 1 & 2
  - Architecture recommandée
  - Testing strategy (>80% coverage)

### Changement & Adoption

- [🚀 Documentation changement](guides/Change_Management.md) - À créer
  - Plan adoption utilisateurs
  - Formation équipes
  - Communication
  - Métriques succès
  - FAQ & troubleshooting

---

## 🗂️ Schémas & Références

### Diagrammes & Schemas

- [schemas/](schemas/) - Répertoire pour diagrammes Mermaid/SVG
  - Entity-Relationship Diagram (ERD)
  - Architecture diagram
  - Data flow diagram
  - Deployment diagram

### Spécifications API

- [api-specs/](api-specs/) - OpenAPI/Swagger
  - [MSPR1_API_OpenAPI.yaml](api-specs/MSPR1_API_OpenAPI.yaml) ✓ Complète
  - MSPR2_API_OpenAPI.yaml (À créer)

---

## 📊 Vue d'ensemble Livrables

### ✅ Livrables MSPR 1

| Livrable                    | Statut         | Référence                                                                                   |
| --------------------------- | -------------- | ------------------------------------------------------------------------------------------- |
| Architecture documentée     | ✓              | [MSPR1_Architecture.md](mspr1/MSPR1_Architecture.md)                                        |
| Modèle de données           | ✓              | [MSPR1_DataModel.md](mspr1/MSPR1_DataModel.md)                                              |
| Pipeline ETL                | ✓              | [MSPR1_ETL_Pipeline.md](mspr1/MSPR1_ETL_Pipeline.md)                                        |
| API REST (CRUD + KPIs)      | ✓              | Code backend/ + [OpenAPI](api-specs/MSPR1_API_OpenAPI.yaml)                                 |
| Frontend (React + Vite)     | ✓              | Code frontend/ + [Architecture](mspr1/MSPR1_Architecture.md#23-frontend-react-19--vite)     |
| Docker Compose              | ✓              | Code docker-compose.yml + [Guide](mspr1/MSPR1_Technical_Stack.md#5-containerization-docker) |
| Accessibilité WCAG AA       | ⚠️ Partielle   | [Guide](guides/WCAG_RGAA_Accessibility.md)                                                  |
| Tests automatisés           | ⚠️ À compléter | Test suite required                                                                         |
| Documentation API (OpenAPI) | ✓              | [MSPR1_API_OpenAPI.yaml](api-specs/MSPR1_API_OpenAPI.yaml)                                  |
| Rapports ETL                | ✓              | reports/\*.json                                                                             |

**Statut MSPR 1: ~85% complète (architecture & code ok, tester + affiner accessibilité)**

### 🔄 Livrables MSPR 2 (À venir)

| Livrable                      | Priorité | Référence                                                  |
| ----------------------------- | -------- | ---------------------------------------------------------- |
| Architecture micro-service IA | P1       | [MSPR2_Architecture.md](mspr2/MSPR2_Architecture.md)       |
| Modèle de données NoSQL       | P1       | [MSPR2_DataModel_NoSQL.md](mspr2/MSPR2_DataModel_NoSQL.md) |
| API IA (recommandations)      | P1       | À développer                                               |
| Frontend avancé (UI/UX)       | P2       | À développer                                               |
| Modèles ML entraînés          | P1       | À développer                                               |
| Vision API integration        | P1       | À développer                                               |
| Tests automatisés             | P2       | À développer                                               |
| Accessibilité WCAG AAA        | P3       | À compléter                                                |
| Documentation d'adoption      | P3       | À créer                                                    |
| Présentation orale            | P2       | À préparer                                                 |

---

## 🔍 Recherche & Navigation avancée

### Par rôle

- **Product Owner:** Architecture, livrables, timelines
- **Frontend Dev:** React guide, accessibility, performance
- **Backend Dev:** Django, API, database
- **Data Eng:** ETL pipeline, data quality, warehouse
- **DevOps:** Docker, Kubernetes, CI/CD, monitoring
- **Data Scientist:** ML models, Python, TensorFlow/PyTorch

### Par domaine

- **API/Integration:** [API OpenAPI](api-specs/MSPR1_API_OpenAPI.yaml), [Architecture](mspr1/MSPR1_Architecture.md#3-flux-de-données)
- **Data/Database:** [Modèle SQL](mspr1/MSPR1_DataModel.md), [ETL](mspr1/MSPR1_ETL_Pipeline.md), [MongoDB](mspr2/MSPR2_DataModel_NoSQL.md)
- **Frontend:** [React stack](mspr1/MSPR1_Technical_Stack.md#2-stack-frontend), [Benchmarks](guides/Frontend_Benchmarks.md), [Accessibilité](guides/WCAG_RGAA_Accessibility.md)
- **Backend:** [Django setup](mspr1/MSPR1_Technical_Stack.md#3-stack-backend), [FastAPI MSPR 2](mspr2/MSPR2_Architecture.md#31-micro-service-ia-core)
- **Deployment:** [Docker](mspr1/MSPR1_Technical_Stack.md#5-containerization-docker), [AWS](mspr1/MSPR1_Technical_Stack.md#62-aws-architecture), [CI/CD](mspr1/MSPR1_Technical_Stack.md#43-déploiement-cicd)

### Par question fréquente (FAQ)

- **"Comment commencer?"** → [Démarrage rapide](#-démarrage-rapide)
- **"Où trouver l'API?"** → [OpenAPI MSPR 1](api-specs/MSPR1_API_OpenAPI.yaml)
- **"Comment déployer?"** → [Docker + AWS](mspr1/MSPR1_Technical_Stack.md#6-déploiement-production)
- **"Que faut-il pour MSPR 2?"** → [Architecture MSPR 2](mspr2/MSPR2_Architecture.md)
- **"Est-ce accessible?"** → [Guide WCAG/RGAA](guides/WCAG_RGAA_Accessibility.md)
- **"Pourquoi React/Django?"** → [Benchmarks](guides/Frontend_Benchmarks.md)

---

## 📞 Support & Contacts

**Documentation Authors:**

- Architecture & Design: [Chef Projet]
- Backend/ETL: [Tech Lead Backend]
- Frontend: [Lead Frontend]
- Data Science: [Lead Data]

**Resources:**

- Project Repo: `git clone ...`
- Issue Tracker: GitHub Issues
- Wiki: Cette documentation
- Meetings: Weekly sync Thursdays 10h

---

## 📅 Timeline MSPR

```
MSPR 1 (19h - Semaines 1-2):       ✓ Phase actuelle
├─ Week 1: Architecture, Data model, ETL
├─ Week 2: Backend API, Frontend, Testing
└─ Soutenance: Présentation jury

MSPR 2 (50h - Semaines 3-7):       ⏳ À venir
├─ Week 3: IA architecture, ML models
├─ Week 4-5: Micro-service, API IA
├─ Week 6: Frontend avancé, Integration
├─ Week 7: Testing, Optimization
└─ Soutenance: Présentation finale
```

---

## 📚 Références & Ressources externes

### Documentation Officielle

- [React 19](https://react.dev)
- [Django 4.2](https://docs.djangoproject.com/4.2/)
- [FastAPI](https://fastapi.tiangolo.com)
- [PostgreSQL 15](https://www.postgresql.org/docs/15/)
- [MongoDB 7](https://docs.mongodb.com/)

### Standards & Guidelines

- [WCAG 2.1 Accessibility](https://www.w3.org/WAI/WCAG21/quickref/)
- [RGAA 4 France](https://www.numerique.gouv.fr/publications/rgaa-accessibilite/)
- [OpenAPI 3.0](https://swagger.io/specification/)
- [REST API Design](https://restfulapi.net/)

### Learning Resources

- [Web.dev Performance](https://web.dev/performance)
- [MDN Web Docs](https://developer.mozilla.org/)
- [Real Python](https://realpython.com/)
- [Docker Documentation](https://docs.docker.com/)

---

## 🎓 Crédits & License

**Projet HealthAI Coach**

- Année académique: 2025-2026
- Formation: Bachelor Concepteur Développeur d'Applications / Développeur en IA & Data Science (RNCP36581)
- Bloc: E6.1 - Créer un modèle de données d'une solution I.A en utilisant des méthodes de Data science

**Documentation:**

- Générée par équipe projet + AI assistance
- Open-source sous license MIT
- Accessible & inclusif

---

## ✨ Dernière mise à jour

**Date:** 4 février 2026
**Version:** 1.0 MSPR 1
**Prochaine mise à jour:** Début MSPR 2 (Semaine 3)

---

## 📍 Vous êtes ici

```
HealthAI Coach/
├── README.md (général)
├── doc/ (← VOUS ÊTES ICI)
│   ├── INDEX.md (cette page)
│   ├── SUMMARY.md (executive summary)
│   ├── mspr1/
│   │   ├── MSPR1_Architecture.md
│   │   ├── MSPR1_DataModel.md
│   │   ├── MSPR1_ETL_Pipeline.md
│   │   └── MSPR1_Technical_Stack.md
│   ├── mspr2/
│   │   ├── MSPR2_Architecture.md
│   │   └── MSPR2_DataModel_NoSQL.md
│   ├── api-specs/
│   │   ├── MSPR1_API_OpenAPI.yaml
│   │   └── MSPR2_API_OpenAPI.yaml (TBD)
│   ├── guides/
│   │   ├── WCAG_RGAA_Accessibility.md
│   │   ├── Frontend_Benchmarks.md
│   │   └── Change_Management.md (TBD)
│   └── schemas/ (diagrammes)
├── backend/ (code)
├── frontend/ (code)
├── Pipelines/ (ETL code)
└── ...
```

---

**Prêt à commencer? → [Architecture MSPR 1](mspr1/MSPR1_Architecture.md) ou [Stack Technique](mspr1/MSPR1_Technical_Stack.md)**
