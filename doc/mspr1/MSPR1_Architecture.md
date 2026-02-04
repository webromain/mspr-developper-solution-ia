# MSPR 1 - Architecture Globale

**HealthAI Coach - Phase 1: Backend & Data Pipeline**

Durée: 19 heures | Livrable: Infrastructure de collecte, nettoyage et visualisation des données

---

## 1. Vue d'ensemble architecture

HealthAI Coach Phase 1 déploie une **architecture en trois couches** permettant l'ingestion, transformation et visualisation de données de santé et activité physique:

```
┌─────────────────────────────────────────────────────────────────┐
│                    Couche Présentation                          │
│  Frontend React 19 + Vite (SPA - Single Page Application)       │
│  - Dashboard, Analytics, Health, Nutrition, Activity, Patients  │
│  - Composants réutilisables & visualisations Chart.js          │
└───────────────────┬─────────────────────────────────────────────┘
                    │
                    ↓ HTTP REST
┌─────────────────────────────────────────────────────────────────┐
│                  Couche API & Métier                           │
│  Django REST Framework (DRF)                                     │
│  - ViewSets: Patient, Santé, Nutrition, ActivitéPhysique, Gym   │
│  - KPI Aggregations: Health, Engagement, Conversion, Satisfaction│
│  - Sérialisation, Validation, Erreurs HTTP 400/404/500          │
└───────────────────┬─────────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        ↓                       ↓
┌─────────────────┐    ┌──────────────────┐
│  ETL Pipeline   │    │  Base de Données │
│  (Python)       │    │                  │
│ 6 étapes        │───→│  SQLite (dev)    │
│                 │    │  PostgreSQL (prod)
│ Extraction      │    │  MongoDB (cache) │
│ Nettoyage       │    │                  │
│ Validation      │    │ Tables:          │
│ Transformation  │    │ - patient        │
│ Chargement      │    │ - sante          │
│ Reporting       │    │ - nutrition      │
└────────┬────────┘    │ - activite_phys. │
         │             │ - gym_session    │
         ↓             └──────────────────┘
    CSV Sources
    (3 fichiers)
```

---

## 2. Composants principaux

### 2.1 Frontend (React 19 + Vite)

**Responsabilités:**

- Interface utilisateur moderne et responsive (desktop, tablet, mobile)
- Visualisation KPIs via Chart.js
- Navigation entre pages (React Router)
- Communication API (Axios)

**Pages:**
| Page | Fonction |
|------|----------|
| Dashboard | Vue globale KPIs (patients, engagement, santé, nutrition, gym) |
| Analytics | Analyse avancée de données |
| Health | Suivi métriques santé (BMI, cholestérol, glucose, tension) |
| Nutrition | Suivi apports nutritionnels, recommandations |
| Activity | Suivi activité physique |
| Patients | Gestion et liste des patients |

**Composants réutilisables:**

- `StatCard.jsx` - Cartes métriques avec icônes et variations
- `ChartOptions.js` - Configuration des graphiques
- `Footer.jsx` - Footer commun

**Stack:**

- **Framework:** React 19 avec JSX
- **Build:** Vite (développement HMR, production optimisée)
- **Routage:** React Router v6+
- **HTTP:** Axios
- **Visualisation:** Chart.js + react-chartjs-2
- **Linting:** ESLint
- **CSS:** Modules CSS + CSS global (index.css, App.css)

---

### 2.2 Backend API (Django REST Framework)

**Responsabilités:**

- Gestion des modèles de données (ORM Django)
- Endpoints REST pour CRUD
- Agrégations KPI
- Validation métier & sérialisation

**Modèles de données:**

| Entité               | Clé          | Relations       | Champs clés                                                       |
| -------------------- | ------------ | --------------- | ----------------------------------------------------------------- |
| **Patient**          | patient_id   | 1:∞ gym_session | age, gender, weight_kg, height_cm                                 |
| **Santé**            | sante_id     | ←1:1 patient_id | cholesterol, blood_pressure, disease_type, glucose, severity      |
| **Nutrition**        | nutrition_id | ←1:1 patient_id | daily_caloric_intake, dietary_restrictions, allergies, adherence  |
| **ActivitéPhysique** | activite_id  | ←1:1 patient_id | physical_activity_level, weekly_exercise_hours                    |
| **GymSession**       | session_id   | ←N:1 patient_id | duration, calories*burned, workout_type, BPM, fat*%, water_intake |

**ViewSets Django DRF:**

```
/api/patients/          → PatientViewSet (CRUD, list)
/api/sante/             → SanteViewSet (CRUD, list)
/api/nutrition/         → NutritionViewSet (CRUD, list)
/api/activite/          → ActivitePhysiqueViewSet (CRUD, list)
/api/gym-sessions/      → GymSessionViewSet (CRUD, list)
/api/kpis/health        → KPI Santé
/api/kpis/engagement    → KPI Engagement
/api/kpis/conversion    → KPI Conversion Nutrition/Activité
/api/kpis/satisfaction  → KPI Satisfaction Santé
```

**KPI Aggregations:**

- **Santé:** Nombre patients, âge moyen, BMI moyen, cholestérol moyen, distribution maladies
- **Engagement:** Patients actifs, taux engagement, sessions/patient
- **Conversion:** Adherence plan nutritionnel ≥75%, activité ≥3h/semaine
- **Satisfaction:** % cholestérol sain, % glucose sain, distribution sévérité

---

### 2.3 Pipeline ETL (Python)

**Responsabilités:**

- Extraction données depuis 3 sources CSV
- Nettoyage, déduplication, normalisation
- Validation contre règles métier
- Transformation et enrichissement
- Chargement en base de données
- Génération rapports qualité

**6 Étapes du pipeline:**

1. **Extraction** → Charge CSV, parsing, conversion types
2. **Nettoyage** → Suppression doublons, imputation manquants
3. **Validation** → Règles métier (ranges, énumérations, cohérence)
4. **Transformation** → Normalisation, calculs (BMI), standardisation
5. **Chargement** → Insertion/Update base données
6. **Reporting** → Rapports JSON validation + métriques

**Sources de données:**

| Source                   | Format | Contenu                                                       |
| ------------------------ | ------ | ------------------------------------------------------------- |
| daily_food_nutrition.csv | CSV    | Nutriments aliments (calories, protéines, graisses, glucides) |
| gym_members_exercise.csv | CSV    | Sessions gym (membre, durée, calories, BPM, métriques)        |
| diet_recommendations.csv | CSV    | Recommandations nutritionnelles par profil                    |

---

### 2.4 Base de Données

**Technologie:** SQLite (dev), PostgreSQL (prod), MongoDB (cache)

**Schéma relationnel (SQL):**

```sql
patient (patient_id, age, gender, weight_kg, height_cm, bmi)
├── sante (sante_id, patient_id, cholesterol, blood_pressure,
│          disease_type, glucose, severity)
├── nutrition (nutrition_id, patient_id, daily_caloric_intake,
│             dietary_restrictions, allergies, diet_recommendation,
│             adherence_to_diet_plan)
├── activite_physique (activite_id, patient_id, physical_activity_level,
│                      weekly_exercice_hours)
└── gym_session (session_id, patient_id, duration, calories_burned,
                workout_type, BPM, fat_percentage, water_intake,
                experience_level)
```

---

## 3. Flux de données

### 3.1 Flux d'ingestion (Backend → DB)

```
[CSV Sources]
      ↓
[ETL Pipeline] → [Validation] → [Transformation]
      ↓              ↓                ↓
[Nettoyage] ← [Règles Métier]   [Enrichissement]
      ↓
[SQLite/PostgreSQL Database]
      ↓
[Django ORM]
      ↓
[REST API ViewSets]
      ↓
[Frontend React]
```

### 3.2 Flux de requête (Frontend → API)

```
Frontend HTTP Request
  ↓
Django REST Router
  ↓
ViewSet (authenticate → permission → business logic)
  ↓
Serializer (validate → transform)
  ↓
Database Query
  ↓
JSON Response
  ↓
Frontend Render
```

---

## 4. Intégrations externes & dépendances

**Backend Dependencies:**

- `django >= 4.2` - Web framework
- `djangorestframework >= 3.14` - REST API
- `django-cors-headers` - CORS support
- `psycopg2-binary` - PostgreSQL driver
- `pymongo` - MongoDB client
- `pandas` - Data processing
- `numpy` - Numerical computing
- `sqlalchemy` - ORM abstraction
- `pyspark` - Big data (optionnel)

**Frontend Dependencies:**

- `react >= 19` - UI framework
- `react-router-dom` - Client-side routing
- `axios` - HTTP client
- `chart.js` - Charting library
- `react-chartjs-2` - React wrapper pour Chart.js
- `vite >= 5` - Build tool
- `eslint` - Code linting

**Infrastructure:**

- Docker & Docker Compose - Containerization
- PostgreSQL 14+ - Database
- MongoDB 5+ - Cache/Document storage
- Redis 6+ - Caching layer

---

## 5. Déploiement & environnements

### 5.1 Environnement de développement (Docker Compose)

```yaml
Services:
  - frontend: Vite @ localhost:5173
  - backend: Django @ localhost:8000
  - postgres: PostgreSQL @ localhost:5432
  - mongodb: MongoDB @ localhost:27017
  - redis: Redis @ localhost:6379
```

### 5.2 Environnement de production

- **Frontend:** Build Vite (dist/) → S3/CDN → CloudFront
- **Backend:** Django Gunicorn → Load Balancer → RDS PostgreSQL
- **Cache:** Redis ElastiCache
- **Monitoring:** CloudWatch, DataDog

---

## 6. Conformité & normes

### 6.1 Accessibilité (WCAG 2.1 AA / RGAA 4)

- Navigation clavier complète (Tab, Enter, Esc)
- Support lecteurs d'écran (ARIA labels)
- Contrastes conforme (4.5:1 minimum texte normal, 3:1 grand texte)
- Responsive design mobile-first

### 6.2 Sécurité

- CORS configuré pour domaines autorisés
- CSRF protection (Django middleware)
- Input validation (serializers DRF)
- SQL injection prevention (ORM Django/SQLAlchemy)
- HTTPS en production
- API rate limiting

### 6.3 Performance

- Pagination des listes (20/50/100 items)
- Cache Redis pour KPIs fréquents
- Index DB sur patient_id, dates
- Compression gzip Frontend
- Lazy loading images/components

---

## 7. Gestion d'erreurs & monitoring

**HTTP Status Codes:**

- `200 OK` - Succès
- `201 Created` - Ressource créée
- `400 Bad Request` - Validation failed
- `404 Not Found` - Ressource inexistante
- `500 Internal Server Error` - Backend error

**Logging:**

- Django logging (DEBUG, INFO, WARNING, ERROR)
- Frontend console errors
- ETL pipeline logs (etl*report*\*.json)

---

## 8. Roadmap intégration MSPR 2

La MSPR 2 ("Développement API IA") s'appuiera sur cette fondation MSPR 1 pour ajouter:

- **Micro-service IA** séparé pour recommandations
- **API Vision par ordinateur** pour photos repas
- **Moteur recommandations multi-critères** nutrition + activité
- **Interface utilisateur avancée** avec filtrage, visualisations interactives
- **Intégration APIs externes** (OpenAI, Hugging Face, vision APIs)

L'architecture MSPR 1 sera étendue (non remplacée) avec une synchronisation données entre backend MSPR 1 et micro-service IA MSPR 2.

---

## 9. Références & documentation liée

- [Modèle de Données Détaillé](MSPR1_DataModel.md)
- [Spécification API OpenAPI](../api-specs/MSPR1_API_OpenAPI.yaml)
- [Pipeline ETL Détaillé](MSPR1_ETL_Pipeline.md)
- [Stack Technique & Déploiement](MSPR1_Technical_Stack.md)
- [Guide Accessibilité](../guides/WCAG_RGAA_Accessibility.md)
