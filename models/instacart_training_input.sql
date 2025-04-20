-- models/instacart_training_input.sql

/* 
Description: Filtered dataset passed into trained model
→ Filters fct_user_product_features to include only user-product pairs with at least 2 prior orders. 
  Pairs are then passed into the trained model to generate reorder predictions.
*/

SELECT *
FROM {{ ref('fct_reorder_training_data') }}
WHERE total_orders >= 2
