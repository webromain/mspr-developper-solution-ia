"""
Pipeline ETL Principal
======================
Ce module orchestre toutes les étapes de l'ETL avec les règles métier.
"""

import pandas as pd
import numpy as np
import sqlite3
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from datetime import datetime
import json
import logging

from .rules import (
    PATIENT_RULES,
    SANTE_RULES,
    NUTRITION_RULES,
    ACTIVITE_PHYSIQUE_RULES,
    GYM_SESSION_RULES
)
from .validators import (
    DataValidator,
    ValidationReport,
    validate_all_tables,
    print_validation_summary
)
from .transformers import (
    DataTransformer,
    apply_all_transformations
)
from .metrics import (
    MetricsCalculator,
    TableStats,
    calculate_all_metrics,
    print_metrics_summary
)


# Configuration du logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class ETLPipeline:
    """
    Pipeline ETL complet avec règles métier
    
    Étapes:
    1. Extraction (chargement des CSV)
    2. Nettoyage (doublons, valeurs manquantes)
    3. Validation (règles métier)
    4. Transformation (normalisation, calculs)
    5. Chargement (SQLite)
    6. Métriques & Rapports
    """
    
    def __init__(
        self,
        data_dir: str = ".",
        db_path: str = "mspr_etl.db",
        report_dir: str = "reports"
    ):
        """
        Initialise le pipeline ETL
        
        Args:
            data_dir: Répertoire contenant les fichiers CSV
            db_path: Chemin de la base de données SQLite
            report_dir: Répertoire pour les rapports
        """
        self.data_dir = Path(data_dir)
        self.db_path = db_path
        self.report_dir = Path(report_dir)
        
        # Créer le répertoire de rapports
        self.report_dir.mkdir(exist_ok=True)
        
        # Composants du pipeline
        self.validator = DataValidator()
        self.transformer = DataTransformer()
        self.metrics_calculator = MetricsCalculator()
        
        # État du pipeline
        self.raw_data: Dict[str, pd.DataFrame] = {}
        self.cleaned_data: Dict[str, pd.DataFrame] = {}
        self.transformed_data: Dict[str, pd.DataFrame] = {}
        self.validation_reports: Dict[str, ValidationReport] = {}
        self.metrics: Dict[str, TableStats] = {}
        
        # Journal des opérations
        self.operations_log: List[Dict] = []
    
    def log_operation(self, step: str, message: str, status: str = "SUCCESS") -> None:
        """Enregistre une opération dans le journal"""
        entry = {
            "timestamp": datetime.now().isoformat(),
            "step": step,
            "message": message,
            "status": status
        }
        self.operations_log.append(entry)
        
        if status == "SUCCESS":
            logger.info(f"[{step}] {message}")
        elif status == "WARNING":
            logger.warning(f"[{step}] {message}")
        else:
            logger.error(f"[{step}] {message}")
    
    # =========================================================================
    # ÉTAPE 1: EXTRACTION
    # =========================================================================
    
    def extract(self, file_mappings: Dict[str, str] = None) -> Dict[str, pd.DataFrame]:
        """
        Charge les fichiers CSV
        
        Args:
            file_mappings: Dict {nom_source: fichier_csv}
        
        Returns:
            Dict des DataFrames chargés
        """
        print("\n" + "="*60)
        print("📥 ÉTAPE 1: EXTRACTION")
        print("="*60)
        
        if file_mappings is None:
            file_mappings = {
                "diet": "diet_recommendations.csv",
                "gym": "gym_members_exercise.csv",
                "nutrition": "daily_food_nutrition.csv"
            }
        
        for name, filename in file_mappings.items():
            filepath = self.data_dir / filename
            try:
                df = pd.read_csv(filepath)
                self.raw_data[name] = df
                self.log_operation(
                    "EXTRACT",
                    f"Chargé {filename}: {len(df)} lignes, {len(df.columns)} colonnes"
                )
            except Exception as e:
                self.log_operation(
                    "EXTRACT",
                    f"Erreur chargement {filename}: {str(e)}",
                    "ERROR"
                )
        
        return self.raw_data
    
    # =========================================================================
    # ÉTAPE 2: NETTOYAGE
    # =========================================================================
    
    def clean(self) -> Dict[str, pd.DataFrame]:
        """
        Nettoie les données brutes
        
        Returns:
            Dict des DataFrames nettoyés
        """
        print("\n" + "="*60)
        print("🧹 ÉTAPE 2: NETTOYAGE")
        print("="*60)
        
        for name, df in self.raw_data.items():
            # Supprimer les doublons
            result = self.transformer.remove_duplicates(df)
            df_clean = result.df
            
            if result.values_modified > 0:
                self.log_operation(
                    "CLEAN",
                    f"{name}: Supprimé {result.values_modified} doublons"
                )
            
            # Normaliser les strings
            result = self.transformer.normalize_string_columns(df_clean)
            df_clean = result.df
            
            if result.values_modified > 0:
                self.log_operation(
                    "CLEAN",
                    f"{name}: Normalisé {result.values_modified} valeurs string"
                )
            
            self.cleaned_data[name] = df_clean
        
        return self.cleaned_data
    
    # =========================================================================
    # ÉTAPE 3: TRANSFORMATION & NORMALISATION
    # =========================================================================
    
    def transform(self) -> Dict[str, pd.DataFrame]:
        """
        Transforme et normalise les données en tables relationnelles
        
        Returns:
            Dict des tables transformées
        """
        print("\n" + "="*60)
        print("🔄 ÉTAPE 3: TRANSFORMATION")
        print("="*60)
        
        # Récupérer les données nettoyées
        diet_df = self.cleaned_data.get("diet", pd.DataFrame()).copy()
        gym_df = self.cleaned_data.get("gym", pd.DataFrame()).copy()
        
        # Renommer les colonnes du gym pour correspondre au schéma
        gym_columns_mapping = {
            # Format avec espaces et majuscules
            'Session_Duration (hours)': 'gym_session_duration_hours',
            'Calories_Burned': 'gym_calories_burned',
            'Workout_Type': 'gym_workout_type',
            'Fat_Percentage': 'gym_fat_percentage',
            'Water_Intake (liters)': 'gym_water_intake_liters',
            'Workout_Frequency (days/week)': 'gym_workout_frequency_days_week',
            'Experience_Level': 'gym_experience_level',
            'Max_BPM': 'gym_max_bpm',
            'Avg_BPM': 'gym_avg_bpm',
            'Resting_BPM': 'gym_resting_bpm',
            # Format minuscules avec underscores
            'session_duration_hours': 'gym_session_duration_hours',
            'calories_burned': 'gym_calories_burned',
            'workout_type': 'gym_workout_type',
            'fat_percentage': 'gym_fat_percentage',
            'water_intake_liters': 'gym_water_intake_liters',
            'workout_frequency_days_week': 'gym_workout_frequency_days_week',
            'experience_level': 'gym_experience_level',
            'max_bpm': 'gym_max_bpm',
            'avg_bpm': 'gym_avg_bpm',
            'resting_bpm': 'gym_resting_bpm',
        }
        
        # Appliquer le mapping si les colonnes existent
        if not gym_df.empty:
            gym_df = gym_df.rename(columns=gym_columns_mapping)
        
        # Créer les Patient IDs si absents
        if not diet_df.empty and "Patient_ID" not in diet_df.columns:
            diet_df["Patient_ID"] = ["P" + str(i).zfill(5) for i in range(1, len(diet_df) + 1)]
        
        if not gym_df.empty and "patient_id" not in gym_df.columns:
            gym_df["patient_id"] = ["P" + str(i).zfill(5) for i in range(1, len(gym_df) + 1)]
        
        # Table PATIENT
        patient_cols = ["Patient_ID", "Age", "Gender", "Weight_kg", "Height_cm", "BMI_Calculated"]
        available_cols = [c for c in patient_cols if c in diet_df.columns]
        
        if available_cols:
            patient_df = diet_df[available_cols].copy()
            patient_df.columns = ["patient_id", "age", "gender", "weight_kg", "height_cm", "bmi_calculated"][:len(available_cols)]
            
            # Appliquer les transformations métier
            patient_df, transformations = apply_all_transformations(patient_df, "patient", self.transformer)
            self.transformed_data["patient"] = patient_df
            self.log_operation("TRANSFORM", f"Table patient: {len(patient_df)} lignes, transformations: {transformations}")
        
        # Table SANTE
        sante_cols = ["Patient_ID", "Cholesterol_mg/dL", "Blood_Pressure_mmHg", "Disease_Type", "Glucose_mg/dL", "Severity"]
        available_cols = [c for c in sante_cols if c in diet_df.columns]
        
        if available_cols:
            sante_df = diet_df[available_cols].copy()
            sante_df.columns = ["patient_id", "cholesterol", "blood_pressure", "disease_type", "glucose", "severity"][:len(available_cols)]
            sante_df, transformations = apply_all_transformations(sante_df, "sante", self.transformer)
            self.transformed_data["sante"] = sante_df
            self.log_operation("TRANSFORM", f"Table sante: {len(sante_df)} lignes")
        
        # Table NUTRITION
        nutrition_cols = ["Patient_ID", "Daily_Caloric_Intake", "Dietary_Restrictions", "Allergies", 
                         "Preferred_Cuisine", "Diet_Recommendation", "Adherence_to_Diet_Plan"]
        available_cols = [c for c in nutrition_cols if c in diet_df.columns]
        
        if available_cols:
            nutrition_df = diet_df[available_cols].copy()
            col_names = ["patient_id", "daily_caloric_intake", "dietary_restrictions", "allergies",
                        "preferred_cuisine", "diet_recommendation", "adherence_to_diet_plan"]
            nutrition_df.columns = col_names[:len(available_cols)]
            nutrition_df, transformations = apply_all_transformations(nutrition_df, "nutrition", self.transformer)
            self.transformed_data["nutrition"] = nutrition_df
            self.log_operation("TRANSFORM", f"Table nutrition: {len(nutrition_df)} lignes")
        
        # Table ACTIVITE_PHYSIQUE
        activity_cols = ["Patient_ID", "Physical_Activity_Level", "Weekly_Exercise_Hours"]
        available_cols = [c for c in activity_cols if c in diet_df.columns]
        
        if available_cols:
            activity_df = diet_df[available_cols].copy()
            activity_df.columns = ["patient_id", "physical_activity_level", "weekly_exercice_hours"][:len(available_cols)]
            activity_df, transformations = apply_all_transformations(activity_df, "activite_physique", self.transformer)
            self.transformed_data["activite_physique"] = activity_df
            self.log_operation("TRANSFORM", f"Table activite_physique: {len(activity_df)} lignes")
        
        # Table GYM_SESSION
        if not gym_df.empty and "patient_id" in gym_df.columns:
            gym_cols = ["patient_id", "gym_session_duration_hours", "gym_calories_burned", 
                       "gym_workout_type", "gym_fat_percentage", "gym_water_intake_liters",
                       "gym_workout_frequency_days_week", "gym_experience_level",
                       "gym_max_bpm", "gym_avg_bpm", "gym_resting_bpm"]
            available_cols = [c for c in gym_cols if c in gym_df.columns]
            
            gym_session_df = gym_df[available_cols].copy()
            gym_session_df, transformations = apply_all_transformations(gym_session_df, "gym_session", self.transformer)
            
            # Ajouter une clé primaire auto-générée pour Django
            gym_session_df.insert(0, 'id', range(1, len(gym_session_df) + 1))
            
            self.transformed_data["gym_session"] = gym_session_df
            self.log_operation("TRANSFORM", f"Table gym_session: {len(gym_session_df)} lignes")
        
        return self.transformed_data
    
    # =========================================================================
    # ÉTAPE 4: VALIDATION
    # =========================================================================
    
    def validate(self) -> Dict[str, ValidationReport]:
        """
        Valide les données transformées selon les règles métier
        
        Returns:
            Dict des rapports de validation
        """
        print("\n" + "="*60)
        print("✅ ÉTAPE 4: VALIDATION")
        print("="*60)
        
        self.validation_reports = validate_all_tables(self.transformed_data)
        
        for name, report in self.validation_reports.items():
            status = "SUCCESS" if report.error_count == 0 else "WARNING"
            self.log_operation(
                "VALIDATE",
                f"{name}: {report.validation_rate:.1f}% valide, {report.error_count} erreurs, {report.warning_count} warnings",
                status
            )
        
        # Afficher le résumé
        print_validation_summary(self.validation_reports)
        
        return self.validation_reports
    
    # =========================================================================
    # ÉTAPE 5: CHARGEMENT
    # =========================================================================
    
    def load(self, if_exists: str = "replace") -> bool:
        """
        Charge les données dans SQLite
        
        Args:
            if_exists: Comportement si la table existe ('replace', 'append', 'fail')
        
        Returns:
            True si succès
        """
        print("\n" + "="*60)
        print("💾 ÉTAPE 5: CHARGEMENT")
        print("="*60)
        
        try:
            conn = sqlite3.connect(self.db_path)
            
            for table_name, df in self.transformed_data.items():
                df.to_sql(table_name, conn, if_exists=if_exists, index=False)
                self.log_operation(
                    "LOAD",
                    f"Table {table_name}: {len(df)} lignes chargées dans {self.db_path}"
                )
            
            conn.close()
            return True
        
        except Exception as e:
            self.log_operation("LOAD", f"Erreur: {str(e)}", "ERROR")
            return False
    
    # =========================================================================
    # ÉTAPE 6: MÉTRIQUES
    # =========================================================================
    
    def calculate_metrics(self) -> Dict[str, TableStats]:
        """
        Calcule les métriques pour toutes les tables
        
        Returns:
            Dict des statistiques par table
        """
        print("\n" + "="*60)
        print("📊 ÉTAPE 6: MÉTRIQUES")
        print("="*60)
        
        self.metrics = calculate_all_metrics(self.transformed_data)
        
        for name, stats in self.metrics.items():
            self.log_operation(
                "METRICS",
                f"{name}: {stats.row_count} lignes, {stats.column_count} colonnes, {stats.memory_usage_mb:.4f} MB"
            )
        
        # Afficher le résumé
        print_metrics_summary(self.metrics)
        
        return self.metrics
    
    # =========================================================================
    # GÉNÉRATION DE RAPPORTS
    # =========================================================================
    
    def generate_report(self) -> Dict:
        """
        Génère un rapport complet de l'ETL
        
        Returns:
            Dict avec le rapport complet
        """
        report = {
            "timestamp": datetime.now().isoformat(),
            "pipeline_status": "SUCCESS" if all(
                r.error_count == 0 for r in self.validation_reports.values()
            ) else "WARNING",
            "summary": {
                "tables_processed": len(self.transformed_data),
                "total_rows": sum(len(df) for df in self.transformed_data.values()),
                "total_errors": sum(r.error_count for r in self.validation_reports.values()),
                "total_warnings": sum(r.warning_count for r in self.validation_reports.values())
            },
            "validation_reports": {
                name: report.to_dict() 
                for name, report in self.validation_reports.items()
            },
            "metrics": {
                name: stats.to_dict() 
                for name, stats in self.metrics.items()
            },
            "operations_log": self.operations_log
        }
        
        # Sauvegarder le rapport
        report_file = self.report_dir / f"etl_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        
        self.log_operation("REPORT", f"Rapport généré: {report_file}")
        
        return report
    
    # =========================================================================
    # EXÉCUTION COMPLÈTE
    # =========================================================================
    
    def run(
        self,
        file_mappings: Dict[str, str] = None,
        validate_data: bool = True,
        generate_report: bool = True
    ) -> Dict:
        """
        Exécute le pipeline ETL complet
        
        Args:
            file_mappings: Dict {nom_source: fichier_csv}
            validate_data: Si True, valide les données
            generate_report: Si True, génère un rapport
        
        Returns:
            Dict avec le résultat de l'exécution
        """
        print("\n" + "="*70)
        print("🚀 DÉMARRAGE DU PIPELINE ETL")
        print("="*70)
        print(f"📅 Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"📂 Répertoire données: {self.data_dir}")
        print(f"💾 Base de données: {self.db_path}")
        
        start_time = datetime.now()
        
        try:
            # Étape 1: Extraction
            self.extract(file_mappings)
            
            # Étape 2: Nettoyage
            self.clean()
            
            # Étape 3: Transformation
            self.transform()
            
            # Étape 4: Validation
            if validate_data:
                self.validate()
            
            # Étape 5: Chargement
            self.load()
            
            # Étape 6: Métriques
            self.calculate_metrics()
            
            # Génération du rapport
            report = None
            if generate_report:
                report = self.generate_report()
            
            end_time = datetime.now()
            duration = (end_time - start_time).total_seconds()
            
            print("\n" + "="*70)
            print("✅ PIPELINE ETL TERMINÉ AVEC SUCCÈS")
            print("="*70)
            print(f"⏱️ Durée totale: {duration:.2f} secondes")
            print(f"📊 Tables créées: {len(self.transformed_data)}")
            print(f"📝 Lignes totales: {sum(len(df) for df in self.transformed_data.values()):,}")
            
            return {
                "status": "SUCCESS",
                "duration_seconds": duration,
                "tables": list(self.transformed_data.keys()),
                "report": report
            }
        
        except Exception as e:
            self.log_operation("PIPELINE", f"Erreur fatale: {str(e)}", "ERROR")
            return {
                "status": "ERROR",
                "error": str(e),
                "operations_log": self.operations_log
            }


def run_etl(
    data_dir: str = ".",
    db_path: str = "mspr_etl.db",
    report_dir: str = "reports"
) -> Dict:
    """
    Fonction utilitaire pour exécuter l'ETL
    
    Args:
        data_dir: Répertoire des fichiers CSV
        db_path: Chemin de la base SQLite
        report_dir: Répertoire des rapports
    
    Returns:
        Résultat de l'exécution
    """
    pipeline = ETLPipeline(
        data_dir=data_dir,
        db_path=db_path,
        report_dir=report_dir
    )
    return pipeline.run()
