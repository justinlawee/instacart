-- 02_dbt_model_run.sql
-- -------------------------------------------
-- This worksheet outlines the dbt models used
-- to prepare training and inference datasets
-- for the Instacart Reorder Prediction project.
-- -------------------------------------------

-- ✅ Models created in dbt:
-- dim_orders.sql
-- dim_products.sql
-- fct_orders.sql
-- fct_user_product_features.sql
-- fct_reorder_training_data.sql
-- instacart_training_input.sql

-- These models feed into the exported training CSV
-- and also power live inference/dashboards.

-- If re-running locally via CLI:
-- $ dbt run --select instacart_training_input
