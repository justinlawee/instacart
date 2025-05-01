CREATE OR REPLACE VIEW RAW.fct_user_product_features AS
SELECT
    o.user_id,
    op.product_id,
    COUNT(*) AS total_orders,
    SUM(op.reordered) AS total_reorders,
    SUM(op.reordered) / COUNT(*) AS reorder_rate,
    MAX(o.order_number) AS max_order_number,
    MAX(o.days_since_prior_order) AS days_since_last_order
FROM RAW.orders o
JOIN RAW.order_products_prior op ON o.order_id = op.order_id
GROUP BY o.user_id, op.product_id;

CREATE OR REPLACE VIEW RAW.dim_orders AS
SELECT
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow AS order_day_of_week,
    order_hour_of_day,
    days_since_prior_order
FROM RAW.orders;


CREATE OR REPLACE VIEW RAW.instacart_training_input AS
SELECT
    f.user_id,
    f.product_id,
    f.total_orders,
    f.total_reorders,
    f.reorder_rate,
    f.max_order_number,
    f.days_since_last_order,
    CASE WHEN t.product_id IS NOT NULL THEN 1 ELSE 0 END AS reordered_label
FROM RAW.fct_user_product_features f
JOIN RAW.dim_orders o
    ON f.user_id = o.user_id
    AND o.eval_set = 'train'
LEFT JOIN RAW.order_products_train t
    ON o.order_id = t.order_id
    AND f.product_id = t.product_id;

    
-- 1. Create table to hold predictions
CREATE OR REPLACE TABLE RAW.predicted_reorders (
    user_id INTEGER,
    product_id INTEGER,
    predicted_label BOOLEAN
);

-- 2. Insert sample predictions (you can later replace with actual model output)
INSERT INTO RAW.predicted_reorders (user_id, product_id, predicted_label)
SELECT
    user_id,
    product_id,
    IFF(uniform(0, 1, random()) > 0.5, TRUE, FALSE) AS predicted_label
FROM RAW.fct_user_product_features
LIMIT 500;

-- 3. Create the final view for downstream usage (dashboards, etc.)
CREATE OR REPLACE VIEW RAW.instacart_predictions_output AS
SELECT
    user_id,
    product_id,
    predicted_label
FROM RAW.predicted_reorders;

-- 4. Preview your results
SELECT * FROM RAW.instacart_predictions_output LIMIT 20;

SELECT * FROM RAW.instacart_training_input;

