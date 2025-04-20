-- models/dim_products.sql

SELECT
  p.product_id,
  p.product_name,
  a.aisle_id,
  a.aisle AS aisle_name,
  d.department_id,
  d.department AS department_name
FROM {{ source('raw', 'products') }} p
JOIN {{ source('raw', 'aisles') }} a ON p.aisle_id = a.aisle_id
JOIN {{ source('raw', 'departments') }} d ON p.department_id = d.department_id