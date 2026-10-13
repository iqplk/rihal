from datetime import datetime

import firebase_admin
from firebase_admin import credentials, firestore

from rahhal_rules_dynamic import (
    load_places_from_firestore,
    recommend_and_plan,
)

from llm.plan_explainer import explain_plan

# ============================
# Firebase
# ============================

if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")

    firebase_admin.initialize_app(cred)

db = firestore.client()


# ============================
# Load places
# ============================

places = load_places_from_firestore(db)

print(f"عدد الأماكن في Firebase: {len(places)}")


# ============================
# Generate plan
# ============================

result = recommend_and_plan(
    places=places,
    user_preferences=[
        "تراث وثقافة",
        "مواقع تاريخية",
    ],
    preferred_time="any",
    arrival_dt=datetime(
        2026,
        10,
        13,
        9,
        0,
    ),
    departure_dt=datetime(
        2026,
        10,
        13,
        18,
        0,
    ),
    lodging_coordinates=(
        24.4683,
        39.6108,
    ),
    selected_place_ids=[
        "P01",
        "P02",
        "P11",
        "P13",
        "P22",
        "P23",
    ],
    visited_place_ids=[],
    weather_by_date={},
    max_travel_distance_km=30,
    max_places_per_day=None,
)


# ============================
# LLM explanation
# ============================

print("\n" + "=" * 60)
print("شرح LLM")
print("=" * 60)

explanation = explain_plan(result)

print(explanation)
