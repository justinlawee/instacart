# Instacart Reorder Prediction (Snowflake + dbt)

This project builds the data transformation layer for an end-to-end **AI-powered reorder prediction system** on **Snowflake**.

It uses **dbt** to clean, join, and engineer features from raw Instacart data stored in Snowflake, producing ML-ready outputs for training and inference using **Snowpark Python**.

---

## 🧱 Project Overview

- **Stack**: Snowflake + dbt + Snowpark + Cortex + Snowsight
- **Goal**: Predict whether a user will reorder a product in their next Instacart basket
- **Key Features**:
  - Scalable data ingestion from S3
  - Feature engineering with dbt
  - Model training with Snowpark (Random Forest / XGBoost)
  - Cortex GenAI (optional): enrich features with embeddings or sentiment
  - Snowsight dashboards for interactive visualization

---

## 📁 This dbt Project Includes

- `models/`:  
  - `dim_orders.sql`, `dim_products.sql`, `fct_orders.sql`, `fct_user_product_features.sql`
  - `fct_reorder_training_data.sql`, `instacart_training_input.sql`, `instacart_predictions_output.sql`

- `schema.yml`: Describes and tests the structure of all models

- `dbt_project.yml`: Configured for table materialization and Snowflake deployment

---

## 🧠 Full AI Pipeline (Outside this Repo)

- **Modeling**: `snowpark/model_training.py`  
- **Notebook**: `notebooks/instacart_model.ipynb` (interactive summary & visualizations)
- **Deployment**: Inference results written back to Snowflake table

---

## 📌 How to Use

```bash
# Run transformations
dbt run

# Optional: test model assumptions
dbt test
