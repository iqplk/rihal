from datetime import datetime
from pprint import pprint

import firebase_admin
from firebase_admin import credentials, firestore

from rahhal_rules_dynamic import (
    load_places_from_firestore,
    recommend_and_plan,
)

# =========================================
# Firebase
# =========================================

if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")

    firebase_admin.initialize_app(cred)

db = firestore.client()


# =========================================
# Load places
# =========================================

places = load_places_from_firestore(db)

print(f"\nعدد الأماكن في Firebase: " f"{len(places)}")


# =========================================
# Trip time
# =========================================

arrival = datetime(
    2026,
    10,
    13,
    9,
    0,
)

departure = datetime(
    2026,
    10,
    13,
    18,
    0,
)


# =========================================
# Planner
# =========================================

result = recommend_and_plan(
    places=places,
    user_preferences=[
        "تراث وثقافة",
        "مواقع تاريخية",
    ],
    preferred_time="any",
    arrival_dt=arrival,
    departure_dt=departure,
    lodging_coordinates=(
        24.4683,
        39.6108,
    ),
    # الأماكن التي اختارها المستخدم
    # من الخريطة التفاعلية
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
    # auto / walking / driving
    transport_mode="auto",
)


# =========================================
# Print plan
# =========================================

print("\n" + "=" * 65)

print("خطة الرحلة")

print("=" * 65)


if not result["plan"]:

    print("لم يتم إنشاء خطة.")

else:

    for day, activities in result["plan"].items():

        print(f"\nاليوم: {day}")

        print("-" * 65)

        for index, item in enumerate(
            activities,
            start=1,
        ):

            print(f"\n{index}) " f"{item['name_ar']}")

            print(f"   التصنيف: " f"{item.get('category')}")

            print(f"   وقت الزيارة: " f"{item['start']} " f"- {item['end']}")

            print(f"   مدة الزيارة: " f"{item['visit_minutes']} دقيقة")

            print(f"   طريقة التنقل المستخدمة: " f"{item['travel_mode']}")

            print(
                f"   وقت التنقل المستخدم: " f"{item['estimated_travel_minutes']} دقيقة"
            )

            print(f"   المسافة المستخدمة: " f"{item['distance_from_previous_km']} كم")

            print("   🚶 المشي:")

            pprint(item["walking_option"])

            print("   🚗 السيارة:")

            pprint(item["driving_option"])

            print(f"   المقترح: " f"{item['recommended_mode']}")

            print(f"   مصدر الطريق: " f"{item['routing_source']}")

            print(f"   Score: " f"{item['rule_score']}")

            print(f"   السبب: " f"{item['reason']}")

            print(f"   ساعات العمل: " f"{item['opening_hours_note']}")


print("\n" + "=" * 65)

print("الأماكن التي لم تدخل الخطة")

print("=" * 65)


if result["unscheduled_places"]:

    for place in result["unscheduled_places"]:

        print(f"- " f"{place['place_id']} " f"| " f"{place['name_ar']}")

else:

    print("لا يوجد")


print("\n" + "=" * 65)

print("ملاحظات")

print("=" * 65)

for note in result["notes"]:
    print("-", note)
