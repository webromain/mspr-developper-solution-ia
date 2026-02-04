# MSPR 1 - Pipeline ETL Détaillé

**HealthAI Coach - Extraction, Transformation, Chargement de données**

---

## 1. Vue d'ensemble pipeline

Le pipeline ETL MSPR 1 automatise la collecte, validation et chargement des données depuis 3 sources CSV vers la base de données centralisée en 6 étapes séquentielles.

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         ETL PIPELINE MSPR 1                              │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ÉTAPE 1: EXTRACTION        ÉTAPE 2: NETTOYAGE      ÉTAPE 3: VALIDATION  │
│  ════════════════════       ══════════════════      ═════════════════    │
│  • Load CSV files           • Remove duplicates     • Business rules     │
│  • Parse columns            • Handle missing data   • Enum validation    │
│  • Type conversion          • Normalize text        • Range checking     │
│  • Detect encoding          • Standardize values    • Referential integrity│
│                                                                            │
│  ↓                          ↓                       ↓                    │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐             │
│  │ Raw DataFrames     │ Cleaned Data  │     │ Valid Records │            │
│  └──────────────┘     └──────────────┘     └──────────────┘             │
│                                                      │                    │
│  ÉTAPE 4: TRANSFORMATION    ÉTAPE 5: CHARGEMENT    ÉTAPE 6: REPORTING  │
│  ═════════════════════      ═══════════════════    ═════════════════    │
│  • Enrich columns           • Insert/Update DB     • Generate reports   │
│  • Calculate KPIs (BMI)     • Transaction mgmt     • Validation metrics │
│  • Join data sources        • Error recovery       • Performance stats  │
│  • Aggregate values         • Commit changes       • JSON output        │
│                                                                            │
│  ↓                          ↓                       ↓                    │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐             │
│  │ Enriched Data │     │ Persisted DB │     │ etl_report   │            │
│  │ (DataFrames) │     │ (SQLite/PG)  │     │ *.json       │            │
│  └──────────────┘     └──────────────┘     └──────────────┘             │
│                                                                            │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Sources de données

### 2.1 Source 1: `daily_food_nutrition.csv`

**Contenu:** Référence nutritionnelle (aliments & nutriments)

| Colonne   | Type    | Description        | Exemple                    |
| --------- | ------- | ------------------ | -------------------------- |
| food_id   | INT     | Identifiant unique | 1, 2, 3...                 |
| food_name | VARCHAR | Nom aliment        | "Poulet rôti", "Riz blanc" |
| calories  | INT     | Kcal par 100g      | 165, 130                   |
| protein_g | FLOAT   | Protéines (g/100g) | 31.0, 2.7                  |
| carbs_g   | FLOAT   | Glucides (g/100g)  | 0, 28.3                    |
| fat_g     | FLOAT   | Lipides (g/100g)   | 3.6, 0.3                   |
| fiber_g   | FLOAT   | Fibres (g/100g)    | 0, 0.4                     |
| sodium_mg | INT     | Sodium (mg/100g)   | 75, 1                      |

**Utilisation:** Référence pour calculer apports nutritionnels utilisateurs

---

### 2.2 Source 2: `gym_members_exercise.csv`

**Contenu:** Historique sessions gym membres

| Colonne          | Type    | Description         | Exemple                 |
| ---------------- | ------- | ------------------- | ----------------------- |
| member_id        | INT     | Identifiant membre  | 101, 102...             |
| session_date     | DATE    | Date session        | 2025-06-15              |
| duration_min     | INT     | Durée (minutes)     | 45, 60                  |
| calories_burned  | INT     | Calories brûlées    | 320, 450                |
| workout_type     | VARCHAR | Type entraînement   | "Cardio", "Musculation" |
| heart_rate_bpm   | INT     | Fréquence cardiaque | 145, 160                |
| fat_percentage   | FLOAT   | % masse grasse      | 18.5, 22.3              |
| water_intake_l   | FLOAT   | Eau bue (litres)    | 1.5, 2.0                |
| experience_level | VARCHAR | Niveau expérience   | "Débutant", "Avancé"    |

**Utilisation:** Sessions gym individuelles pour profil activité

---

### 2.3 Source 3: `diet_recommendations.csv`

**Contenu:** Recommandations nutritionnelles par profil utilisateur

| Colonne        | Type    | Description          | Exemple                        |
| -------------- | ------- | -------------------- | ------------------------------ |
| profile_id     | INT     | Profil utilisateur   | 1, 2...                        |
| gender         | VARCHAR | Genre                | "M", "F"                       |
| age_range      | VARCHAR | Tranche âge          | "25-35", "35-45"               |
| diet_type      | VARCHAR | Type régime          | "Équilibré", "Gain musculaire" |
| daily_calories | INT     | Kcal recommandées    | 2500, 3200                     |
| protein_pct    | FLOAT   | % calories protéines | 30, 35                         |
| carbs_pct      | FLOAT   | % calories glucides  | 45, 40                         |
| fat_pct        | FLOAT   | % calories lipides   | 25, 25                         |
| restrictions   | VARCHAR | Restrictions         | "Sans gluten", "Végan"         |

**Utilisation:** Recommandations de régime pour chaque patient

---

## 3. Étapes du pipeline

### 3.1 ÉTAPE 1: Extraction

**Objectif:** Charger données brutes depuis CSV → DataFrames Python

**Code (Pipelines/pipeline.py):**

```python
def extract_data():
    """Charge 3 CSV sources avec gestion d'erreurs."""

    # Configuration sources
    sources = {
        'nutrition': 'daily_food_nutrition.csv',
        'gym': 'gym_members_exercise.csv',
        'diet': 'diet_recommendations.csv'
    }

    data = {}

    for name, filepath in sources.items():
        try:
            # Détection auto encoding
            df = pd.read_csv(filepath, encoding='utf-8')
            logger.info(f"✓ Loaded {name}: {len(df)} rows, {len(df.columns)} columns")
            data[name] = df

        except FileNotFoundError:
            logger.error(f"✗ File not found: {filepath}")
            raise
        except pd.errors.ParserError as e:
            logger.error(f"✗ Parse error {name}: {str(e)}")
            raise

    return data
```

**Validations:**

- ✓ Fichier existe
- ✓ Format CSV valide
- ✓ Colonnes attendues présentes
- ✓ Encoding détecté (UTF-8, Latin-1, etc.)

**Entrées:** Fichiers CSV
**Sorties:** Dictionnaire DataFrames Pandas

---

### 3.2 ÉTAPE 2: Nettoyage

**Objectif:** Préparer données brutes pour validation métier

**Opérations:**

#### A. Suppression doublons

```python
def clean_duplicates(df, subset=None):
    """Supprime doublons en conservant première occurrence."""
    initial_rows = len(df)
    df_clean = df.drop_duplicates(subset=subset, keep='first')
    removed = initial_rows - len(df_clean)
    logger.info(f"Removed {removed} duplicate rows")
    return df_clean
```

#### B. Gestion valeurs manquantes

```python
def handle_missing_values(df):
    """Traite NaN/None selon stratégie par colonne."""
    strategies = {
        'numeric': 'mean',      # Remplir par moyenne
        'categorical': 'mode',  # Remplir par mode
        'critical': 'drop'      # Supprimer lignes
    }

    for col in df.columns:
        if df[col].isnull().any():
            if col in ['age', 'weight_kg']:  # Critique
                df = df.dropna(subset=[col])
            elif df[col].dtype in ['int64', 'float64']:
                df[col].fillna(df[col].mean(), inplace=True)
            else:
                df[col].fillna(df[col].mode()[0] if len(df[col].mode()) > 0 else 'Unknown', inplace=True)

    return df
```

#### C. Normalisation types

```python
def normalize_types(df):
    """Convertit colonnes aux types attendus."""
    type_mapping = {
        'patient_id': 'int32',
        'age': 'int16',
        'weight_kg': 'float32',
        'calories': 'int32',
        'session_date': 'datetime64[ns]'
    }

    for col, dtype in type_mapping.items():
        if col in df.columns:
            try:
                df[col] = df[col].astype(dtype)
            except ValueError as e:
                logger.warning(f"Type conversion failed {col}: {e}")

    return df
```

#### D. Standardisation valeurs texte

```python
def standardize_text(df):
    """Normalise texte (casse, espaces, accents)."""
    text_cols = df.select_dtypes(include='object').columns

    for col in text_cols:
        df[col] = df[col].str.strip().str.lower().str.normalize('NFD')

    return df
```

**Sorties:** DataFrames nettoyés, rapport nettoyage

---

### 3.3 ÉTAPE 3: Validation

**Objectif:** Vérifier conformité données versus règles métier

**Règles par table (Pipelines/rules.py):**

```python
VALIDATION_RULES = {
    'patient': {
        'age': {'min': 18, 'max': 120, 'type': 'int'},
        'gender': {'allowed': ['M', 'F', 'Autre'], 'type': 'str'},
        'weight_kg': {'min': 30, 'max': 300, 'type': 'float'},
        'height_cm': {'min': 100, 'max': 250, 'type': 'float'},
    },
    'sante': {
        'cholesterol': {'min': 100, 'max': 400, 'type': 'int'},
        'glucose': {'min': 50, 'max': 300, 'type': 'int'},
        'severity': {'allowed': ['Critique', 'Élevé', 'Modéré', 'Faible', 'Sain']},
    },
    'nutrition': {
        'daily_caloric_intake': {'min': 800, 'max': 5000, 'type': 'int'},
        'adherence_to_diet_plan': {'min': 0, 'max': 100, 'type': 'float'},
    },
    'gym_session': {
        'duration': {'min': 1, 'max': 480, 'type': 'int'},
        'BPM': {'min': 40, 'max': 220, 'type': 'int'},
        'fat_percentage': {'min': 0, 'max': 100, 'type': 'float'},
    }
}
```

**Validator (Pipelines/validators.py):**

```python
def validate_record(record, rules):
    """Valide un enregistrement contre règles métier."""
    errors = []

    for field, value in record.items():
        if field not in rules:
            continue

        rule = rules[field]

        # Validation type
        if 'type' in rule and value is not None:
            if not isinstance(value, eval(rule['type'])):
                errors.append(f"Type error: {field} expected {rule['type']}")

        # Validation range
        if 'min' in rule and value < rule['min']:
            errors.append(f"Range error: {field} < {rule['min']}")
        if 'max' in rule and value > rule['max']:
            errors.append(f"Range error: {field} > {rule['max']}")

        # Validation énumération
        if 'allowed' in rule and value not in rule['allowed']:
            errors.append(f"Value error: {field} not in {rule['allowed']}")

    return errors
```

**Rapport validation (Pipelines/metrics.py):**

```python
def generate_validation_report(df, table_name, errors_dict):
    """Génère rapport validation avec statistiques."""

    total_records = len(df)
    valid_records = sum(1 for e in errors_dict.values() if len(e) == 0)
    error_rate = (total_records - valid_records) / total_records * 100

    report = {
        'table': table_name,
        'total_records': total_records,
        'valid_records': valid_records,
        'error_rate_pct': round(error_rate, 2),
        'severity_distribution': {
            'ERROR': len([e for v in errors_dict.values() for e in v if 'error' in e.lower()]),
            'WARNING': len([e for v in errors_dict.values() for e in v if 'warning' in e.lower()]),
        }
    }

    return report
```

**Sorties:** Enregistrements valides, rapport erreurs, audit trail

---

### 3.4 ÉTAPE 4: Transformation

**Objectif:** Enrichir et formater données pour chargement DB

**Transformations (Pipelines/transformers.py):**

#### A. Calcul BMI

```python
def calculate_bmi(df):
    """Calcule IMC à partir poids/taille."""
    df['bmi'] = df['weight_kg'] / ((df['height_cm'] / 100) ** 2)
    df['bmi'] = df['bmi'].round(2)
    return df
```

#### B. Normalisation catégories

```python
def normalize_categories(df):
    """Normalise valeurs catégorielles."""
    # Gender standardization
    gender_map = {'male': 'M', 'homme': 'M', 'female': 'F', 'femme': 'F'}
    df['gender'] = df['gender'].map(gender_map).fillna(df['gender'])

    # Workout type standardization
    workout_map = {
        'cardio training': 'Cardio',
        'strength training': 'Musculation',
        'yoga': 'Yoga',
    }
    df['workout_type'] = df['workout_type'].map(workout_map).fillna(df['workout_type'])

    return df
```

#### C. Join données sources

```python
def enrich_with_nutrition_reference(gym_df, nutrition_df):
    """Joint données gym avec référence nutritionnelle."""
    enriched = gym_df.merge(
        nutrition_df[['food_name', 'calories', 'protein_g', 'carbs_g']],
        left_on='meal_name',
        right_on='food_name',
        how='left'
    )
    return enriched
```

#### D. Agrégation pour KPIs

```python
def aggregate_patient_metrics(gym_sessions_df):
    """Agrège sessions gym par patient."""
    agg_df = gym_sessions_df.groupby('patient_id').agg({
        'duration': 'sum',  # Total heures exercice
        'calories_burned': 'mean',  # Moyenne calories/session
        'BPM': 'mean',  # Fréquence cardiaque moyenne
        'session_id': 'count'  # Nombre sessions
    }).rename(columns={'session_id': 'session_count'})

    return agg_df
```

**Sorties:** DataFrames transformés prêts insertion

---

### 3.5 ÉTAPE 5: Chargement

**Objectif:** Persister données transformées en base de données

**Configuration connexion:**

```python
from sqlalchemy import create_engine

def get_db_engine():
    """Crée connexion SQLAlchemy."""
    # Dev: SQLite
    engine = create_engine('sqlite:///healthai_coach.db')

    # Prod: PostgreSQL
    # engine = create_engine('postgresql://user:password@localhost:5432/healthai_prod')

    return engine
```

**Chargement données:**

```python
def load_to_database(df, table_name, engine, if_exists='append'):
    """Insère DataFrame en base de données."""

    try:
        with engine.begin() as conn:  # Transaction managée
            # Supprimer doublons avant insertion
            if if_exists == 'append':
                # Garder data existante, ajouter nouveaux enregistrements
                df.to_sql(table_name, conn, if_exists='append', index=False)
            else:
                # Remplacer complètement
                df.to_sql(table_name, conn, if_exists='replace', index=False)

        logger.info(f"✓ Loaded {len(df)} rows into {table_name}")
        return True

    except Exception as e:
        logger.error(f"✗ Load failed for {table_name}: {str(e)}")
        raise
```

**Gestion transactions:**

```python
def load_all_tables(transformed_data, engine):
    """Charge toutes tables en transaction atomique."""

    try:
        with engine.begin() as conn:  # Transaction multi-table

            # Ordre charge: dépendances FK
            load_order = ['patient', 'sante', 'nutrition', 'activite_physique', 'gym_session']

            for table_name in load_order:
                if table_name in transformed_data:
                    df = transformed_data[table_name]
                    df.to_sql(table_name, conn, if_exists='append', index=False)
                    logger.info(f"✓ {table_name}: {len(df)} rows")

        logger.info("✓ All tables loaded successfully (transaction committed)")

    except Exception as e:
        logger.error(f"✗ Transaction rollback: {str(e)}")
        raise  # Rollback automatique
```

**Sorties:** Données persistées DB, logs success/errors

---

### 3.6 ÉTAPE 6: Reporting

**Objectif:** Générer rapports métriques de qualité & performance

**Rapport JSON (Pipelines/metrics.py):**

```python
def generate_etl_report(extraction_metrics, cleaning_metrics,
                        validation_metrics, transformation_metrics,
                        load_metrics, execution_time):
    """Génère rapport ETL complet."""

    report = {
        'execution_datetime': datetime.now().isoformat(),
        'execution_time_seconds': execution_time,
        'status': 'SUCCESS' if load_metrics['success'] else 'FAILED',

        'extraction': {
            'files_loaded': extraction_metrics['files_count'],
            'total_rows_extracted': extraction_metrics['total_rows'],
            'encoding_detected': extraction_metrics['encoding']
        },

        'cleaning': {
            'duplicates_removed': cleaning_metrics['duplicates'],
            'missing_values_filled': cleaning_metrics['missing'],
            'type_conversions': cleaning_metrics['type_conversions']
        },

        'validation': {
            'total_records': validation_metrics['total'],
            'valid_records': validation_metrics['valid'],
            'error_rate_pct': validation_metrics['error_rate'],
            'errors_by_severity': validation_metrics['errors_by_severity']
        },

        'transformation': {
            'kpis_calculated': transformation_metrics['kpis'],
            'values_normalized': transformation_metrics['normalized'],
            'joins_executed': transformation_metrics['joins']
        },

        'loading': {
            'tables_loaded': load_metrics['tables'],
            'total_rows_loaded': load_metrics['total_rows'],
            'load_time_seconds': load_metrics['duration']
        }
    }

    return report
```

**Sauvegarde rapport:**

```python
def save_report_to_file(report):
    """Sauvegarde rapport JSON avec timestamp."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filepath = f"reports/etl_report_{timestamp}.json"

    os.makedirs('reports', exist_ok=True)

    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)

    logger.info(f"Report saved: {filepath}")
    return filepath
```

**Exemple rapport généré:**

```json
{
  "execution_datetime": "2026-02-04T14:47:57.123456",
  "execution_time_seconds": 45.3,
  "status": "SUCCESS",
  "extraction": {
    "files_loaded": 3,
    "total_rows_extracted": 15240,
    "encoding_detected": "utf-8"
  },
  "cleaning": {
    "duplicates_removed": 23,
    "missing_values_filled": 145,
    "type_conversions": 8450
  },
  "validation": {
    "total_records": 15217,
    "valid_records": 14892,
    "error_rate_pct": 2.14,
    "errors_by_severity": {
      "ERROR": 0,
      "WARNING": 325
    }
  },
  "transformation": {
    "kpis_calculated": 125,
    "values_normalized": 8920,
    "joins_executed": 3
  },
  "loading": {
    "tables_loaded": 5,
    "total_rows_loaded": 14892,
    "load_time_seconds": 12.4
  }
}
```

---

## 4. Orchestration pipeline

### 4.1 Script principal (Pipelines/pipeline.py)

```python
def run_etl_pipeline():
    """Orchestration principale 6 étapes."""

    start_time = time.time()
    metrics = {}

    try:
        # ÉTAPE 1
        logger.info("=== ÉTAPE 1: EXTRACTION ===")
        raw_data = extract_data()
        metrics['extraction'] = measure_extraction(raw_data)

        # ÉTAPE 2
        logger.info("=== ÉTAPE 2: NETTOYAGE ===")
        cleaned_data = {k: clean_duplicates(handle_missing_values(v))
                       for k, v in raw_data.items()}
        metrics['cleaning'] = measure_cleaning(raw_data, cleaned_data)

        # ÉTAPE 3
        logger.info("=== ÉTAPE 3: VALIDATION ===")
        validated_data, errors = validate_all_tables(cleaned_data)
        metrics['validation'] = measure_validation(validated_data, errors)

        # ÉTAPE 4
        logger.info("=== ÉTAPE 4: TRANSFORMATION ===")
        transformed_data = transform_all_tables(validated_data)
        metrics['transformation'] = measure_transformation(transformed_data)

        # ÉTAPE 5
        logger.info("=== ÉTAPE 5: CHARGEMENT ===")
        engine = get_db_engine()
        load_all_tables(transformed_data, engine)
        metrics['loading'] = {'success': True}

        # ÉTAPE 6
        logger.info("=== ÉTAPE 6: REPORTING ===")
        execution_time = time.time() - start_time
        report = generate_etl_report(metrics['extraction'], metrics['cleaning'],
                                     metrics['validation'], metrics['transformation'],
                                     metrics['loading'], execution_time)
        save_report_to_file(report)

        logger.info(f"✓ ETL Pipeline completed successfully ({execution_time:.1f}s)")
        return True

    except Exception as e:
        logger.error(f"✗ ETL Pipeline failed: {str(e)}")
        return False

if __name__ == '__main__':
    run_etl_pipeline()
```

### 4.2 Exécution programmée (Cron)

```bash
# Exécuter pipeline quotidiennement à 2h du matin
0 2 * * * cd /path/to/project && python -m Pipelines.pipeline >> etl.log 2>&1
```

---

## 5. Gestion d'erreurs & recovery

### 5.1 Stratégie retry

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=4, max=10))
def load_to_database_with_retry(df, table_name, engine):
    """Réessaye 3 fois avant failover."""
    return load_to_database(df, table_name, engine)
```

### 5.2 Rollback transaction

```python
def load_with_rollback(transformed_data, engine):
    """Charge avec rollback en cas erreur."""

    try:
        with engine.begin() as conn:
            for table_name in transformed_data.keys():
                transformed_data[table_name].to_sql(table_name, conn, if_exists='append')

    except Exception as e:
        logger.error(f"Load failed, rolling back: {str(e)}")
        # Transaction rollback automatique (context manager)
        raise
```

---

## 6. Monitoring & performance

### 6.1 Métriques collectées

| Métrique                | Unité    | Seuil alerte |
| ----------------------- | -------- | ------------ |
| Temps extraction        | secondes | > 60s        |
| Taux doublons           | %        | > 5%         |
| Taux erreurs validation | %        | > 3%         |
| Temps chargement        | secondes | > 120s       |
| Taille données          | MB       | > 1000 MB    |

### 6.2 Logs structurés

```python
import logging

logger = logging.getLogger('etl_pipeline')
handler = logging.FileHandler('logs/etl_pipeline.log')
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - [%(funcName)s] - %(message)s'
)
handler.setFormatter(formatter)
logger.addHandler(handler)
```

---

## 7. Évolution MSPR 2

Le pipeline MSPR 1 sera étendu avec:

- **Micro-service IA** qui consomme données nettoyées pour recommandations
- **Augmentation volume données** (100M+ enregistrements gym)
- **Streaming temps réel** (Kafka) pour sessions gym en direct
- **Partitioning & sharding** base données

---

## 8. Références

- [Architecture MSPR 1](MSPR1_Architecture.md)
- [Modèle de Données](MSPR1_DataModel.md)
- [Code source](../../Pipelines/)
- [Rapports ETL](../../reports/)
