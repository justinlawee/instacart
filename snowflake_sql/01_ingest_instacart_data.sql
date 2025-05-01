SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();

USE WAREHOUSE INSTACART;

CREATE OR REPLACE DATABASE instacart_db;
USE DATABASE instacart_db;

CREATE OR REPLACE SCHEMA raw;
USE SCHEMA raw;

CREATE OR REPLACE STAGE instacart_stage
URL = 's3://instacart-prediction/'
CREDENTIALS = (
  AWS_KEY_ID = '${AWS_KEY_ID}'
  AWS_SECRET_KEY = '${AWS_SECRET_KEY}'
)
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
);

CREATE OR REPLACE TABLE aisles (
  aisle_id INTEGER,
  aisle STRING
);

COPY INTO aisles
FROM @instacart_stage/aisles.csv
FORCE = TRUE;

CREATE OR REPLACE TABLE departments (
  department_id INTEGER,
  department STRING
);

COPY INTO departments
FROM @instacart_stage/departments.csv
FORCE = TRUE;


CREATE OR REPLACE TABLE products (
  product_id INTEGER,
  product_name STRING,
  aisle_id INTEGER,
  department_id INTEGER
);

COPY INTO products
FROM @instacart_stage/products.csv
FORCE = TRUE;

CREATE OR REPLACE TABLE orders (
  order_id INTEGER,
  user_id INTEGER,
  eval_set STRING,
  order_number INTEGER,
  order_dow INTEGER,
  order_hour_of_day INTEGER,
  days_since_prior_order FLOAT
);

COPY INTO orders
FROM @instacart_stage/orders.csv
FORCE = TRUE;

CREATE OR REPLACE TABLE order_products_prior (
  order_id INTEGER,
  product_id INTEGER,
  add_to_cart_order INTEGER,
  reordered INTEGER
);

COPY INTO order_products_prior
FROM @instacart_stage/order_products__prior.csv
FORCE = TRUE

CREATE OR REPLACE TABLE order_products_train (
  order_id INTEGER,
  product_id INTEGER,
  add_to_cart_order INTEGER,
  reordered INTEGER
);

COPY INTO order_products_train
FROM @instacart_stage/order_products__train.csv
FORCE = TRUE;

LIST @instacart_stage;

