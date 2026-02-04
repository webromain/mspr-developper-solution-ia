CREATE TABLE patient(
   patient_id INT,
   age INT NOT NULL,
   gender VARCHAR(12) NOT NULL,
   weight_kg DECIMAL(5,2) NOT NULL,
   height_cm DECIMAL(5,2) NOT NULL,
   bmi_calculated DECIMAL(5,2) NOT NULL,
   PRIMARY KEY(patient_id)
);

CREATE TABLE sante(
   ID_Sante INT,
   cholesterol SMALLINT NOT NULL,
   blood_pressure VARCHAR(20) NOT NULL,
   disease_type VARCHAR(100) NOT NULL,
   glucose SMALLINT NOT NULL,
   severity enum("Low","Moderate","High"),
   patient_id INT NOT NULL,
   PRIMARY KEY(ID_Sante),
   UNIQUE(patient_id),
   FOREIGN KEY(patient_id) REFERENCES patient(patient_id)
);

CREATE TABLE nutrition(
   ID_Nutrition INT,
   daily_caloric_intake INT NOT NULL,
   dietary_restrictions VARCHAR(255),
   allergies VARCHAR(255),
   preferred_cuisine VARCHAR(100),
   diet_recommendation VARCHAR(255),
   adherence_to_diet_plan VARCHAR(50),
   patient_id INT NOT NULL,
   PRIMARY KEY(ID_Nutrition),
   UNIQUE(patient_id),
   FOREIGN KEY(patient_id) REFERENCES patient(patient_id)
);

CREATE TABLE activite_physique(
   ID_Activite_Physique INT,
   physical_activity_level VARCHAR(50),
   weekly_exercice_hours DECIMAL(4,2) NOT NULL,
   patient_id INT NOT NULL,
   PRIMARY KEY(ID_Activite_Physique),
   UNIQUE(patient_id),
   FOREIGN KEY(patient_id) REFERENCES patient(patient_id)
);

CREATE TABLE gym_session(
   session_id INT,
   gym_session_duration_hours DECIMAL(4,2),
   gym_calories_burned INT,
   gym_workout_type VARCHAR(50),
   gym_max_bpm SMALLINT,
   gym_avg_bpm SMALLINT,
   gym_resting_bpm SMALLINT,
   gym_fat_percentage DECIMAL(5,2),
   gym_water_intake_liters DECIMAL(5,2),
   gym_workout_frequency_days_week SMALLINT,
   gym_experience_level VARCHAR(50),
   patient_id INT NOT NULL,
   PRIMARY KEY(session_id),
   FOREIGN KEY(patient_id) REFERENCES patient(patient_id)
);
