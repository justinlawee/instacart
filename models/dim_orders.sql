-- models/dim_orders.sql

/* 
Description: Cleaned version of orders table
→ Renames and standardizes columns from the raw orders table for clarity (e.g., order_dow → order_day_of_week).
*/

SELECT
  order_id,
  user_id,
  eval_set,
  order_number,
  order_dow AS order_day_of_week,
  order_hour_of_day,
  days_since_prior_order
FROM {{ source('raw', 'orders') }}