from snowflake.snowpark import Session
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import pandas as pd

# Step 1: Connect to Snowflake
connection_parameters = {
    "account": "KCTRQZO-WDB83228",
    "user": "JBORENSTEINLAWEE",
    "authenticator": "externalbrowser",
    "role": "ACCOUNTADMIN",
    "warehouse": "INSTACART",
    "database": "INSTACART_DB",
    "schema": "RAW"
}

session = Session.builder.configs(connection_parameters).create()

# Step 2: Load training dataset from Snowflake
df = session.table("instacart_training_input").to_pandas()

# Step 3: Prepare features and labels
X = df.drop(columns=["user_id", "product_id", "reordered_label"])
y = df["reordered_label"]

# Step 4: Train model
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, stratify=y, random_state=42)
model = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
model.fit(X_train, y_train)

# Step 5: Predict reorder probabilities
df["reorder_probability"] = model.predict_proba(X)[:, 1]

# Step 6: Upload predictions to Snowflake
predictions_df = df[["user_id", "product_id", "reorder_probability"]]

session.write_pandas(
    predictions_df,
    table_name="instacart_predictions_output",
    auto_create_table=True,
    overwrite=True
)

print("✅ Predictions uploaded to instacart_predictions_output")
