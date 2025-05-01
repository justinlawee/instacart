# streamlit_app.py

"""
Description: Interactive reorder prediction UI for Instacart dataset
→ Allows user-level prediction of reorder probability using a trained model and historical order data.
→ Includes product metadata, reorder timeline visualization, threshold adjustment, and batch CSV prediction.
"""

from dotenv import load_dotenv
import os

load_dotenv()  # Load environment variables from .env file

aws_key = os.getenv("AWS_KEY_ID")
aws_secret = os.getenv("AWS_SECRET_KEY")

# Example print (for testing only — remove in real code)
print(f"AWS KEY: {aws_key[:4]}...")  # Show just prefix


import streamlit as st
import pandas as pd
import joblib

products_df = pd.read_csv("original_files/products.csv")# Adjust filename if needed

st.set_page_config(page_title="Instacart Reorder Predictor", page_icon="🛒")
st.title("🛒 Instacart Reorder Predictor")

# Load model and data
model = joblib.load("instacart_model.pkl")
df = pd.read_csv("original_files/instacart_training_input.csv").dropna()

# User selection
user_id = st.selectbox("Select User ID", sorted(df["USER_ID"].unique()))

# Filter products based on user selection
user_products = df[df["USER_ID"] == user_id]["PRODUCT_ID"].unique()
product_id = st.selectbox("Select Product ID", sorted(user_products))

# Predict for selected user-product pair
row = df[(df["USER_ID"] == user_id) & (df["PRODUCT_ID"] == product_id)]

if row.empty:
    st.warning("⚠️ No data for this user-product pair.")
else:
    features = row[["TOTAL_ORDERS", "TOTAL_REORDERS", "REORDER_RATE", "MAX_ORDER_NUMBER", "DAYS_SINCE_LAST_ORDER"]]
    prob = model.predict_proba(features)[0][1]
    st.success(f"🔁 Reorder probability: **{prob:.2%}**")

import altair as alt

user_history = df[df["USER_ID"] == user_id]
hist = alt.Chart(user_history).mark_bar().encode(
    x="MAX_ORDER_NUMBER:Q",
    y="REORDER_RATE:Q"
)
st.altair_chart(hist, use_container_width=True)

st.markdown("**Top factors for this prediction:**")
st.write({
    "📈 Reorder Rate": float(features["REORDER_RATE"].values[0]),
    "🛒 Total Orders": int(features["TOTAL_ORDERS"].values[0])
})

threshold = st.slider("Prediction threshold", 0.0, 1.0, 0.5)
st.write("Above threshold?" , prob > threshold)

with st.sidebar:
    st.markdown("🔗 [View Dashboard in Snowsight](https://app.snowflake.com/kctrqzo/wdb83228/#/instacart-reorder-prediction-dLPdne9M0)")

st.subheader("🕓 Reorder Timeline")
st.line_chart(user_history.sort_values("MAX_ORDER_NUMBER")[["MAX_ORDER_NUMBER", "REORDER_RATE"]].set_index("MAX_ORDER_NUMBER"))

avg_user_prob = df.groupby("USER_ID")["REORDER_RATE"].mean().reset_index()
st.metric(label="📊 Avg Reorder Rate (All Users)", value=f"{avg_user_prob['REORDER_RATE'].mean():.2%}")

st.markdown("### 🔍 Manual Feature Interpretation")
for col in ["TOTAL_ORDERS", "REORDER_RATE", "MAX_ORDER_NUMBER"]:
    st.write(f"**{col}**: {features[col].values[0]}")

# pseudo: assuming you have product metadata loaded
# Load supporting metadata files
aisles_df = pd.read_csv("original_files/aisles.csv")
departments_df = pd.read_csv("original_files/departments.csv")

# Get product metadata
product_row = products_df[products_df["product_id"] == product_id]
product_name = product_row["product_name"].values[0]

aisle_id = product_row["aisle_id"].values[0]
aisle = aisles_df.loc[aisles_df["aisle_id"] == aisle_id, "aisle"].values[0]

department_id = product_row["department_id"].values[0]
department = departments_df.loc[departments_df["department_id"] == department_id, "department"].values[0]

# Display metadata
st.info(f"🛒 Product: {product_name} \n📦 Aisle: {aisle} \n🏬 Department: {department}")

if st.button("📥 Save Prediction"):
    result = {
        "user_id": user_id,
        "product_id": product_id,
        "reorder_probability": prob
    }
    st.json(result)
    # Optionally append to CSV or write to Snowflake
    
FEATURE_COLUMNS = ["TOTAL_ORDERS", "TOTAL_REORDERS", "REORDER_RATE", "MAX_ORDER_NUMBER", "DAYS_SINCE_LAST_ORDER"]

st.markdown("### 📂 Upload CSV for Batch Predictions")
uploaded = st.file_uploader("Choose a file", type="csv")
if uploaded:
    try:
        preds = model.predict_proba(batch_df[FEATURE_COLUMNS])[:, 1]
        batch_df["reorder_probability"] = preds
        st.dataframe(batch_df.head())
        st.success("✅ Predictions generated!")
    except Exception as e:
        st.error(f"Error processing file: {e}")
