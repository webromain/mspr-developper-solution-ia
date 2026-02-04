# Benchmarks Technologiques Frontend

**HealthAI Coach - Comparaison & justification choix technologies**

---

## 1. Sélection Framework Frontend

### 1.1 Critères d'évaluation

| Critère        | Poids | Justification                            |
| -------------- | ----- | ---------------------------------------- |
| Performance    | 25%   | Applications santé sensibles à latence   |
| Écosystème     | 20%   | Librairies composants, templates         |
| Learning curve | 15%   | Équipe bachelor doit maîtriser           |
| Accessibilité  | 15%   | WCAG/RGAA obligatoire                    |
| Bundle size    | 10%   | Vite a besoin <500KB gzip                |
| Community      | 10%   | Support long-terme, job market           |
| Scalabilité    | 5%    | MSPR 2 nécessite architecture extensible |

### 1.2 Comparatif détaillé

```
┌─────────────────────────────────────────────────────────────────┐
│        Framework Comparison - HealthAI Coach Requirements       │
├──────────────┬────────────────┬────────────────┬─────────────────┤
│ Critère      │ React 19       │ Vue 3          │ Angular 17      │
├──────────────┼────────────────┼────────────────┼─────────────────┤
│ Performance  │ ✓✓✓ Excellent  │ ✓✓ Très bon    │ ✓✓ Très bon     │
│              │ Opt virtual    │ Compiler       │ AOT by default  │
│              │ rendering      │ optimization   │                 │
│ Bundle size  │ ✓✓ (41KB)      │ ✓✓✓ (36KB)     │ ✗ (200KB+)      │
│ Learning     │ ✓✓ (JSX)       │ ✓✓✓ (Templates)│ ✗ (Steeply)     │
│ curve        │ Courbe modérée │ Plus douce     │ Très abrupte    │
│ Accessibilité│ ✓✓ (ARIA libs) │ ✓✓ (A11y libs) │ ✓✓✓ (Built-in)  │
│ Ecosystem    │ ✓✓✓ (Massive)  │ ✓✓ (Growing)   │ ✓✓ (Complete)   │
│ Community    │ ✓✓✓ (1M devs)  │ ✓✓ (500K devs) │ ✓✓ (Large)      │
│ Job market   │ ✓✓✓ (Highest)  │ ✓✓ (Growing)   │ ✓✓ (Enterprise) │
│ Scalability  │ ✓✓✓            │ ✓✓             │ ✓✓✓             │
├──────────────┼────────────────┼────────────────┼─────────────────┤
│ SCORE GLOBAL │ 92/100         │ 88/100         │ 76/100          │
│ VERDICT      │ ✓ CHOISI       │ Alternative    │ Non-optimal     │
└──────────────┴────────────────┴────────────────┴─────────────────┘
```

### 1.3 Justification choix React 19 + Vite

**React (vs Vue/Angular):**

1. **Performance:** Virtual DOM optimisé, lazy loading via React.lazy()

   ```jsx
   const MealAnalysis = lazy(() => import("./pages/MealAnalysis"));

   <Suspense fallback={<Loading />}>
     <MealAnalysis />
   </Suspense>;
   ```

2. **Écosystème mature:** React Router (v6), Axios, Redux, TanStack Query
   - Librairies accessibilité: react-aria, @radix-ui
   - Charting: Recharts, Victory, D3.js wrappers
3. **Learning curve acceptable:** JSX proche HTML, facile pour bachelor

   ```jsx
   // Intuitif pour débutants
   <div className="stat-card">
     <h2>{title}</h2>
     <p>{value}</p>
   </div>
   ```

4. **Job market:** Demande très élevée (58% offres frontend)

5. **Scalabilité MSPR 2:** Permet WebSocket (temps réel), state management (Redux), SSR future

**Vite (vs Webpack/Parcel):**

1. **Performance build:** 10-100× plus rapide (ES modules native)
   - Dev: ~500ms vs ~3s (Webpack)
   - Build: ~2s vs ~30s (Webpack)

2. **DX (Developer Experience):** HMR instantané, débugging facile

3. **Bundle size:** Code splitting automatique
   ```
   frontend/dist/
   ├── index.html
   ├── assets/
   │   ├── index-ABC123.js (main app)
   │   ├── vendor-DEF456.js (React, libs)
   │   ├── chunk-chart-GHI789.js (Chart.js lazy-loaded)
   │   └── index-XYZ789.css (styles)
   ```

---

## 2. Librairies complèmentaires

### 2.1 Routing & State Management

| Besoin          | Outil           | Raison                              |
| --------------- | --------------- | ----------------------------------- |
| Routing         | React Router v6 | Standard de facto, lazy loading     |
| State global    | Redux Toolkit   | Prévisibilité, DevTools, middleware |
| Server state    | TanStack Query  | Caching, synchronisation API        |
| Form validation | React Hook Form | Performance, bundle léger           |

### 2.2 Visualisations & UI

| Composant       | Bibliothèque                 | Justification                  |
| --------------- | ---------------------------- | ------------------------------ |
| Graphiques 2D   | Recharts                     | React-native, accessible       |
| Graphiques 3D   | Three.js + React Three Fiber | WebGL performance              |
| Tables avancées | TanStack Table               | Sorting, filtering, pagination |
| UI components   | Radix UI                     | Primitives accessibles         |
| Icônes          | Feather Icons / Heroicons    | SVG léger, a11y                |
| Animations      | Framer Motion                | Déclarative, performant        |

### 2.3 Architecture recommandée

```
frontend/
├── src/
│   ├── components/
│   │   ├── common/        (réutilisables)
│   │   │   ├── Button.jsx
│   │   │   ├── Card.jsx
│   │   │   └── Modal.jsx
│   │   ├── features/      (domaines métier)
│   │   │   ├── recommendations/
│   │   │   ├── mealAnalysis/
│   │   │   └── workoutBuilder/
│   │   └── layout/
│   ├── pages/             (routes)
│   ├── hooks/             (logique réutilisable)
│   ├── services/          (API calls)
│   ├── store/             (Redux slices)
│   ├── utils/             (helpers)
│   ├── styles/            (CSS global)
│   └── App.jsx
├── public/
├── package.json
├── vite.config.js
└── vitest.config.js       (testing)
```

---

## 3. Backend Framework Selection

### 3.1 MSPR 1: Django REST Framework

**Django (vs FastAPI/Flask):**

```
┌────────────────────────────────────────────────┐
│ Framework Comparison - Backend MSPR 1          │
├────────────────┬────────────────┬──────────────┤
│ Critère        │ Django+DRF     │ FastAPI      │
├────────────────┼────────────────┼──────────────┤
│ Admin panel    │ ✓✓✓ Built-in   │ ✗ Manual     │
│ ORM            │ ✓✓✓ Django ORM │ ✓ SQLAlchemy │
│ Migrations     │ ✓✓✓ Intégrées  │ ✗ Alembic    │
│ Learning       │ ✓✓ Courbe      │ ✓✓✓ Rapide   │
│ Performance    │ ✓✓ Good        │ ✓✓✓ Excellent│
│ Maturity       │ ✓✓✓ 20 ans     │ ✓✓ 5 ans    │
│ For MSPR 1     │ ✓ CHOISI       │ Overkill    │
├────────────────┼────────────────┼──────────────┤
│ For MSPR 2 API │ ✗ Lourd        │ ✓ CHOISI    │
└────────────────┴────────────────┴──────────────┘
```

**Django pour MSPR 1:**

- Admin interface built-in (gestion données)
- ORM puissant (complex queries)
- Authentication/permissions
- Large équipe maintenance

### 3.2 MSPR 2: FastAPI

**FastAPI (vs Django pour IA):**

```python
# FastAPI = léger, performant pour API IA
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class RecommendationRequest(BaseModel):
    patient_id: int
    meal_photo_url: str

@app.post("/recommendations/meal")
async def get_meal_recommendation(req: RecommendationRequest):
    # ML inference
    recommendations = ml_model.predict(req.meal_photo_url)
    return {"recommendations": recommendations}
```

**Avantages FastAPI MSPR 2:**

- Async par défaut (non-blocking)
- Auto-documentation OpenAPI
- Validation Pydantic intégrée
- Performance C-like (Starlette + Uvicorn)
- Parfait pour microservices

---

## 4. Database Technology Selection

### 4.1 PostgreSQL (MSPR 1)

**PostgreSQL vs MySQL/MariaDB:**

| Critère         | PostgreSQL      | MySQL            | Verdict          |
| --------------- | --------------- | ---------------- | ---------------- |
| ACID compliance | ✓✓✓ Full        | ✓ Partial        | PostgreSQL       |
| Complex queries | ✓✓✓ Native      | ✓ Workaround     | PostgreSQL       |
| JSON support    | ✓✓✓ JSONB       | ✓ JSON           | PostgreSQL       |
| Performance     | ✓✓ (Read-heavy) | ✓✓ (Write-heavy) | PostgreSQL       |
| Cost            | Open-source     | Open-source      | Tie              |
| Learning        | Steeper         | Gentler          | MySQL            |
| **SCORE**       | **9/10**        | **7/10**         | **PostgreSQL ✓** |

**PostgreSQL pour MSPR 1:**

- Stockage données structurées (patient, santé, nutrition, activité)
- ACID transactions (intégrité données critiques)
- Array & JSON types (flexible)

### 4.2 MongoDB (MSPR 2)

**MongoDB vs Firebase/DynamoDB:**

| Critère             | MongoDB         | Firebase     | DynamoDB          |
| ------------------- | --------------- | ------------ | ----------------- |
| Self-hosted         | ✓ Atlas/on-prem | ✗ Cloud only | ✗ AWS only        |
| Schema flexibility  | ✓✓✓ Documents   | ✓ NoSQL      | ✓ Key-value       |
| Queries             | ✓✓ Aggregation  | ✓ Limited    | ✗ Very limited    |
| Cost predictability | ✓ Storage-based | ✗ Dynamic    | ✗ Pay-per-request |
| Learning curve      | ✓✓ Moderate     | ✓✓✓ Easy     | ✓ Moderate        |
| **SCORE**           | **9/10**        | **7/10**     | **6/10**          |
| **VERDICT**         | **✓ CHOISI**    | Alternative  | Non-optimal       |

**MongoDB pour MSPR 2:**

- Collections recommandations (documents imbriqués)
- Haute scalabilité (sharding)
- Flexibilité schéma (évolution IA)
- Performances écriture (predictions)

### 4.3 Redis (Cache MSPR 1 & 2)

**Justification Redis:**

- Session tokens (ultra-rapide)
- Cache KPIs (TTL 1h)
- Real-time features (pub/sub)
- Rate limiting

```python
# Cache KPIs santé 1 heure
redis_client.set(
    'kpi_health_metrics',
    json.dumps(metrics),
    ex=3600
)

# Récupérer du cache
cached = redis_client.get('kpi_health_metrics')
if cached:
    return json.loads(cached)
```

---

## 5. MLOps & Model Deployment

### 5.1 ML Framework Selection

| Framework          | Cas d'usage      | Raison                                     |
| ------------------ | ---------------- | ------------------------------------------ |
| scikit-learn       | ML classique     | Recommendations collaborative filtering    |
| TensorFlow/PyTorch | Deep learning    | Meal image recognition (transfer learning) |
| FastAI             | Computer vision  | Meal photo classification (ResNet50)       |
| XGBoost            | Tabular features | Health prediction (progression model)      |

### 5.2 Model Serving

```
Training (Offline)
  ↓
Models/ artifacts (S3)
  ↓
Loading in FastAPI
  ↓
Inference API
  ↓
Client prediction response
```

**Architecture recommandée:**

```python
# FastAPI with model caching
from functools import lru_cache
import torch

class MLModels:
    @lru_cache(maxsize=1)
    def load_meal_model(self):
        model = torch.load('models/meal_classifier.pt')
        model.eval()
        return model

models = MLModels()

@app.post("/analyze-meal")
async def analyze_meal(image_url: str):
    model = models.load_meal_model()
    prediction = model(preprocess(image_url))
    return {"foods": prediction}
```

**Monitoring:**

- Prediction latency: <2s pour UX acceptable
- Model drift: comparer predictions vs actuals
- Accuracy metrics: F1-score, precision, recall

---

## 6. DevOps & Infrastructure

### 6.1 Containerization

| Outil          | Raison             | MSPR 1            | MSPR 2            |
| -------------- | ------------------ | ----------------- | ----------------- |
| Docker         | Standard industrie | ✓ Backend         | ✓ Micro-service   |
| Docker Compose | Local dev          | ✓ Multi-container | ✓ IA + DB         |
| Kubernetes     | Scale prod         | ✓ EKS/GKE future  | ✓ Auto-scaling IA |

### 6.2 CI/CD

```yaml
# GitHub Actions example
name: Deploy

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: npm run test && python -m pytest
      - name: Lint
        run: npm run lint && pylint backend/

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Build Docker images
        run: |
          docker build -t healthai-frontend:${{ github.sha }} ./frontend
          docker build -t healthai-backend:${{ github.sha }} ./backend
      - name: Push to registry
        run: |
          aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_URI
          docker push $ECR_URI/healthai-frontend:${{ github.sha }}
          docker push $ECR_URI/healthai-backend:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: |
          aws ecs update-service --cluster healthai-prod \
            --service healthai-backend \
            --force-new-deployment
```

---

## 7. Testing Strategy

### 7.1 Frontend Testing

```javascript
// Vitest + React Testing Library
import { render, screen } from "@testing-library/react";
import StatCard from "./StatCard";

describe("StatCard", () => {
  it("displays health KPI correctly", () => {
    render(<StatCard title="Cholestérol" value={190} unit="mg/dL" />);

    expect(screen.getByText("Cholestérol")).toBeInTheDocument();
    expect(screen.getByText("190")).toBeInTheDocument();
  });
});
```

### 7.2 Backend Testing

```python
# pytest + Django TestCase
from django.test import TestCase
from rest_framework.test import APIClient

class PatientAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_list_patients(self):
        response = self.client.get('/api/patients/')
        self.assertEqual(response.status_code, 200)
        self.assertIn('count', response.json())
```

### 7.3 Coverage & Quality

- **Frontend:** Jest + Vitest - Target >80%
- **Backend:** pytest - Target >85%
- **Code quality:** SonarQube, Codacy
- **Performance:** Lighthouse, k6 load tests

---

## 8. Résumé des choix technologiques

| Layer             | Technology       | Version | Raison                              |
| ----------------- | ---------------- | ------- | ----------------------------------- |
| **Frontend**      | React            | 19      | Écosystème, job market, performance |
| Build tool        | Vite             | 5+      | Bundle rapide, HMR                  |
| Routing           | React Router     | 6+      | Standard, lazy loading              |
| State             | Redux Toolkit    | 1.9+    | Prévisibilité, DevTools             |
| UI/Visualization  | Recharts + D3.js | Latest  | React-native, accessible            |
| **Backend MSPR1** | Django           | 4.2+    | Admin, ORM, mature                  |
| REST API          | DRF              | 3.14+   | Serialization, permissions          |
| **Backend MSPR2** | FastAPI          | 0.100+  | Performance async                   |
| **Database**      | PostgreSQL       | 15+     | Relational, advanced                |
| Document DB       | MongoDB          | 7+      | Flexible, scalable                  |
| Cache             | Redis            | 7+      | Session, caching                    |
| **DevOps**        | Docker           | Latest  | Containerization                    |
| Orchestration     | Kubernetes       | Future  | Auto-scaling                        |
| CI/CD             | GitHub Actions   | Latest  | Workflow automation                 |

---

## 9. Références & ressources

- [React 19 Docs](https://react.dev)
- [Vite Guide](https://vitejs.dev)
- [Django Official](https://www.djangoproject.com)
- [FastAPI](https://fastapi.tiangolo.com)
- [PostgreSQL Docs](https://www.postgresql.org/docs)
- [MongoDB University](https://university.mongodb.com)
- [Web.dev Performance](https://web.dev/performance)
