# 🛒 Instacart Reorder Prediction (Snowflake + dbt + ML)

This project builds a complete **AI-powered reorder prediction pipeline** on **Snowflake**, transforming raw transaction data into modeled reorder scores and surfacing them through a rich Snowsight dashboard.

It uses **dbt** for modular feature engineering, trains a **logistic regression model** locally using `scikit-learn`, and exports real predictions into Snowflake. The results are visualized interactively using native Snowflake tools — demonstrating what a productized ML workflow can look like inside the modern data stack.

---

## 🔮 Live Snowflake Dashboard

📊 [View Dashboard (Snowsight)](https://app.snowflake.com/kctrqzo/wdb83228/#/instacart-reorder-prediction-dLPdne9M0)  
_(Snowflake login required)_

This dashboard includes:

- Model-wide KPIs (volume, avg score, % above threshold)
- Score distribution for all predictions
- Predicted reorder rate by hour of day
- Top users, products, and aisles by predicted reorder probability
- Labeled risk bands (🟥🟨🟩) for easily surfacing low-confidence product categories

---

## ⚙️ Model Summary

| Metric                  | Value      |
|-------------------------|------------|
| Total Predictions       | 7,922,443  |
| Avg Predicted Score     | 0.102      |
| % Above 0.5 Threshold   | 0.6%       |

> The model was trained locally in Jupyter using `scikit-learn`, exported via `.pkl`, and used to generate predictions for all user-product pairs. These predictions were then uploaded to Snowflake and visualized through Snowsight.

---

## 🧱 Project Stack & Tools

| Component        | Tool Used                     |
|------------------|-------------------------------|
| Data Warehouse   | **Snowflake** (INSTACART_DB)  |
| Modeling         | **dbt** (modular SQL pipelines) |
| ML               | **Python (sklearn)**          |
| Inference        | Local batch + `.pkl` upload   |
| Visualization    | **Snowsight** (Snowflake native) |

---

## 🧠 Full AI Pipeline

- **Feature Engineering (dbt):**  
  Raw order and product data transformed into ML-ready features using reusable models

- **Model Training (Jupyter):**  
  Trained logistic regression locally on 7.9M user-product pairs  
  → `model_training/instacart_train_model.ipynb`

- **Model Export:**  
  Exported via `joblib` into `instacart_model.pkl`

- **Inference Results:**  
  Predictions uploaded into Snowflake as `RAW.PREDICTED_REORDERS2`

- **Dashboard View:**  
  `RAW.instacart_predictions_output` used to unify scoring logic and power dashboard

---

## 💡 Key Insights
Most predictions score well below 0.5 — a calibrated model that's cautious by design

Only 0.6% of user-product pairs exceed the reorder threshold

Hour-of-day predictions peak between 10AM–4PM

"At-risk" aisles like frozen foods and soft drinks receive high volume but low reorder confidence

Milk and yogurt categories show consistently high predicted reorders

---

## 📌 How to Run This Project
Step 1: Run dbt transformations
dbt run

Step 2: (Optional) Validate logic
dbt test

Step 3: Train model locally using sklearn + Jupyter
         → export as instacart_model.pkl

Step 4: Upload predictions to Snowflake via UI (Snowsight stage)

Step 5: Create instacart_predictions_output view

Step 6: Explore live metrics in Snowsight dashboard

---

## 🗂️ Raw Dataset Source

This project uses the open-source **Instacart Online Grocery Shopping Dataset 2017**, published by Instacart on Kaggle:

📦 [Download on Kaggle](https://www.kaggle.com/datasets/instacart/instacart-market-basket-analysis)

The dataset includes:
- 3M+ grocery orders from ~200K users
- 50K+ unique products across ~130 aisles
- Full user–product order history
- Product/department metadata

This dataset was loaded into Snowflake via CSV upload to a user-created stage (`instacart_stage`) and ingested using `COPY INTO` commands during project setup.

---

## 📁 Project Structure

```plaintext
instacart-reorder-prediction/
├── dbt/
│   ├── models/ (features, facts, labels)
│   └── schema.yml
│
├── snowflake_sql/
│   ├── 01_ingest_data.sql
│   ├── 02_dbt_model_run.sql
│   ├── 03_model_upload_and_udf.sql
│   ├── 04_local_predictions_to_table.sql
│   ├── 05_dashboard_views.sql
│   └── 06_model_summary.sql
│
├── model_training/
│   ├── instacart_train_model.ipynb
│   └── instacart_model.pkl
│
├── assets/
│   └── dashboard.png
│
└── README.md
