-- models/dim_orders.sql

SELECT
  order_id,
  user_id,
  eval_set,
  order_number,
  order_dow AS order_day_of_week,
  order_hour_of_day,
  days_since_prior_order
FROM {{ source('raw', 'orders') }}