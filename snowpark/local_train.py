import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

# Load your training dataset from CSV (exported from dbt or Snowsight)
df = pd.read_csv("instacart_training_input.csv")  # You’ll need to create this if it doesn’t exist

# Prepare features
X = df.drop(columns=["user_id", "product_id", "reordered_label"])
y = df["reordered_label"]

# Train a model
X_train, X_test, y_train, y_test = train_test_split(X, y, stratify=y, test_size=0.2)
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Generate reorder probabilities
df["reorder_probability"] = model.predict_proba(X)[:, 1]

# Save output
df[["user_id", "product_id", "reorder_probability"]].to_csv("predictions.csv", index=False)
print("✅ Saved predictions.csv")
