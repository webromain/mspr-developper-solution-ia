# MSPR 2 - Modèle de Données NoSQL

**HealthAI Coach - Collections MongoDB pour recommandations & prédictions**

---

## 1. Justification choix NoSQL

**MongoDB vs PostgreSQL pour MSPR 2:**

| Critère                 | PostgreSQL      | MongoDB             | Choix MSPR 2 |
| ----------------------- | --------------- | ------------------- | ------------ |
| Structure               | Rigide (schema) | Flexible (document) | MongoDB      |
| Requêtes complexes      | Excellent (SQL) | Bon (aggregation)   | SQL          |
| Scalabilité horizontale | Difficile       | Facile (sharding)   | MongoDB      |
| Volumes recommandations | Moderate        | Élevés (millions)   | MongoDB      |
| Historique données      | Audit trail     | Documents imbriqués | Hybride      |
| Vitesse écriture        | Bonne           | Excellente          | MongoDB      |
| Indexation              | B-tree          | Text + Geo + Arrays | Hybride      |

**Conclusion:** MongoDB (Atlas) pour collections IA (recommandations, prédictions, feedback), PostgreSQL pour données structurées MSPR 1.

---

## 2. Architecture données MongoDB

```
Database: healthai_coach_ai

Collections:
├─ recommendations
│  ├─ nutrition_recommendations
│  ├─ activity_recommendations
│  └─ combined_recommendations
│
├─ user_profiles_extended
│  ├─ preferences
│  ├─ goals
│  └─ constraints
│
├─ predictions
│  ├─ health_predictions
│  ├─ performance_predictions
│  └─ progression_recommendations
│
├─ meal_analysis
│  ├─ analyzed_meals
│  └─ meal_images (refs)
│
├─ workout_history
│  ├─ completed_workouts
│  └─ workout_feedback
│
├─ model_metadata
│  ├─ model_versions
│  ├─ training_runs
│  └─ performance_metrics
│
└─ feedback_audit
   ├─ recommendation_feedback
   └─ user_interactions
```

---

## 3. Collections principales

### 3.1 Collection: `recommendations`

**Document type: Nutrition Recommendation**

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439011"),
  "recommendation_id": "REC_NUT_2026_01_04_001",
  "patient_id": 123,
  "type": "nutrition",
  "timestamp": ISODate("2026-01-04T14:30:00Z"),

  "trigger": {
    "type": "meal_photo_upload",
    "meal_photo_url": "s3://bucket/meals/123/photo_001.jpg",
    "meal_identified": true
  },

  "meal_analysis": {
    "identified_foods": [
      {
        "name": "Poulet grillé",
        "portion_grams": 150,
        "confidence": 0.92,
        "nutrition_per_100g": {
          "calories": 165,
          "protein_g": 31.0,
          "carbs_g": 0,
          "fat_g": 3.6,
          "fiber_g": 0,
          "sodium_mg": 75
        },
        "nutrition_total": {
          "calories": 248,
          "protein_g": 46.5,
          "carbs_g": 0,
          "fat_g": 5.4,
          "fiber_g": 0,
          "sodium_mg": 112
        }
      },
      {
        "name": "Riz blanc",
        "portion_grams": 200,
        "confidence": 0.88,
        "nutrition_per_100g": {
          "calories": 130,
          "protein_g": 2.7,
          "carbs_g": 28.3,
          "fat_g": 0.3,
          "fiber_g": 0.4,
          "sodium_mg": 1
        },
        "nutrition_total": {
          "calories": 260,
          "protein_g": 5.4,
          "carbs_g": 56.6,
          "fat_g": 0.6,
          "fiber_g": 0.8,
          "sodium_mg": 2
        }
      }
    ],

    "meal_totals": {
      "total_calories": 508,
      "total_protein_g": 51.9,
      "total_carbs_g": 56.6,
      "total_fat_g": 6.0,
      "total_fiber_g": 0.8,
      "macros_ratio": {
        "protein_pct": 41,
        "carbs_pct": 45,
        "fat_pct": 11,
        "fiber_pct": 3
      }
    },

    "quality_score": {
      "nutritional_balance": 8.5,
      "macro_distribution": 8.0,
      "micronutrient_diversity": 7.5,
      "fiber_adequacy": 6.0,
      "overall": 7.5
    },

    "health_indicators": {
      "cholesterol_concern": false,
      "sodium_warning": false,
      "sugar_warning": false,
      "portion_size": "appropriate"
    }
  },

  "recommendations": [
    {
      "recommendation_id": "REC_NUT_ALT_001",
      "type": "alternative_meal",
      "score": 0.95,
      "title": "Poulet + Riz complet",
      "description": "Remplacer riz blanc par riz complet pour +4g fibres",
      "changes": [
        {
          "food": "Riz blanc",
          "replace_with": "Riz complet",
          "reason": "Higher fiber (6g vs 0.8g), lower glycemic index"
        }
      ],
      "estimated_nutrition": {
        "calories": 524,
        "protein_g": 51.9,
        "carbs_g": 56.6,
        "fat_g": 6.0,
        "fiber_g": 4.8
      },
      "expected_improvement": "Better satiety, glucose stability"
    },
    {
      "recommendation_id": "REC_NUT_ADD_001",
      "type": "add_ingredient",
      "score": 0.88,
      "title": "Ajouter brocoli",
      "description": "Augmenter apport en micronutriments (vit C, K, calcium)",
      "suggested_portion_grams": 100,
      "expected_changes": {
        "calories": 35,
        "fiber_g": 2.4,
        "vitamin_c_mg": 89
      }
    }
  ],

  "personalization": {
    "user_health_goals": ["weight_loss", "muscle_gain"],
    "current_daily_intake": {
      "calories": 1200,
      "goal_calories": 2000,
      "remaining_calories": 1492,
      "calories_percentage": 24
    },
    "dietary_preferences": ["high_protein"],
    "allergies_checked": true,
    "restrictions_respected": true
  },

  "algorithm_metadata": {
    "algorithms_used": [
      "content_based_filtering",
      "collaborative_filtering",
      "llm_personalization"
    ],
    "model_versions": {
      "vision_model": "google-vision-3.2.1",
      "nutrition_model": "nutrition_recommender_v4.2.1",
      "llm": "gpt-4-turbo"
    },
    "inference_time_ms": 2847,
    "confidence_scores": {
      "food_identification": 0.90,
      "recommendation_quality": 0.87,
      "personalization_fit": 0.92
    }
  },

  "feedback": {
    "user_rating": null,  // Sera rempli après action utilisateur
    "action_taken": null, // "liked", "ignored", "used_alternative", "added_to_plan"
    "feedback_timestamp": null
  },

  "metadata": {
    "created_at": ISODate("2026-01-04T14:30:00Z"),
    "updated_at": ISODate("2026-01-04T14:30:00Z"),
    "ttl": 2592000,  // 30 days TTL for auto-deletion
    "indexed": true,
    "version": 1
  }
}
```

**Document type: Activity Recommendation**

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439012"),
  "recommendation_id": "REC_ACT_2026_01_04_001",
  "patient_id": 123,
  "type": "activity",
  "timestamp": ISODate("2026-01-04T08:00:00Z"),

  "user_context": {
    "current_fitness_level": "intermediate",
    "primary_goal": "muscle_gain",
    "experience_level": "advanced",
    "available_time_minutes": 60,
    "available_equipment": ["dumbbells", "bench", "pullup_bar"],
    "last_workout_type": "chest_day",
    "hours_since_last_workout": 48,
    "recovery_status": "recovered",
    "injury_concerns": []
  },

  "progression_analysis": {
    "current_strength_levels": {
      "bench_press_1rm": 100,
      "squat_1rm": 140,
      "deadlift_1rm": 160
    },
    "recent_progression": {
      "bench_press_trend": "steady (+2.5% per week)",
      "squat_trend": "plateaued",
      "deadlift_trend": "progressing (+3% per week)"
    },
    "recommended_progression": {
      "type": "increase_volume",
      "mechanism": "add_set",
      "reason": "Recent workout RPE 6/10, room for more volume"
    },
    "estimated_strength_gain": "2-3% in 4 weeks"
  },

  "recommended_workout": {
    "workout_id": "WO_2026_01_04_001",
    "date": ISODate("2026-01-04T09:00:00Z"),
    "type": "hypertrophy",
    "focus": "back_and_biceps",
    "difficulty_level": "intermediate",
    "estimated_duration_minutes": 55,
    "estimated_calories_burned": 350,

    "phases": [
      {
        "phase": "warmup",
        "duration_minutes": 5,
        "exercises": [
          {
            "name": "Light cardio",
            "duration": 3,
            "intensity": "light"
          },
          {
            "name": "Dynamic stretching",
            "duration": 2,
            "focus": "shoulders, back"
          }
        ]
      },
      {
        "phase": "main",
        "duration_minutes": 45,
        "exercises": [
          {
            "exercise_id": "EX_PULLUPS",
            "name": "Pull-ups (weighted)",
            "sets": 4,
            "reps": "6-8",
            "weight_kg": 20,
            "rest_seconds": 120,
            "notes": "Focus on scapular retraction",
            "difficulty": "hard",
            "muscle_groups": ["back", "biceps", "lats"]
          },
          {
            "exercise_id": "EX_DUMBBELL_ROW",
            "name": "Dumbbell rows",
            "sets": 4,
            "reps": "8-10",
            "weight_kg": 25,
            "rest_seconds": 90,
            "notes": "Each side, mind the arch",
            "difficulty": "medium",
            "muscle_groups": ["back", "biceps"]
          },
          {
            "exercise_id": "EX_BARBELL_CURL",
            "name": "Barbell curls",
            "sets": 3,
            "reps": "8-10",
            "weight_kg": 35,
            "rest_seconds": 60,
            "notes": "Controlled eccentric",
            "difficulty": "medium",
            "muscle_groups": ["biceps"]
          }
        ]
      },
      {
        "phase": "cooldown",
        "duration_minutes": 5,
        "exercises": [
          {
            "name": "Static stretching",
            "duration": 5,
            "focus": "back, shoulders, arms"
          }
        ]
      }
    ],

    "motivation_insights": [
      "You've done back/biceps 2 times this month - good frequency",
      "Progression pace: +2.5% per week is sustainable",
      "Consider adding lat pulldown next week for variation"
    ]
  },

  "alternatives": [
    {
      "alternative_id": "ALT_WO_001",
      "reason": "Home version without gym",
      "type": "home_workout",
      "duration_minutes": 40,
      "equipment_needed": ["dumbbells", "pullup_bar"],
      "difficulty_adjustment": "slightly_lower"
    },
    {
      "alternative_id": "ALT_WO_002",
      "reason": "Time-constrained (30 min)",
      "type": "quick_workout",
      "duration_minutes": 30,
      "exercise_count": 3,
      "difficulty_adjustment": "same"
    }
  ],

  "recovery_protocol": {
    "sleep_recommendation": "7-8 hours",
    "hydration_target_liters": 3,
    "rest_day_recommendation": "1 full rest day, then different muscle group",
    "post_workout_nutrition": {
      "protein_grams": 25,
      "carbs_grams": 50,
      "timing_minutes_after": "30-60"
    }
  },

  "algorithm_metadata": {
    "algorithms_used": [
      "progression_adaptive_model",
      "exercise_graph_neural_network",
      "recovery_predictor"
    ],
    "model_versions": {
      "progression_model": "progression_v2.1.0",
      "exercise_nn": "exercise_gnn_v1.5.0",
      "recovery_model": "recovery_v1.3.0"
    },
    "inference_time_ms": 1234,
    "confidence_scores": {
      "workout_recommendation": 0.94,
      "progression_prediction": 0.89,
      "recovery_timing": 0.91
    }
  },

  "feedback": {
    "user_rating": null,
    "completed": null,
    "actual_performance": null,
    "difficulty_feedback": null,
    "motivation_level": null
  },

  "metadata": {
    "created_at": ISODate("2026-01-04T08:00:00Z"),
    "updated_at": ISODate("2026-01-04T08:00:00Z"),
    "valid_until": ISODate("2026-01-05T08:00:00Z"),
    "version": 1
  }
}
```

### 3.2 Collection: `user_profiles_extended`

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439013"),
  "patient_id": 123,

  "ai_profile": {
    "created_at": ISODate("2026-01-04T00:00:00Z"),
    "ai_profile_version": 2,
    "personalization_score": 0.92
  },

  "health_goals": {
    "primary_goal": "muscle_gain",
    "secondary_goals": ["strength_increase", "body_recomposition"],
    "goal_deadline": ISODate("2026-06-04"),
    "specific_targets": {
      "weight_kg": 82,
      "body_fat_pct": 15,
      "bench_1rm": 120
    }
  },

  "preferences": {
    "nutrition": {
      "diet_style": "high_protein",
      "meal_frequency": 4,
      "preferred_cuisines": ["mediterranean", "asian"],
      "dislikes": ["spicy", "organ_meat"],
      "cooking_preference": "simple_quick"
    },
    "activity": {
      "preferred_workouts": ["strength_training", "yoga"],
      "workout_time_preference": "morning",
      "intensity_preference": "high",
      "social_preference": "solo",
      "music_preference": "metal"
    },
    "learning_style": "visual_interactive"
  },

  "constraints": {
    "time_availability": {
      "available_hours_per_week": 10,
      "workout_days_per_week": 5,
      "meal_prep_hours_per_week": 3
    },
    "equipment_access": {
      "home": ["dumbbells", "pullup_bar", "bench"],
      "gym": ["full_equipment"],
      "commute_time_minutes": 15
    },
    "dietary_constraints": {
      "restrictions": ["lactose_intolerance"],
      "allergies": [],
      "budget_per_month_euros": 400
    },
    "medical": {
      "injuries": [],
      "conditions": [],
      "medications": []
    }
  },

  "behavior_patterns": {
    "adherence_history": {
      "diet_adherence_avg": 0.78,
      "workout_adherence_avg": 0.92,
      "recommendation_acceptance_rate": 0.65
    },
    "response_to_recommendations": {
      "prefers_incremental": true,
      "prefers_radical_change": false,
      "novelty_seeking": "medium"
    },
    "motivation_triggers": ["progress_tracking", "social_proof", "competition"],
    "learning_pace": "moderate"
  },

  "metadata": {
    "updated_at": ISODate("2026-01-04T12:00:00Z"),
    "data_freshness": "recent"
  }
}
```

### 3.3 Collection: `meal_analysis`

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439014"),
  "meal_id": "MEAL_2026_01_04_001",
  "patient_id": 123,
  "photo_url": "s3://bucket/meals/123/photo_001.jpg",
  "photo_upload_timestamp": ISODate("2026-01-04T14:20:00Z"),

  "vision_analysis": {
    "foods_detected": 3,
    "confidence_overall": 0.91,
    "foods": [
      {
        "name": "Poulet grillé",
        "confidence": 0.92,
        "estimated_weight_grams": 150
      },
      {
        "name": "Riz blanc",
        "confidence": 0.88,
        "estimated_weight_grams": 200
      },
      {
        "name": "Brocoli",
        "confidence": 0.85,
        "estimated_weight_grams": 80
      }
    ]
  },

  "logged_at": ISODate("2026-01-04T14:25:00Z"),
  "meal_time": "lunch",

  "processing_complete": true,
  "processed_at": ISODate("2026-01-04T14:32:00Z"),

  "metadata": {
    "processing_time_ms": 12000,
    "vision_api_used": "google-vision",
    "model_version": "v3.2.1"
  }
}
```

### 3.4 Collection: `predictions`

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439015"),
  "prediction_id": "PRED_HEALTH_2026_01_04_001",
  "patient_id": 123,
  "prediction_type": "weight_trajectory",
  "timestamp": ISODate("2026-01-04T00:00:00Z"),

  "input_data": {
    "historical_period_days": 90,
    "data_points_count": 90,
    "average_daily_calories": 2100,
    "average_weekly_exercise_hours": 5.5,
    "average_daily_steps": 8200
  },

  "predictions": [
    {
      "days_ahead": 7,
      "date": ISODate("2026-01-11T00:00:00Z"),
      "predicted_weight_kg": 79.2,
      "confidence_interval": {
        "lower": 78.8,
        "upper": 79.6
      },
      "trend": "slight_decrease",
      "factors": [
        "Positive: High exercise frequency",
        "Positive: Good adherence to goals",
        "Neutral: Caloric intake on target"
      ]
    },
    {
      "days_ahead": 30,
      "date": ISODate("2026-02-03T00:00:00Z"),
      "predicted_weight_kg": 77.5,
      "confidence_interval": {
        "lower": 76.8,
        "upper": 78.2
      },
      "trend": "steady_decrease",
      "factors": []
    },
    {
      "days_ahead": 90,
      "date": ISODate("2026-04-04T00:00:00Z"),
      "predicted_weight_kg": 74.0,
      "confidence_interval": {
        "lower": 72.5,
        "upper": 75.5
      },
      "trend": "on_track_for_goal",
      "factors": [
        "At current pace, will reach 82kg goal in ~120 days"
      ]
    }
  ],

  "model_info": {
    "model_name": "weight_trajectory_model",
    "version": "v2.1.0",
    "algorithm": "time_series_arima_lstm_ensemble",
    "training_date": ISODate("2025-12-15T00:00:00Z"),
    "accuracy_rmse": 1.2
  },

  "metadata": {
    "created_at": ISODate("2026-01-04T00:00:00Z"),
    "next_update": ISODate("2026-01-05T00:00:00Z")
  }
}
```

### 3.5 Collection: `feedback_audit`

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439016"),
  "feedback_id": "FDB_2026_01_04_001",
  "patient_id": 123,
  "recommendation_id": "REC_NUT_2026_01_04_001",

  "recommendation_details": {
    "type": "nutrition",
    "original_recommendation": "Riz complet au lieu de riz blanc",
    "timestamp_created": ISODate("2026-01-04T14:30:00Z")
  },

  "user_action": {
    "action_type": "accepted",  // accepted, rejected, ignored, not_applicable
    "timestamp_action": ISODate("2026-01-04T14:35:00Z"),
    "action_latency_minutes": 5
  },

  "user_feedback": {
    "rating": 4,  // 1-5 stars
    "helpful": true,
    "would_use_again": true,
    "comments": "Bonne suggestion, le riz complet était délicieux",
    "specific_feedback": {
      "accuracy_of_recommendation": "very_accurate",
      "difficulty_of_implementation": "easy",
      "taste_satisfaction": "satisfied"
    }
  },

  "outcome": {
    "followed_recommendation": true,
    "duration_days": 1,
    "result_satisfaction": "very_satisfied"
  },

  "model_learning": {
    "should_train_on": true,
    "feedback_value": "high",
    "features_to_update": [
      "user_preference_whole_grains",
      "taste_profile_learner"
    ]
  },

  "metadata": {
    "timestamp": ISODate("2026-01-04T14:35:00Z"),
    "data_version": 1
  }
}
```

---

## 4. Indices MongoDB

```javascript
// Collection: recommendations
db.recommendations.createIndex({ patient_id: 1, type: 1 });
db.recommendations.createIndex({ timestamp: -1 });
db.recommendations.createIndex({ recommendation_id: 1 }, { unique: true });
db.recommendations.createIndex({ "feedback.action_taken": 1 });
db.recommendations.createIndex(
  { timestamp: 1 },
  { expireAfterSeconds: 2592000 },
); // TTL

// Collection: user_profiles_extended
db.user_profiles_extended.createIndex({ patient_id: 1 }, { unique: true });
db.user_profiles_extended.createIndex({ "health_goals.primary_goal": 1 });

// Collection: meal_analysis
db.meal_analysis.createIndex({ patient_id: 1, photo_upload_timestamp: -1 });
db.meal_analysis.createIndex({ meal_id: 1 }, { unique: true });

// Collection: predictions
db.predictions.createIndex({ patient_id: 1, prediction_type: 1 });
db.predictions.createIndex({ timestamp: -1 });

// Collection: feedback_audit
db.feedback_audit.createIndex({ patient_id: 1, timestamp: -1 });
db.feedback_audit.createIndex({ recommendation_id: 1 });
db.feedback_audit.createIndex({ "user_action.action_type": 1 });
```

---

## 5. Queries courantes

### 5.1 Récupérer recommandations récentes utilisateur

```javascript
db.recommendations
  .find({
    patient_id: 123,
    timestamp: { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) },
  })
  .sort({ timestamp: -1 })
  .limit(10);
```

### 5.2 Agrégation: Satisfaction recommandations

```javascript
db.feedback_audit.aggregate([
  { $match: { patient_id: 123 } },
  {
    $group: {
      _id: "$recommendation_details.type",
      avg_rating: { $avg: "$user_feedback.rating" },
      acceptance_rate: {
        $avg: {
          $cond: [{ $eq: ["$user_action.action_type", "accepted"] }, 1, 0],
        },
      },
      count: { $sum: 1 },
    },
  },
]);
```

### 5.3 Trouver recommandations similaires

```javascript
db.recommendations.find({
  type: "nutrition",
  "meal_analysis.meal_totals.macros_ratio.protein_pct": {
    $gte: 38,
    $lte: 42,
  },
});
```

---

## 6. Sharding strategy (production)

**Pour scaler MongoDB avec 50,000+ utilisateurs:**

```javascript
// Shard key recommandations: (patient_id, timestamp)
sh.shardCollection("healthai_coach_ai.recommendations", {
  patient_id: 1,
  timestamp: -1,
});

// Shard key feedback: patient_id
sh.shardCollection("healthai_coach_ai.feedback_audit", {
  patient_id: 1,
});
```

---

## 7. Intégration avec PostgreSQL (MSPR 1)

**Synchronization via Change Streams:**

```python
# MongoDB change stream listener (FastAPI background task)
async def watch_recommendations():
    async with client.watch([
        {"operationType": {"$in": ["insert", "update"]}}
    ]) as stream:
        async for change in stream:
            if change['operationType'] == 'insert':
                # Log to PostgreSQL audit table
                recommendation_audit.insert(
                    patient_id=change['fullDocument']['patient_id'],
                    recommendation_id=change['fullDocument']['recommendation_id'],
                    created_at=datetime.now()
                )
```

---

## 8. Références

- [Architecture MSPR 2](MSPR2_Architecture.md)
- [API OpenAPI MSPR 2](../api-specs/MSPR2_API_OpenAPI.yaml)
- [MongoDB Atlas Documentation](https://docs.mongodb.com/atlas/)
- [Data Model MSPR 1](../mspr1/MSPR1_DataModel.md)
