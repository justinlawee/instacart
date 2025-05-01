-- 04_local_predictions_to_table.sql
-- -------------------------------------------
-- This worksheet uploads real model predictions
-- from a local .csv (inferred using instacart_model.pkl)
-- into a Snowflake table for analysis and dashboards.
-- -------------------------------------------

-- ✅ File used: predicted_reorders.csv
-- Should contain:
-- USER_ID, PRODUCT_ID, REORDER_PROBABILITY

-- If not already created, do this in Snowsight UI:
-- Upload predicted_reorders.csv into RAW schema
-- Table name: PREDICTED_REORDERS2

-- Final output view for dashboards
CREATE OR REPLACE VIEW RAW.instacart_predictions_output AS
SELECT
  USER_ID,
  PRODUCT_ID,
  REORDER_PROBABILITY AS predicted_score
FROM RAW.PREDICTED_REORDERS2;

-- Preview results
SELECT * FROM RAW.instacart_predictions_output LIMIT 10;
