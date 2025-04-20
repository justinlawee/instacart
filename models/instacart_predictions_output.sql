-- models/instacart_predictions_output.sql

/* 
Description: Stores predicted reorder probabilities for each user-product pair from the inference set (test users as labeled in orders.csv).
(Currently empty — to be populated by the Snowpark ML model.)
*/

SELECT
  user_id,
  product_id,
  NULL::FLOAT AS reorder_probability,
  CURRENT_TIMESTAMP AS scored_at
FROM {{ ref('instacart_training_input') }}
