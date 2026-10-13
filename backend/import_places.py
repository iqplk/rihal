import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, time
import math

# =========================
# 1. Firebase connection
# =========================

if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()


# =========================
# 2. Excel file
# =========================

EXCEL_FILE = "rihal_places_FINAL_v1.xlsx"

places_df = pd.read_excel(EXCEL_FILE, sheet_name="الأماكن")

hours_df = pd.read_excel(EXCEL_FILE, sheet_name="ساعات_الفتح")


# =========================
# 3. Helper functions
# =========================


def clean_value(value):
    """
    Converts pandas/numpy values into values Firestore can store.
    """

    if pd.isna(value):
        return None

    # Convert numpy numbers
    if hasattr(value, "item"):
        try:
            value = value.item()
        except:
            pass

    return value


def format_time(value):
    """
    Convert Excel time into HH:MM string.
    Example:
    6:30 AM -> 06:30
    1:00 AM -> 01:00
    """

    if pd.isna(value):
        return None

    if isinstance(value, time):
        return value.strftime("%H:%M")

    if isinstance(value, datetime):
        return value.strftime("%H:%M")

    # Sometimes pandas gives it as text
    text = str(value)

    try:
        parsed = pd.to_datetime(text)
        return parsed.strftime("%H:%M")
    except:
        return text


# =========================
# 4. Build opening hours
# =========================


def get_opening_hours(place_id):
    place_hours = hours_df[hours_df["place_id"] == place_id]

    opening_hours = {}

    for _, row in place_hours.iterrows():

        day = clean_value(row["day"])

        if day is None:
            continue

        open_time = format_time(row["open_time"])
        close_time = format_time(row["close_time"])
        note = clean_value(row["notes"])

        if day not in opening_hours:
            opening_hours[day] = {"intervals": [], "notes": []}

        # If both are empty -> closed day
        if open_time is not None and close_time is not None:
            opening_hours[day]["intervals"].append(
                {"open": open_time, "close": close_time}
            )

        if note:
            opening_hours[day]["notes"].append(note)

    return opening_hours


# =========================
# 5. Upload places
# =========================

uploaded = 0

for _, row in places_df.iterrows():

    place_id = clean_value(row["place_id"])

    # Skip explanation/header rows
    if place_id is None:
        continue

    place_id = str(place_id).strip()

    if not place_id.startswith("P"):
        continue

    data = {
        "place_id": place_id,
        "name_ar": clean_value(row["name_ar"]),
        "name_en": clean_value(row["name_en"]),
        "location": {
            "lat": clean_value(row["lat"]),
            "lng": clean_value(row["lng"]),
        },
        "category": clean_value(row["category"]),
        "is_outdoor": (
            bool(clean_value(row["is_outdoor"]))
            if clean_value(row["is_outdoor"]) is not None
            else None
        ),
        "avg_visit_min": clean_value(row["avg_visit_min"]),
        "price_sar": clean_value(row["price_sar"]),
        "interests": {
            "history": clean_value(row["history"]),
            "culture": clean_value(row["culture"]),
            "nature": clean_value(row["nature"]),
            "shopping": clean_value(row["shopping"]),
            "food": clean_value(row["food"]),
        },
        "description": clean_value(row["description"]),
        "notes": clean_value(row["notes"]),
        "opening_hours": get_opening_hours(place_id),
    }

    # Remove null values only from top-level if wanted
    data = {key: value for key, value in data.items() if value is not None}

    db.collection("places").document(place_id).set(data, merge=True)

    uploaded += 1

    print(f"✅ {place_id} - {data.get('name_ar')}")


print()
print("==============================")
print(f"✅ Upload completed: {uploaded} places")
print("==============================")
