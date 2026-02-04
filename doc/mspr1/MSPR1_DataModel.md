# MSPR 1 - Modèle de Données

**HealthAI Coach - Schéma de base de données relationnelle**

---

## 1. Diagramme Entité-Relation (MCD)

```
┌──────────────────────┐
│      PATIENT         │
├──────────────────────┤
│ PK: patient_id       │
│ age (INT)            │
│ gender (VARCHAR)     │
│ weight_kg (FLOAT)    │
│ height_cm (FLOAT)    │
│ bmi (FLOAT)          │
│ created_at (DATE)    │
│ updated_at (DATE)    │
└──────────────┬───────┘
               │
    ┌──────────┴──────────┬──────────────┬──────────────┐
    │                     │              │              │
    ↓ 1:1 UNIQUE          ↓ 1:1 UNIQUE   ↓ 1:1 UNIQUE   ↓ 1:1 UNIQUE
┌──────────┐         ┌──────────┐  ┌──────────┐   ┌──────────┐
│  SANTE   │         │NUTRITION │  │ACTIVITE_ │   │ACTIVITE_ │
│          │         │          │  │PHYSIQUE  │   │          │
├──────────┤         ├──────────┤  ├──────────┤   ├──────────┤
│ sante_id │         │nutr_id   │  │activ_id  │   │           │
│ patient  │ ←──+──→ │ patient  │  │ patient  │   │           │
│ id (FK)  │    U    │ id (FK)  │  │ id (FK)  │   │           │
│          │         │          │  │          │   │           │
│cholest.  │         │caloric   │  │activity  │   │           │
│blood_pr. │         │dietary_r │  │level     │   │           │
│disease   │         │allergies │  │exercise_ │   │           │
│glucose   │         │adherence │  │hours     │   │           │
│severity  │         │          │  │          │   │           │
└──────────┘         └──────────┘  └──────────┘   └──────────┘
                                           │
                                           ↓ 1:∞
                                    ┌──────────────┐
                                    │ GYM_SESSION  │
                                    ├──────────────┤
                                    │ session_id   │
                                    │ patient_id   │ (FK)
                                    │ duration     │
                                    │ calories_bn  │
                                    │ workout_type │
                                    │ BPM          │
                                    │ fat_%        │
                                    │ water_intake │
                                    │ experience   │
                                    │ session_date │
                                    └──────────────┘
```

---

## 2. Tables SQL détaillées

### 2.1 Table `patient`

**Responsabilité:** Entité racine contenant infos démographiques de base

```sql
CREATE TABLE patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    age INT NOT NULL CHECK (age >= 18 AND age <= 120),
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('M', 'F', 'Autre')),
    weight_kg FLOAT NOT NULL CHECK (weight_kg >= 30 AND weight_kg <= 300),
    height_cm FLOAT NOT NULL CHECK (height_cm >= 100 AND height_cm <= 250),
    bmi FLOAT GENERATED ALWAYS AS (ROUND(weight_kg / ((height_cm/100) * (height_cm/100)), 2)) STORED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);
```

**Champs:**

- `patient_id` - Identifiant unique auto-incrémenté (PK)
- `age` - Âge en années (18-120 ans)
- `gender` - M, F, Autre
- `weight_kg` - Poids en kilogrammes (30-300 kg)
- `height_cm` - Taille en centimètres (100-250 cm)
- `bmi` - IMC calculé automatiquement (colonne générée)
- `created_at`, `updated_at` - Timestamps audit

**Indices:**

```sql
CREATE INDEX idx_patient_gender ON patient(gender);
CREATE INDEX idx_patient_age ON patient(age);
```

---

### 2.2 Table `sante`

**Responsabilité:** Métriques de santé liées à un patient (1:1 UNIQUE)

```sql
CREATE TABLE sante (
    sante_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL UNIQUE,
    cholesterol INT CHECK (cholesterol >= 100 AND cholesterol <= 400),
    blood_pressure VARCHAR(20) NOT NULL,  -- Format: "120/80"
    disease_type VARCHAR(100),  -- Ex: "Diabète", "Hypertension", NULL
    glucose INT CHECK (glucose >= 50 AND glucose <= 300),
    severity VARCHAR(50) CHECK (severity IN ('Critique', 'Élevé', 'Modéré', 'Faible', 'Sain')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE
);
```

**Champs:**

- `sante_id` - Identifiant unique (PK)
- `patient_id` - Clé étrangère vers patient (1:1 UNIQUE)
- `cholesterol` - Niveau cholestérol (mg/dL, 100-400)
- `blood_pressure` - Tension artérielle (format: "120/80")
- `disease_type` - Type maladie (Diabète, Hypertension, etc. ou NULL)
- `glucose` - Niveau glucose (mg/dL, 50-300)
- `severity` - Sévérité santé globale (Critique, Élevé, Modéré, Faible, Sain)

**Indices:**

```sql
CREATE INDEX idx_sante_patient_id ON sante(patient_id);
CREATE INDEX idx_sante_disease ON sante(disease_type);
CREATE INDEX idx_sante_severity ON sante(severity);
```

---

### 2.3 Table `nutrition`

**Responsabilité:** Données nutritionnelles et recommandations (1:1 UNIQUE)

```sql
CREATE TABLE nutrition (
    nutrition_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL UNIQUE,
    daily_caloric_intake INT CHECK (daily_caloric_intake >= 800 AND daily_caloric_intake <= 5000),
    dietary_restrictions VARCHAR(255),  -- JSON array ou séparé par virgules
    allergies VARCHAR(255),  -- JSON array ou séparé par virgules
    diet_recommendation VARCHAR(255),  -- Ex: "Équilibré", "Faible calories", "Riche protéines"
    adherence_to_diet_plan DECIMAL(5, 2) CHECK (adherence_to_diet_plan >= 0 AND adherence_to_diet_plan <= 100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE
);
```

**Champs:**

- `nutrition_id` - Identifiant unique (PK)
- `patient_id` - Clé étrangère vers patient (1:1 UNIQUE)
- `daily_caloric_intake` - Apport calorique quotidien (800-5000 kcal)
- `dietary_restrictions` - Restrictions (végétarien, végan, sans gluten, etc.) - JSON ou CSV
- `allergies` - Allergies alimentaires - JSON ou CSV
- `diet_recommendation` - Recommandation type (Équilibré, Faible calories, Riche protéines, etc.)
- `adherence_to_diet_plan` - % d'adhésion au plan nutritionnel (0-100%)

**Indices:**

```sql
CREATE INDEX idx_nutrition_patient_id ON nutrition(patient_id);
CREATE INDEX idx_nutrition_adherence ON nutrition(adherence_to_diet_plan);
```

---

### 2.4 Table `activite_physique`

**Responsabilité:** Profil activité physique baseline (1:1 UNIQUE)

```sql
CREATE TABLE activite_physique (
    activite_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL UNIQUE,
    physical_activity_level VARCHAR(50) CHECK (physical_activity_level IN ('Sédentaire', 'Faible', 'Modéré', 'Intense', 'Très intense')),
    weekly_exercice_hours FLOAT CHECK (weekly_exercice_hours >= 0 AND weekly_exercice_hours <= 168),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE
);
```

**Champs:**

- `activite_id` - Identifiant unique (PK)
- `patient_id` - Clé étrangère vers patient (1:1 UNIQUE)
- `physical_activity_level` - Catégorie (Sédentaire, Faible, Modéré, Intense, Très intense)
- `weekly_exercice_hours` - Heures exercice/semaine (0-168h)

**Indices:**

```sql
CREATE INDEX idx_activite_patient_id ON activite_physique(patient_id);
CREATE INDEX idx_activite_level ON activite_physique(physical_activity_level);
```

---

### 2.5 Table `gym_session`

**Responsabilité:** Sessions gym individuelles (1:∞ N-vers-1 avec patient)

```sql
CREATE TABLE gym_session (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    duration INT CHECK (duration >= 1 AND duration <= 480),  -- Minutes
    calories_burned INT CHECK (calories_burned >= 0 AND calories_burned <= 2000),
    workout_type VARCHAR(100) NOT NULL,  -- Ex: "Cardio", "Musculation", "Yoga", "Stretching"
    BPM INT CHECK (BPM >= 40 AND BPM <= 220),  -- Fréquence cardiaque
    fat_percentage DECIMAL(5, 2) CHECK (fat_percentage >= 0 AND fat_percentage <= 100),
    water_intake FLOAT CHECK (water_intake >= 0 AND water_intake <= 10),  -- Litres
    experience_level VARCHAR(50) CHECK (experience_level IN ('Débutant', 'Intermédiaire', 'Avancé', 'Expert')),
    session_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE
);
```

**Champs:**

- `session_id` - Identifiant unique (PK)
- `patient_id` - Clé étrangère vers patient (N:1)
- `duration` - Durée session en minutes (1-480)
- `calories_burned` - Calories brûlées (0-2000)
- `workout_type` - Type entraînement (Cardio, Musculation, Yoga, Stretching, etc.)
- `BPM` - Fréquence cardiaque moyenne (40-220)
- `fat_percentage` - % masse grasse mesurée (0-100%)
- `water_intake` - Hydratation (litres, 0-10)
- `experience_level` - Niveau expérience (Débutant, Intermédiaire, Avancé, Expert)
- `session_date` - Date/heure session

**Indices:**

```sql
CREATE INDEX idx_gym_session_patient_id ON gym_session(patient_id);
CREATE INDEX idx_gym_session_date ON gym_session(session_date);
CREATE INDEX idx_gym_session_workout ON gym_session(workout_type);
CREATE COMPOSITE INDEX idx_gym_patient_date ON gym_session(patient_id, session_date);
```

---

## 3. Contraintes et règles métier

| Table       | Champ          | Règle         | Justification                               |
| ----------- | -------------- | ------------- | ------------------------------------------- |
| patient     | age            | 18-120        | Majorité légale + limite biologique         |
| patient     | gender         | M, F, Autre   | Inclusif, utilisé pour calculs métaboliques |
| patient     | weight_kg      | 30-300        | Limites humaines réalistes                  |
| patient     | height_cm      | 100-250       | Limites humaines réalistes                  |
| sante       | cholesterol    | 100-400 mg/dL | Plages médicales standards                  |
| sante       | glucose        | 50-300 mg/dL  | Plages médicales standards                  |
| nutrition   | daily_calories | 800-5000 kcal | Minimum santé à maximum sportif             |
| activite    | exercise_hours | 0-168         | 0 à 7 jours × 24h                           |
| gym_session | duration       | 1-480 minutes | 1 min à 8h réalistes                        |
| gym_session | BPM            | 40-220        | Fréquence cardiaque humaine                 |

---

## 4. Diagramme de flux données

### 4.1 Flux intra-entité

```
Frontend HTTP Request
        ↓
Django ViewSet (Patient, Sante, Nutrition, etc.)
        ↓
Serializer Validation + Business Logic
        ↓
ORM Django Query
        ↓
SQL Prepared Statement (parameterized)
        ↓
Database Execution
        ↓
Result Rows ← Aggregate (JOIN, GROUP BY)
        ↓
Deserialization Python Objects
        ↓
JSON Response
        ↓
Frontend Render
```

### 4.2 Exemple requête JOIN (KPI Santé)

```sql
SELECT
    COUNT(p.patient_id) as total_patients,
    AVG(p.age) as avg_age,
    AVG(p.bmi) as avg_bmi,
    AVG(s.cholesterol) as avg_cholesterol,
    s.disease_type,
    COUNT(CASE WHEN s.severity = 'Sain' THEN 1 END) as healthy_count
FROM patient p
LEFT JOIN sante s ON p.patient_id = s.patient_id
LEFT JOIN nutrition n ON p.patient_id = n.patient_id
LEFT JOIN gym_session g ON p.patient_id = g.session_id
GROUP BY s.disease_type
ORDER BY healthy_count DESC;
```

---

## 5. Normalisation et ACID

### 5.1 Niveau normalisation

**Forme Normale 3 (3NF):**

- ✅ Pas d'attributs répétitifs (atomicité)
- ✅ Clés primaires uniques
- ✅ Clés étrangères vers données atomiques
- ✅ Pas de dépendances transitives non-clés

**Exceptions tolérées:**

- `dietary_restrictions` et `allergies` comme VARCHAR CSV ou JSON (dénormalisation utile pour performance)
- `bmi` colonne calculée (GENERATED) pour simplicité requêtes

### 5.2 Transactions ACID

```sql
START TRANSACTION;

-- 1. Insert patient
INSERT INTO patient (age, gender, weight_kg, height_cm)
VALUES (28, 'M', 75, 180);

-- 2. Récupérer patient_id généré
SET @patient_id = LAST_INSERT_ID();

-- 3. Insert données associées avec même transaction
INSERT INTO sante (patient_id, cholesterol, blood_pressure, glucose, severity)
VALUES (@patient_id, 200, '120/80', 100, 'Sain');

INSERT INTO nutrition (patient_id, daily_caloric_intake, diet_recommendation)
VALUES (@patient_id, 2500, 'Équilibré');

-- Commit ou ROLLBACK automatique en cas erreur
COMMIT;
```

---

## 6. Optimisations

### 6.1 Indexation

**Indices existants:**

- PK sur tous les IDs (BTREE automatique)
- FK indices sur patient_id (recherche rapide)
- Secondaire sur gender, age, disease_type pour filtrage

**Indices recommandés:**

```sql
-- Recherches fréquentes
CREATE INDEX idx_patient_age_gender ON patient(age, gender);
CREATE INDEX idx_sante_severity_disease ON sante(severity, disease_type);
CREATE INDEX idx_nutrition_adherence_caloric ON nutrition(adherence_to_diet_plan, daily_caloric_intake);
CREATE INDEX idx_gym_date_workout ON gym_session(session_date, workout_type);
```

### 6.2 Partitioning (pour grand volume)

```sql
-- Partition gym_session par date (RANGE)
ALTER TABLE gym_session
PARTITION BY RANGE (YEAR(session_date)) (
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

### 6.3 Caching (Redis)

```python
# Cache KPIs santé 1 heure
cache.set('kpi_health_metrics', json.dumps(metrics), timeout=3600)
# Cache patient detail 30 min
cache.set(f'patient_{patient_id}', json.dumps(data), timeout=1800)
```

---

## 7. Évolution pour MSPR 2

### 7.1 Nouvelles tables NoSQL (MongoDB)

```json
// Collections recommandations
db.recommendations.insertOne({
    _id: ObjectId(),
    patient_id: 123,
    type: "nutrition",  // ou "activity"
    algorithm: "collaborative_filtering",
    items: [
        {
            name: "Plan repas protéiné",
            score: 0.92,
            reason: "Basé sur historique...",
            generated_at: ISODate()
        }
    ]
});

// Collections session préférences
db.user_preferences.updateOne(
    { patient_id: 123 },
    { $set: {
        preferred_activities: ["Musculation", "Yoga"],
        budget_preference: "medium",
        allergies_updates: [...]
    }}
);
```

### 7.2 Adaptation schéma relationnel

```sql
-- Ajouter colonnes pour IA MSPR 2
ALTER TABLE patient ADD COLUMN ai_profile_id INT;
ALTER TABLE nutrition ADD COLUMN ml_recommendation_score FLOAT;
ALTER TABLE gym_session ADD COLUMN predicted_performance_score FLOAT;

-- Table audit pour recommandations
CREATE TABLE recommendation_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    recommendation_id VARCHAR(255),  -- ObjectId MongoDB
    feedback VARCHAR(50),  -- "liked", "ignored", "completed"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);
```

---

## 8. Dictionnaire de données complet

Voir [Data Dictionary - MSPR1_DataDictionary.csv](../schemas/MSPR1_DataDictionary.csv)

---

## 9. Références

- [Architecture MSPR 1](MSPR1_Architecture.md)
- [Pipeline ETL](MSPR1_ETL_Pipeline.md)
- [API OpenAPI](../api-specs/MSPR1_API_OpenAPI.yaml)
