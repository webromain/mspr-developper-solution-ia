# MSPR 2 - Architecture Globale

**HealthAI Coach - Phase 2: API IA avec Recommandations**

Durée: 50 heures | Livrables: API IA micro-service, moteur recommandations, interface utilisateur avancée

---

## 1. Contexte & évolution

La MSPR 2 s'appuie sur la fondation MSPR 1 (données nettoyées, structure BD, API REST) pour ajouter des **capacités prédictives et IA** permettant des recommandations personnalisées.

**État HealthAI Coach Phase 2:**

- 50 000 utilisateurs actifs
- Données consolidées depuis MSPR 1
- Équipe data scientists & ingénieurs IA renforcée
- Partenariats: OpenAI, Hugging Face, vision APIs

---

## 2. Vision globale MSPR 2

```
┌──────────────────────────────────────────────────────────────────────────┐
│                     HealthAI Coach MSPR 2 Architecture                    │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌─ Frontend UI Avancée ─┐    ┌─ Backend MSPR 1 ─┐    ┌─ Micro-service IA ┐
│  │  React + Vite         │    │  Django + DRF    │    │  Python FastAPI    │
│  │  • Soumission photos  │    │  • Patient mgmt  │    │  • Recommandations │
│  │  • Recommandations UI │───→│  • CRUD données  │───→│  • Vision API      │
│  │  • Filtrage avancé    │    │  • KPIs          │    │  • NLP             │
│  │  • Visualisations 3D  │    │  • Authenticat.  │    │  • ML models       │
│  └───────────────────────┘    └──────────────────┘    └────────────────────┘
│        ↓ HTTP REST               ↓ SQL/JSON             ↓ gRPC/WebSocket
│        └────────────────────────────────────────────────────────────────┘
│                                                                            │
│  ┌─ Couche Données ─────────────────────────────────────────────────┐   │
│  │                                                                    │   │
│  │  PostgreSQL (MSPR1)    MongoDB (NoSQL)      Redis (Cache)        │   │
│  │  ├─ patient            ├─ recommendations   ├─ model cache       │   │
│  │  ├─ sante              ├─ user_preferences  ├─ session tokens    │   │
│  │  ├─ nutrition          ├─ meal_analysis     ├─ KPI cache         │   │
│  │  ├─ activite           ├─ workout_plans     └─ temp predictions  │   │
│  │  └─ gym_session        └─ feedback_audit                         │   │
│  │                                                                    │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  ┌─ APIs Externes ─────────────────────────────────────────────────┐    │
│  │  • OpenAI GPT-4        - Générer recommandations texte          │    │
│  │  • Hugging Face        - Modèles NLP/Embedding                 │    │
│  │  • Google Vision API   - Reconnaissance aliments               │    │
│  │  • Azure Computer Vision - Analyse nutritionnelle photos       │    │
│  │  • Clarifai API        - Classification images avancée         │    │
│  └───────────────────────────────────────────────────────────────────┘    │
│                                                                            │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Composants principaux MSPR 2

### 3.1 Micro-service IA (Core)

**Framework:** FastAPI + Python 3.11

**Responsabilités:**

- Recommandations nutritionnelles personnalisées
- Moteur recommandations activité physique
- Traitement images (vision par ordinateur)
- Modèles ML/IA (prédictions)
- Agrégations données

**Architecture interne:**

```
┌─────────────────────────────────────┐
│      FastAPI Application            │
├─────────────────────────────────────┤
│                                     │
│  ┌─ Routes API (REST) ─┐           │
│  │ /recommendations/   │           │
│  │ /meal-analysis/     │           │
│  │ /workout-plans/     │           │
│  │ /health-predictions │           │
│  └─────────────────────┘           │
│          ↓                          │
│  ┌─ Services Métier ─┐             │
│  │ • NutritionEngine │             │
│  │ • ActivityEngine  │             │
│  │ • PredictorEngine │             │
│  └───────────────────┘             │
│          ↓                          │
│  ┌─ Couche Données ─┐              │
│  │ • MongoDB Client │              │
│  │ • PostgreSQL ORM │              │
│  │ • Redis Cache    │              │
│  └──────────────────┘              │
│          ↓                          │
│  ┌─ Modèles ML ─────┐              │
│  │ • Collaborative   │              │
│  │   Filtering       │              │
│  │ • Content-Based   │              │
│  │ • Neural Networks │              │
│  └───────────────────┘              │
│                                     │
└─────────────────────────────────────┘
```

### 3.2 Frontend UI Avancée

**Améliorations MSPR 2 vs MSPR 1:**

| Fonctionnalité    | MSPR 1               | MSPR 2                      |
| ----------------- | -------------------- | --------------------------- |
| Visualisation KPI | Graphiques statiques | Dashboards interactifs      |
| Entrée données    | Manual               | Upload photos + formulaires |
| Recommandations   | Aucune               | IA personnalisées           |
| Filtrage          | Basique              | Multi-critères avancé       |
| Mobile support    | Responsive           | Progressive Web App (PWA)   |
| Accessibilité     | WCAG AA              | WCAG AAA + RGAA 4           |

**Nouvelles pages/composants:**

- `RecommendationsDashboard.jsx` - Affichage recommandations IA
- `MealAnalysis.jsx` - Upload photo + analyse nutritionnelle
- `WorkoutBuilder.jsx` - Construction plan entraînement personnalisé
- `HealthPredictions.jsx` - Visualisation prédictions santé
- `FeedbackForm.jsx` - Retours utilisateur sur recommandations
- `ComparisonChart.jsx` - Comparaison nutrition/activité vs objectifs

**Stack avancé:**

- D3.js / Plotly.js pour visualisations 3D
- TensorFlow.js pour inférences ML frontend
- Service Workers pour PWA
- Web Socket pour mises à jour temps réel

### 3.3 Pipeline IA & ML

```
┌──────────────────────────────────────────────────────────────────┐
│                    ML Pipeline MSPR 2                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. Feature Engineering          2. Model Training               │
│  ├─ Extraction features          ├─ Algorithmes ML               │
│  ├─ Normalisation                ├─ Hyperparameter tuning        │
│  ├─ Interaction features         ├─ Cross-validation             │
│  └─ Embedding calculation        └─ Model evaluation             │
│                                                                   │
│  3. Model Deployment             4. Inference & Caching          │
│  ├─ Model serialization          ├─ Real-time predictions        │
│  ├─ Version management           ├─ Batch processing             │
│  ├─ A/B testing setup            ├─ Cache prediction results     │
│  └─ Monitoring metrics           └─ Feedback collection          │
│                                                                   │
│  5. Model Retraining             6. Monitoring & Alerts          │
│  ├─ Periodic updates             ├─ Model performance metrics    │
│  ├─ New data integration         ├─ Prediction drift detection   │
│  ├─ Feedback incorporation       └─ Business metrics tracking    │
│  └─ Model versioning                                             │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 4. Systèmes de recommandations

### 4.1 Recommandations nutritionnelles

**Pipeline:**

```
User submits meal photo
        ↓
Google Vision API / Azure Computer Vision
    ↓
Identified foods + portion estimation
        ↓
Nutritional database lookup (daily_food_nutrition.csv enrichie)
        ↓
Caloric & macro calculation
        ↓
Compare with user's daily goals & health profile
        ↓
Collaborative Filtering (recommandations similaires users)
        ↓
LLM (OpenAI GPT-4) for personalized advice
        ↓
Return: Meal analysis + suggestions + alternative meals
```

**Moteur recommandations (Algorithmes):**

1. **Content-Based Filtering**
   - Similarité entre plats (nutritionnellement)
   - Basé sur préférences utilisateur historiques
   - Scoring: similarity_score × relevance_score

2. **Collaborative Filtering**
   - Utilisateurs similaires → recommandations communes
   - Factorization matrices (SVD, NMF)
   - Cold-start problem: hybrid approach

3. **Contextual Bandits**
   - Optimization exploration vs exploitation
   - Multi-armed bandit algorithm
   - Learn preferences real-time

4. **LLM Personalization**
   - GPT-4 génère texte explainable
   - Considère objectifs santé, allergies, budget
   - Few-shot learning avec exemples user

**Métriques de qualité:**

- Precision@K - % recommandations pertinentes
- Recall@K - couverture recommandations
- NDCG - ranking quality
- User satisfaction rating

### 4.2 Recommandations activité physique

**Critères d'entrée:**

```
Input:
├─ Objectif utilisateur (perte poids, musculation, endurance)
├─ Historique performances (PBs, reps, weights)
├─ Métriques biométriques (current fitness level, BPM patterns)
├─ Contraintes (équipements, temps disponible, blessures)
├─ Préférences (activités aimées, horaires)
└─ Données météo / saisonnalité

Processing:
├─ Feature extraction (intensity profiles, progression rates)
├─ Historical performance analysis
├─ ML model inference (next_optimal_workout)
├─ Constraint checking (medical, material, time)
└─ Diversity & novelty scoring (avoid repetition)

Output:
├─ Recommended workout (type, intensity, duration)
├─ Progression suggestions (increase difficulty safely)
├─ Alternative exercises (equipment substitutions)
├─ Expected outcomes (calorie burn, muscle gains)
└─ Recovery recommendations (rest time, hydration)
```

**Modèles ML:**

1. **Progression Adaptive Model**
   - Prédire optimal progression (poids, reps)
   - Évite plateau, injuries
   - Basé sur historical response patterns

2. **Exercise Recommendation Engine**
   - Graph neural networks (exercises as nodes)
   - Edges = complementarité, progression path
   - Diversity constraint (vary exercises weekly)

3. **Recovery Predictor**
   - Prédire recovery time needed
   - Input: intensity, history, biometrics
   - Output: recovery hours + advice

---

## 5. Intégration MSPR 1 ← → MSPR 2

### 5.1 Architecture synchronisation

```
MSPR 1 (Backend)                    MSPR 2 (Micro-service IA)
┌──────────────────┐               ┌──────────────────────┐
│ Django + DRF     │               │ FastAPI             │
│ PostgreSQL       │ <─── gRPC ──→ │ Python ML           │
│ KPI Endpoints    │               │ Recomm. APIs        │
└──────────────────┘               └──────────────────────┘
         ↓                                    ↓
      Patient                           Recommendations
      Santé                             User Preferences
      Nutrition          ←─ Webhook ─→  Feedback Audit
      Activité
```

### 5.2 Communication APIs

**Option 1: REST + Polling**

```
MSPR 2 polls MSPR 1 every 5 minutes
GET /api/patients/?modified_since=2024-01-01
→ Fetch patient changes
→ Update local feature store
→ Retrain models if needed
```

**Option 2: gRPC + Server Streaming**

```
Streaming connection MSPR2 ↔ MSPR1
- Low latency
- Binary protocol (efficient)
- Request/response multiplexing
```

**Option 3: Event-driven (Kafka)**

```
MSPR 1 publishes events:
- patient.updated
- nutrition.logged
- gym_session.completed

MSPR 2 subscribes & processes:
- Update feature store
- Trigger recommendation recompute
- Cache invalidation
```

### 5.3 Partage données

**Tables PostgreSQL (read-only from MSPR 2):**

```sql
-- MSPR 1 database
READ VIEW: patient_features_view
  SELECT patient_id, age, gender, bmi, health_score, activity_score
  FROM (
    JOIN patient p
    JOIN sante s ON p.patient_id = s.patient_id
    JOIN nutrition n ON p.patient_id = n.patient_id
    JOIN activite_physique a ON p.patient_id = a.patient_id
  )
```

**Collections MongoDB (MSPR 2 primary):**

```json
{
  "_id": ObjectId(),
  "patient_id": 123,
  "recommendations": [{
    "type": "nutrition",
    "items": [...],
    "created_at": ISODate(),
    "feedback": "liked|ignored|completed"
  }],
  "predictions": [{
    "metric": "weight_change_30d",
    "predicted_value": -2.5,
    "confidence": 0.87
  }],
  "user_preferences": {
    "preferred_activities": [...],
    "dietary_preferences": [...]
  }
}
```

---

## 6. Flux utilisateur MSPR 2

### 6.1 Scénario: Recommandation nutritionnelle

```
1. User uploads meal photo
   ↓
2. Frontend sends to MSPR 2 /meal-analysis
   ↓
3. Vision API identifies foods → Portions
   ↓
4. Nutrition DB lookup → Macros/Calories
   ↓
5. Fetch user profile from MSPR 1 API
   ├─ health goals
   ├─ allergies
   ├─ daily intake target
   └─ historical preferences
   ↓
6. Run ML recommendation engine
   ├─ Collaborative filtering
   ├─ Content-based filtering
   └─ LLM personalization
   ↓
7. Generate response
   ├─ Meal analysis (calories, macros, micronutrients)
   ├─ Score vs daily goals (% of target)
   ├─ Suggested modifications
   ├─ Similar meals user liked before
   └─ Alternative options (lower cal, more protein, etc.)
   ↓
8. Cache prediction (Redis) for 24h
   ↓
9. Return JSON to frontend
   ↓
10. Frontend displays with visualizations
    ├─ Donut chart: macros breakdown
    ├─ Progress bar: daily intake vs goal
    ├─ Recommendation cards: alternatives
    └─ Add button → log meal in MSPR 1 DB
```

### 6.2 Scénario: Plan d'entraînement

```
1. User opens "Recommended Workout"
   ↓
2. Frontend queries /workout-plans
   ↓
3. MSPR 2 fetches from MSPR 1:
   ├─ Last 10 workouts (type, intensity, progress)
   ├─ Current health metrics (BPM, body fat %)
   └─ Active injuries/limitations
   ↓
4. ML inference:
   ├─ Progression adaptive model → next intensity
   ├─ Exercise recommendation → diversify
   ├─ Recovery check → safe to train?
   └─ Motivational factors → keep varied
   ↓
5. Generate workout plan
   ├─ Warm-up (5 min)
   ├─ Main exercises (3-5 with sets/reps)
   ├─ Cool-down (5 min)
   └─ Recovery recommendations
   ↓
6. Return with:
   ├─ Expected calorie burn
   ├─ Estimated duration
   ├─ Difficulty level
   ├─ Equipment needed
   └─ Video links for each exercise
   ↓
7. User completes workout (logged in MSPR 1)
   ↓
8. Feedback loop:
   ├─ Actual performance vs predicted
   ├─ User rating (easy/perfect/hard)
   └─ Model learns & improves
```

---

## 7. Conformité & normes MSPR 2

### 7.1 Responsabilité IA

- **Explicabilité:** Recommandations doivent être justifiées
  - Feature importance (SHAP values)
  - "Voici pourquoi" explications
  - Transparency report

- **Fairness:** Pas de biais discriminatoires
  - Model monitoring par demographic groups
  - Audit bias testing
  - Inclusive health recommendations

- **Privacy & Data Protection:**
  - RGPD compliance (droit oubli, portabilité)
  - Anonymization de training data
  - Consent management

### 7.2 Accessibilité (WCAG AAA)

- Tous les graphiques ont descriptions textuelles
- Navigation complète au clavier
- Support lecteurs écran avancés
- Texte alternatif pour images analysées
- Contraste ≥ 7:1 (AAA standard)

### 7.3 Sécurité IA

- API keys rotation (OpenAI, Vision APIs)
- Input validation (image size, format)
- Rate limiting (100 req/hour per user)
- Monitoring adversarial inputs
- Model poisoning prevention

---

## 8. Déploiement MSPR 2

### 8.1 Architecture déploiement

```
Load Balancer (AWS ALB)
        ↓
[FastAPI instances] × N (Auto-scaling 2-20)
        ↓
   ┌────┴────┐
   ↓         ↓
 MongoDB   PostgreSQL  Redis  Model Store
 (Atlas)   (RDS)      (Cache) (S3 + local)
```

### 8.2 Conteneurisation

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download ML models (from S3 at build time)
RUN python scripts/download_models.py

COPY . .

# Run FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
```

### 8.3 Monitoring & Observabilité

- **Prometheus metrics:**
  - Recommendation latency (ms)
  - Model inference time
  - Cache hit rate
  - API error rates

- **Distributed Tracing (Jaeger):**
  - Track request through MSPR1 ↔ MSPR2
  - Identify bottlenecks

- **Model Monitoring:**
  - Prediction drift (data drift detection)
  - Performance degradation alerts
  - Model version tracking

---

## 9. Roadmap détaillé MSPR 2

**Phase 1 (Semaines 1-2):**

- Micro-service FastAPI setup
- MongoDB collections design
- API recommandations skeleton

**Phase 2 (Semaines 2-3):**

- Vision API integration (meal photo analysis)
- Nutrition ML models training
- Frontend components (React)

**Phase 3 (Semaines 3-4):**

- Activity recommendation engine
- Advanced UI filtering/visualizations
- Integration tests MSPR1 ↔ MSPR2

**Phase 4 (Semaines 4-5):**

- Performance optimization (caching)
- Accessibility audit (WCAG AAA)
- Documentation & testing (pytest)

**Phase 5 (Week 5):**

- Presentation preparation
- Demo data setup
- Troubleshooting & refinement

---

## 10. Livrables finaux MSPR 2

✅ **API IA OpenAPI documentée** (swagger + YAML)
✅ **Micro-service FastAPI** séparé, scalable
✅ **Frontend avancé** React responsive
✅ **Modèles ML entraînés** (nutrition + activité)
✅ **MongoDB collections** structurées
✅ **Tests automatisés** (>80% couverture)
✅ **Documentation technique** complète
✅ **Guide d'accessibilité** WCAG AAA implémenté
✅ **Benchmarks technologiques** justifiés
✅ **Documentation de changement** (adoption guide)

---

## 11. Références & documentation liée

- [MSPR 1 Architecture](../mspr1/MSPR1_Architecture.md)
- [MSPR 1 Modèle de Données](../mspr1/MSPR1_DataModel.md)
- [API OpenAPI MSPR 2](../api-specs/MSPR2_API_OpenAPI.yaml) (à créer)
- [Modèle de Données NoSQL MSPR 2](MSPR2_DataModel_NoSQL.md) (à créer)
- [Guide d'Accessibilité](../guides/WCAG_RGAA_Accessibility.md)
- [Benchmarks Frontend](../guides/Frontend_Benchmarks.md)
