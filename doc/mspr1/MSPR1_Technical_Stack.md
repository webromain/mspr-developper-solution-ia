# MSPR 1 - Stack Technique & Déploiement

**HealthAI Coach - Infrastructure, dépendances, et déploiement**

---

## 1. Architecture infrastructure

```
┌────────────────────────────────────────────────────────────────────┐
│                          UTILISATEURS                              │
│                      (Web + Mobile Browser)                         │
└──────────────────────────┬─────────────────────────────────────────┘
                           │ HTTPS:443
                    ┌──────▼──────┐
                    │ CloudFront  │  (CDN, Cache)
                    │ (AWS)       │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼────────┐  ┌──────▼──────┐  ┌───────▼────────┐
│ Frontend SPA   │  │  API        │  │  Static        │
│ React 19       │  │  Django     │  │  Assets        │
│ (S3 + Cache)   │  │  (ELB)      │  │  (S3 + Cache)  │
└────────────────┘  └──────┬──────┘  └────────────────┘
                           │
                    ┌──────▼──────────┐
                    │  Load Balancer  │
                    │  (AWS ALB)      │
                    └──────┬──────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼────┐      ┌──────▼──────┐    ┌─────▼────┐
   │ Django  │      │  Django     │    │ Django   │
   │ Gunicorn│      │ Gunicorn    │    │ Gunicorn │
   │ (8000)  │      │ (8000)      │    │ (8000)   │
   │ - Pod 1 │      │ - Pod 2     │    │ - Pod N  │
   └────┬────┘      └──────┬──────┘    └─────┬────┘
        └──────────────────┼─────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼────────┐   ┌─────▼────┐    ┌──────▼─────┐
   │  RDS        │   │ MongoDB   │    │   Redis    │
   │ PostgreSQL  │   │           │    │   Cache    │
   │ (Primary +  │   │ (Document │    │ (Session + │
   │  Standby)   │   │  Store)   │    │  Cache)    │
   └─────────────┘   └───────────┘    └────────────┘
```

---

## 2. Stack Frontend

### 2.1 Dépendances Node.js

**File: `frontend/package.json`**

```json
{
  "name": "healthai-coach-frontend",
  "version": "1.0.0",
  "description": "HealthAI Coach - Frontend React 19 + Vite",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint src --ext .jsx,.js",
    "format": "prettier --write \"src/**/*.{jsx,js,css}\""
  },
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "react-router-dom": "^6.20.0",
    "axios": "^1.6.0",
    "chart.js": "^4.4.0",
    "react-chartjs-2": "^5.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.0",
    "vite": "^5.0.0",
    "eslint": "^8.55.0",
    "eslint-plugin-react": "^7.33.0",
    "prettier": "^3.1.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
```

**Installation:**

```bash
cd frontend
npm install
npm run build    # Production build
npm run dev      # Développement
```

### 2.2 Configuration Vite

**File: `frontend/vite.config.js`**

```javascript
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      "/api": {
        target: "http://localhost:8000",
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, "/api"),
      },
    },
  },
  build: {
    outDir: "dist",
    sourcemap: false,
    minify: "terser",
    rollupOptions: {
      output: {
        manualChunks: {
          chart: ["chart.js", "react-chartjs-2"],
          router: ["react-router-dom"],
        },
      },
    },
  },
});
```

### 2.3 Optimisations production

- **Code splitting:** Chunks séparés (vendor, router, chart)
- **Tree shaking:** Suppression code mort
- **CSS minification:** Assets optimisés
- **Lazy loading:** Images & routes chargées à la demande

---

## 3. Stack Backend

### 3.1 Dépendances Python

**File: `requirements.txt`**

```
# Django & REST API
Django==4.2.9
djangorestframework==3.14.0
django-cors-headers==4.3.1
django-filter==23.5
django-ratelimit==4.1.0

# Database
psycopg2-binary==2.9.9
pymongo==4.6.0
sqlalchemy==2.0.23

# Data Processing
pandas==2.1.4
numpy==1.26.3
scipy==1.11.4

# Task Queue & Cache
celery==5.3.4
redis==5.0.1

# Big Data (Optional)
pyspark==3.5.0

# Utilities
python-dotenv==1.0.0
requests==2.31.0
PyYAML==6.0.1

# Testing
pytest==7.4.3
pytest-django==4.7.0
pytest-cov==4.1.0

# Logging & Monitoring
python-json-logger==2.0.7
sentry-sdk==1.39.1

# Production
gunicorn==21.2.0
whitenoise==6.6.0
```

**Installation:**

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 3.2 Configuration Django

**File: `backend/config/settings.py` (extraits clés)**

```python
import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent

# Security
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'dev-key-insecure')
DEBUG = os.getenv('DEBUG', 'False') == 'True'
ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', 'localhost,127.0.0.1').split(',')

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'api',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
]

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('POSTGRES_DB', 'healthai_coach'),
        'USER': os.getenv('POSTGRES_USER', 'postgres'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD', 'password'),
        'HOST': os.getenv('POSTGRES_HOST', 'localhost'),
        'PORT': os.getenv('POSTGRES_PORT', '5432'),
    }
}

# Cache
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': os.getenv('REDIS_URL', 'redis://127.0.0.1:6379/1'),
    }
}

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
    'DEFAULT_FILTER_BACKENDS': ['django_filters.rest_framework.DjangoFilterBackend'],
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.UserRateThrottle'
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': '100/hour',
        'user': '1000/hour'
    }
}

# CORS
CORS_ALLOWED_ORIGINS = os.getenv('CORS_ALLOWED_ORIGINS', 'http://localhost:5173').split(',')

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
}
```

### 3.3 URLs et routing

**File: `backend/config/urls.py`**

```python
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from api.views import (
    PatientViewSet, SanteViewSet, NutritionViewSet,
    ActivitePhysiqueViewSet, GymSessionViewSet,
    KPISanteView, KPIEngagementView, KPIConversionView, KPISatisfactionView
)

router = DefaultRouter()
router.register(r'patients', PatientViewSet)
router.register(r'sante', SanteViewSet)
router.register(r'nutrition', NutritionViewSet)
router.register(r'activite', ActivitePhysiqueViewSet)
router.register(r'gym-sessions', GymSessionViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('api/kpis/health', KPISanteView.as_view(), name='kpi-health'),
    path('api/kpis/engagement', KPIEngagementView.as_view(), name='kpi-engagement'),
    path('api/kpis/conversion', KPIConversionView.as_view(), name='kpi-conversion'),
    path('api/kpis/satisfaction', KPISatisfactionView.as_view(), name='kpi-satisfaction'),
]
```

---

## 4. Stack Données

### 4.1 PostgreSQL

**Configuration connexion:**

```bash
# Environment variables
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=healthai_coach
POSTGRES_USER=postgres
POSTGRES_PASSWORD=secure_password
```

**Initialisation schéma:**

```bash
# Migrations Django
python manage.py migrate

# Créer superuser
python manage.py createsuperuser
```

### 4.2 MongoDB (Cache document)

**Connection:**

```python
from pymongo import MongoClient

mongo_client = MongoClient(os.getenv('MONGODB_URL', 'mongodb://localhost:27017'))
db = mongo_client['healthai_coach']

# Collections
recommendations = db['recommendations']
user_preferences = db['user_preferences']
```

### 4.3 Redis (Cache session)

**Configuration:**

```python
import redis

redis_client = redis.from_url(
    os.getenv('REDIS_URL', 'redis://localhost:6379/1'),
    decode_responses=True
)

# Utilisation
redis_client.set('key', 'value', ex=3600)  # Expire 1h
value = redis_client.get('key')
```

---

## 5. Containerization Docker

### 5.1 Docker Compose

**File: `docker-compose.yml`**

```yaml
version: "3.8"

services:
  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: healthai-frontend
    ports:
      - "5173:5173"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - VITE_API_URL=http://localhost:8000/api
    command: npm run dev
    networks:
      - healthai-network

  # Backend
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: healthai-backend
    ports:
      - "8000:8000"
    volumes:
      - ./backend:/app
    environment:
      - DEBUG=True
      - DJANGO_SECRET_KEY=dev-secret-key
      - DATABASE_URL=postgresql://postgres:password@db:5432/healthai_coach
      - REDIS_URL=redis://redis:6379/1
      - MONGODB_URL=mongodb://mongo:27017
    depends_on:
      - db
      - redis
      - mongo
    command: python manage.py runserver 0.0.0.0:8000
    networks:
      - healthai-network

  # PostgreSQL
  db:
    image: postgres:15-alpine
    container_name: healthai-postgres
    environment:
      POSTGRES_DB: healthai_coach
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - healthai-network

  # MongoDB
  mongo:
    image: mongo:7.0
    container_name: healthai-mongo
    environment:
      MONGO_INITDB_DATABASE: healthai_coach
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    networks:
      - healthai-network

  # Redis
  redis:
    image: redis:7-alpine
    container_name: healthai-redis
    ports:
      - "6379:6379"
    networks:
      - healthai-network

volumes:
  postgres_data:
  mongo_data:

networks:
  healthai-network:
    driver: bridge
```

### 5.2 Dockerfile Backend

**File: `backend/Dockerfile`**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Dépendances système
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Code source
COPY . .

# Migrations
RUN python manage.py collectstatic --noinput

# Gunicorn production
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "config.wsgi:application"]
```

### 5.3 Dockerfile Frontend

**File: `frontend/Dockerfile`**

```dockerfile
# Build stage
FROM node:18-alpine as builder

WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

# Runtime stage
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**File: `frontend/nginx.conf`**

```nginx
server {
    listen 80;
    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }
    location /api/ {
        proxy_pass http://backend:8000;
    }
}
```

### 5.4 Utilisation

```bash
# Démarrer tous les services
docker-compose up -d

# Logs
docker-compose logs -f backend

# Arrêter
docker-compose down

# Rebuild après modification
docker-compose up -d --build
```

---

## 6. Déploiement production

### 6.1 AWS Architecture

```
Frontend (S3 + CloudFront)
        ↓
        Load Balancer (ALB)
        ↓
    [Auto Scaling Group]
    ├── EC2 (Django + Gunicorn) × N
    ├── RDS (PostgreSQL Multi-AZ)
    ├── ElastiCache (Redis)
    └── DocumentDB (MongoDB compatible)
```

### 6.2 Infrastructure as Code (Terraform)

```hcl
# Production VPC
resource "aws_vpc" "healthai" {
  cidr_block = "10.0.0.0/16"
}

# RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  allocated_storage    = 100
  engine              = "postgres"
  engine_version      = "15.4"
  instance_class      = "db.t3.medium"
  multi_az            = true
  publicly_accessible = false
}

# Load Balancer
resource "aws_lb" "main" {
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# Auto Scaling Group
resource "aws_autoscaling_group" "backend" {
  launch_configuration = aws_launch_configuration.backend.id
  min_size             = 2
  max_size             = 10
  desired_capacity     = 3
}
```

### 6.3 Déploiement CI/CD

**File: `.github/workflows/deploy.yml`**

```yaml
name: Deploy Production

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Build Frontend
        run: |
          cd frontend
          npm install
          npm run build

      - name: Build Backend Docker
        run: docker build -t healthai-backend:${{ github.sha }} ./backend

      - name: Push to ECR
        run: |
          aws ecr get-login-password | docker login --username AWS --password-stdin ${{ secrets.AWS_ECR_URI }}
          docker tag healthai-backend:${{ github.sha }} ${{ secrets.AWS_ECR_URI }}/healthai-backend:${{ github.sha }}
          docker push ${{ secrets.AWS_ECR_URI }}/healthai-backend:${{ github.sha }}

      - name: Update ECS Service
        run: |
          aws ecs update-service --cluster healthai-prod --service healthai-backend \
            --force-new-deployment --region us-east-1
```

---

## 7. Monitoring & Logging

### 7.1 Application Insights

```python
# Sentry (Error tracking)
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration

sentry_sdk.init(
    dsn=os.getenv('SENTRY_DSN'),
    integrations=[DjangoIntegration()],
    traces_sample_rate=0.1,
    environment="production"
)
```

### 7.2 CloudWatch Logs

```python
import logging
from pythonjsonlogger import jsonlogger

logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter()
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)
```

---

## 8. Checklist déploiement

- [ ] Variables d'environnement configurées
- [ ] Migrations BD exécutées
- [ ] Tests unitaires passent (pytest)
- [ ] Build frontend optimisé (npm run build)
- [ ] Dockerfile testé localement
- [ ] docker-compose up réussit
- [ ] CORS configuré pour domaines production
- [ ] HTTPS/TLS certificats
- [ ] Backups BD configurés
- [ ] Monitoring & alertes actifs
- [ ] Documentation API déployée

---

## 9. Références

- [Architecture MSPR 1](MSPR1_Architecture.md)
- [Modèle de Données](MSPR1_DataModel.md)
- [API OpenAPI](../api-specs/MSPR1_API_OpenAPI.yaml)
- [Docker Documentation](https://docs.docker.com/)
- [Django Documentation](https://docs.djangoproject.com/)
