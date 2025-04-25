# 🛒 Instacart Reorder Prediction (Snowflake + dbt + ML)

This project builds a complete **AI-powered reorder prediction pipeline** on **Snowflake**, transforming raw transaction data into modeled reorder scores and surfacing them through a rich Snowsight dashboard.

It uses **dbt** for modular feature engineering, trains a **logistic regression model** locally using `scikit-learn`, and exports real predictions into Snowflake. The results are visualized interactively using native Snowflake tools — demonstrating what a productized ML workflow can look like inside the modern data stack.

---

## 💪🏼 What This Model Can Do
The logistic regression model predicts the probability that a user will reorder a given product in their next Instacart order. This enables a variety of high-impact use cases:

- **Personalized Recommendations**

Rank products by reorder probability to suggest top items for each user’s next basket.
- **Marketing Targeting**

Identify users with high reorder intent and send timely nudges or promotions.
- **Operational Forecasting**

Use aggregate reorder probabilities to improve inventory planning and fulfillment accuracy.
- **Analytics & Dashboards**

Visualize reorder likelihood across users, products, or departments to uncover actionable patterns.

---

## 📊 Live Snowflake Dashboard

[View Dashboard (Snowsight)](https://app.snowflake.com/kctrqzo/wdb83228/#/instacart-reorder-prediction-dLPdne9M0)  
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
  → **Notebook**: `model_training/instacart_train_model.ipynb`

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

Step 2: Train model locally using sklearn + Jupyter
         → export as instacart_model.pkl

Step 3: Upload predictions to Snowflake via UI (Snowsight stage)

Step 4: Create instacart_predictions_output view

Step 5: Explore live metrics in Snowsight dashboard

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

## 🔮 Future Product Ideas Inspired by Project Experience

While building this project, I identified two opportunities to further enhance the Snowflake developer experience:

### 1. Context-Aware SQL Copilot for Feature Engineering
A built-in assistant within SQL worksheets that suggests and auto-generates feature engineering queries based on a project’s schema.  
Example prompts:
- *"Would you like to add a rolling 3-order average?"*
- *"Would you like to calculate reorder rates per user?"*

**Impact:**  
Accelerates ML preparation, lowers SQL barriers, and bridges data warehousing with AI workflows.

### 2. Expanded Sandbox Mode for ML Experimentation
Trial accounts currently lack access to Snowpark ML and Cortex without scheduling a sales consultation.  
Introducing a Sandbox Mode would temporarily enable these features with service limits to manage costs.

**Impact:**  
Empowers developers, students, and independent builders to explore Snowflake’s full AI/ML capabilities and complete end-to-end projects before formalizing enterprise agreements.

> **Next Step:** I have a capl scheudled a sales representative on 4/28 to explore my options for upgrading my account. I plan to expand this project further by incorporating Snowpark ML model training and Cortex GenAI functions once my account upgrade is complete.

---

## 📁 Project Structure

```plaintext
instacart-reorder-prediction/
├── assets/
│   └── dashboard_preview.png                 # Snowsight dashboard screenshot
│
├── models/                                   # dbt models for feature engineering and ML prep
│   ├── dim_orders.sql
│   ├── dim_products.sql
│   ├── fct_orders.sql
│   ├── fct_reorder_training_data.sql
│   ├── fct_user_product_features.sql
│   ├── instacart_orders.sql
│   ├── instacart_predictions_output.sql
│   └── instacart_training_input.sql
│
├── notebooks/
│   └── Instacart.ipynb                       # Jupyter notebook for local ML model training & inference
│
├── snowflake_sql/                            # Snowflake SQL scripts for full pipeline
│   ├── 01_ingest_instacart_data.sql          # Stage and load CSVs into raw Snowflake tables
│   ├── 02_dbt_model_run.sql                  # Run dbt transformations
│   ├── 03_model_upload_and_udf.sql           # (Optional) Upload trained model and define UDFs
│   ├── 04_local_predictions_to_table.sql     # Upload local predictions to Snowflake
│   └── 05_model_features_and_dummy_data.sql  # Feature inspection and dummy data examples
│
├── .gitignore
├── README.md
```
## 📌 GitHub Metadata

- 🧑‍💻 Author: [Justin Borenstein-Lawee](https://www.linkedin.com/in/justin-borenstein-lawee/)  
- 🕓 Last Updated: April 2025  
