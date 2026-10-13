import math
import os
import requests

from datetime import datetime, timezone
from dotenv import load_dotenv

from services.routing_service import (
    build_route_cache,
    get_cached_route,
)

load_dotenv()


# ============================================================
# Geoapify Settings
# ============================================================

GEOAPIFY_API_KEY = os.getenv("GEOAPIFY_API_KEY")

GEOAPIFY_PLACES_URL = "https://api.geoapify.com/v2/places"


# ============================================================
# Geoapify Categories
# ============================================================

GEOAPIFY_CATEGORIES = [
    "catering.cafe",
    "catering.restaurant",
    "catering.fast_food",
    "catering.food_court",
    "tourism.attraction",
    "tourism.sights",
    "entertainment.museum",
    "leisure.park",
    "commercial.shopping_mall",
    "commercial.marketplace",
]

CATEGORY_FILTERS = {
    "all": GEOAPIFY_CATEGORIES,
    "cafes": [
        "catering.cafe",
    ],
    "markets": [
        "commercial.shopping_mall",
        "commercial.marketplace",
    ],
}


# ============================================================
# Dynamic Search Radius
# ============================================================


def get_dynamic_radius(
    available_minutes,
    transport_mode,
):
    """
    يحدد نطاق البحث تلقائيًا حسب:
    - الوقت المتاح
    - وسيلة التنقل
    """

    # --------------------------------------------------------
    # Walking
    # --------------------------------------------------------

    if transport_mode == "walking":

        if available_minutes <= 30:
            return 600

        if available_minutes <= 45:
            return 900

        if available_minutes <= 60:
            return 1300

        if available_minutes <= 90:
            return 1800

        if available_minutes <= 120:
            return 2500

        return 3000

    # --------------------------------------------------------
    # Driving
    # --------------------------------------------------------

    if transport_mode == "driving":

        if available_minutes <= 30:
            return 1000

        if available_minutes <= 45:
            return 2000

        if available_minutes <= 60:
            return 3000

        if available_minutes <= 90:
            return 5000

        return 7000

    # --------------------------------------------------------
    # Auto
    # --------------------------------------------------------

    if available_minutes <= 30:
        return 500

    if available_minutes <= 45:
        return 1000

    if available_minutes <= 60:
        return 1500

    if available_minutes <= 90:
        return 2500

    return 4000


# ============================================================
# Haversine
# ============================================================


def haversine_km(
    lat1,
    lon1,
    lat2,
    lon2,
):
    """
    مسافة مستقيمة تستخدم فقط
    للترتيب الأولي.
    """

    r = 6371.0

    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)

    delta_phi = math.radians(lat2 - lat1)

    delta_lambda = math.radians(lon2 - lon1)

    a = (
        math.sin(delta_phi / 2) ** 2
        + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2
    )

    c = 2 * math.atan2(
        math.sqrt(a),
        math.sqrt(1 - a),
    )

    return r * c


# ============================================================
# Walking Fallback
# ============================================================


def estimate_walking_route(
    origin,
    destination,
):
    """
    Fallback للمشي إذا ORS لم يرجع مسارًا.

    يستخدم المسافة المستقيمة مع معامل
    تقريبي للشوارع.

    سرعة المشي التقريبية:
    4.5 كم/ساعة.
    """

    straight_distance_km = haversine_km(
        origin[0],
        origin[1],
        destination[0],
        destination[1],
    )

    # الطرق الفعلية غالبًا أطول من الخط المستقيم
    estimated_distance_km = straight_distance_km * 1.25

    walking_speed_kmh = 4.5

    duration_minutes = (estimated_distance_km / walking_speed_kmh) * 60

    return {
        "distance_km": round(
            estimated_distance_km,
            2,
        ),
        "duration_minutes": round(
            duration_minutes,
            1,
        ),
        "estimated": True,
    }


# ============================================================
# Category Mapping
# ============================================================


def get_category(
    categories,
):
    """
    يحوّل Geoapify categories
    إلى أسماء بسيطة بالعربي.
    """

    categories = categories or []

    # --------------------------------------------------------
    # Cafe
    # --------------------------------------------------------

    if any(category.startswith("catering.cafe") for category in categories):
        return "كافيه"

    # --------------------------------------------------------
    # Commercial
    # --------------------------------------------------------

    if any(category.startswith("commercial") for category in categories):
        return "تسوق"

    # --------------------------------------------------------
    # Fast food
    # --------------------------------------------------------

    if any(category.startswith("catering.fast_food") for category in categories):
        return "وجبات سريعة"

    # --------------------------------------------------------
    # Food court
    # --------------------------------------------------------

    if any(category.startswith("catering.food_court") for category in categories):
        return "منطقة مطاعم"

    # --------------------------------------------------------
    # Restaurant
    # --------------------------------------------------------

    if any(category.startswith("catering.restaurant") for category in categories):
        return "مطعم"

    # --------------------------------------------------------
    # Museum
    # --------------------------------------------------------

    if any("museum" in category for category in categories):
        return "متحف"

    # --------------------------------------------------------
    # Park
    # --------------------------------------------------------

    if any(category.startswith("leisure.park") for category in categories):
        return "حديقة"

    # --------------------------------------------------------
    # Tourism
    # --------------------------------------------------------

    if any(category.startswith("tourism") for category in categories):
        return "معلم سياحي"

    return "مكان قريب"


# ============================================================
# Visit Duration
# ============================================================


def get_default_visit_minutes(
    category,
):
    """
    مدة زيارة تقديرية حسب نوع المكان.
    """

    durations = {
        "كافيه": 20,
        "وجبات سريعة": 25,
        "منطقة مطاعم": 35,
        "مطعم": 45,
        "تسوق": 45,
        "حديقة": 30,
        "متحف": 45,
        "معلم سياحي": 30,
        "مكان قريب": 20,
    }

    return durations.get(
        category,
        20,
    )


# ============================================================
# Address
# ============================================================


def get_address(
    properties,
):
    """
    يرجع أفضل عنوان متوفر من Geoapify.
    """

    formatted = properties.get("formatted")

    if formatted:
        return formatted

    address_line1 = properties.get("address_line1")

    address_line2 = properties.get("address_line2")

    parts = []

    if address_line1:
        parts.append(str(address_line1))

    if address_line2:
        parts.append(str(address_line2))

    if parts:
        return "، ".join(parts)

    return "العنوان التفصيلي غير متوفر"


# ============================================================
# Geoapify Search
# ============================================================


def search_nearby_geoapify_places(
    latitude,
    longitude,
    radius_meters,
    max_results=12,
    category_filter=None,
):
    """
    يبحث عن الأماكن القريبة
    باستخدام Geoapify Places API.
    """

    if not GEOAPIFY_API_KEY:
        raise RuntimeError("GEOAPIFY_API_KEY غير موجود " "في ملف .env")

    selected_categories = CATEGORY_FILTERS[category_filter or "all"]

    categories = ",".join(selected_categories)

    params = {
        "categories": categories,
        "filter": (f"circle:" f"{longitude}," f"{latitude}," f"{radius_meters}"),
        "bias": (f"proximity:" f"{longitude}," f"{latitude}"),
        "limit": max_results,
        "lang": "ar",
        "apiKey": GEOAPIFY_API_KEY,
    }

    try:
        response = requests.get(
            GEOAPIFY_PLACES_URL,
            params=params,
            timeout=20,
        )

    except requests.RequestException as e:
        raise RuntimeError("تعذر الاتصال بخدمة Geoapify: " + str(e))

    if response.status_code != 200:
        raise RuntimeError(
            "Geoapify request failed "
            f"with status "
            f"{response.status_code}: "
            f"{response.text[:300]}"
        )

    data = response.json()

    features = data.get(
        "features",
        [],
    )

    places = []

    seen = set()

    for feature in features:

        properties = feature.get(
            "properties",
            {},
        )

        geometry = feature.get(
            "geometry",
            {},
        )

        coordinates = geometry.get(
            "coordinates",
            [],
        )

        if len(coordinates) < 2:
            continue

        lng = coordinates[0]
        lat = coordinates[1]

        place_id = (
            properties.get("place_id") or properties.get("osm_id") or f"{lat}:{lng}"
        )

        place_id = str(place_id)

        if place_id in seen:
            continue

        seen.add(place_id)

        name = properties.get("name") or properties.get("name_international")

        if not name:
            continue

        categories_list = properties.get(
            "categories",
            [],
        )

        if category_filter not in (
            None,
            "all",
        ) and not any(
            actual == allowed or actual.startswith(allowed + ".")
            for actual in categories_list
            for allowed in selected_categories
        ):
            continue

        category = get_category(categories_list)

        distance_km = haversine_km(
            latitude,
            longitude,
            float(lat),
            float(lng),
        )

        opening_hours = properties.get("opening_hours")

        places.append(
            {
                "place_id": place_id,
                "source": "geoapify",
                "name": str(name),
                "category": category,
                "latitude": float(lat),
                "longitude": float(lng),
                "address": get_address(properties),
                "straight_distance_km": round(
                    distance_km,
                    2,
                ),
                "opening_hours": opening_hours,
                "visit_minutes": get_default_visit_minutes(category),
                "geoapify_categories": categories_list,
            }
        )

    places.sort(key=lambda place: place["straight_distance_km"])

    return places


# ============================================================
# Transport Selection
# ============================================================


def choose_route_mode(
    route,
    transport_mode,
):
    walking = route.get("walking")

    driving = route.get("driving")

    # --------------------------------------------------------
    # Walking only
    # --------------------------------------------------------

    if transport_mode == "walking" and walking:
        return (
            "walking",
            walking,
        )

    if transport_mode == "walking":
        return (
            None,
            None,
        )

    # --------------------------------------------------------
    # Driving only
    # --------------------------------------------------------

    if transport_mode == "driving" and driving:
        return (
            "driving",
            driving,
        )

    if transport_mode == "driving":
        return (
            None,
            None,
        )

    # --------------------------------------------------------
    # Auto
    # --------------------------------------------------------

    recommended = route.get("recommended_mode")

    if recommended == "walking" and walking:
        return (
            "walking",
            walking,
        )

    if recommended == "driving" and driving:
        return (
            "driving",
            driving,
        )

    if walking:
        return (
            "walking",
            walking,
        )

    if driving:
        return (
            "driving",
            driving,
        )

    return (
        None,
        None,
    )


# ============================================================
# Discover Now
# ============================================================


def discover_now(
    latitude,
    longitude,
    available_minutes,
    transport_mode="walking",
    safety_buffer_minutes=5,
    max_results=10,
    category_filter=None,
    next_destination=None,
    departure_datetime=None,
    next_activity_start=None,
):
    """
    الاستكشاف اللحظي:

    1. يحسب نطاق البحث تلقائيًا.
    2. يبحث عن الأماكن عبر Geoapify.
    3. يستخدم ORS لحساب الطريق الحقيقي.
    4. إذا تعذر ORS للمشي يستخدم تقدير احتياطي.
    5. يحسب:
       ذهاب + زيارة + رجوع + احتياط.
    6. يرجع فقط الأماكن التي تناسب وقت المستخدم.
    """

    if category_filter not in (
        None,
        "all",
        "cafes",
        "markets",
    ):
        raise ValueError("Unsupported discovery category")

    if next_activity_start is not None:
        if next_destination is None or departure_datetime is None:
            raise ValueError("Next activity requires " "destination and departure time")

        def utc(value):
            if value.tzinfo is None:
                from zoneinfo import ZoneInfo

                value = value.replace(tzinfo=ZoneInfo("Asia/Riyadh"))

            return value.astimezone(timezone.utc)

        departure = max(
            utc(departure_datetime),
            datetime.now(timezone.utc),
        )

        remaining = math.floor(
            (utc(next_activity_start) - departure).total_seconds() / 60
        )

        available_minutes = min(
            available_minutes,
            max(
                0,
                remaining,
            ),
        )

    if available_minutes <= safety_buffer_minutes:
        return {
            "places": [],
            "searched_count": 0,
            "suitable_count": 0,
            "search_radius_meters": 0,
            "search_available": True,
            "message": "ما لقينا مكان مناسب ضمن وقتك الحالي.",
            "available_minutes": available_minutes,
        }

    # ========================================================
    # 1. Dynamic radius
    # ========================================================

    radius_meters = get_dynamic_radius(
        available_minutes,
        transport_mode,
    )

    print(f"Discover Now radius: " f"{radius_meters} meters")

    # ========================================================
    # 2. Search Geoapify
    # ========================================================

    try:
        places = search_nearby_geoapify_places(
            latitude=latitude,
            longitude=longitude,
            radius_meters=radius_meters,
            max_results=12,
            category_filter=category_filter,
        )

    except Exception as e:
        print(
            "Geoapify search error:",
            str(e),
        )

        return {
            "places": [],
            "searched_count": 0,
            "suitable_count": 0,
            "search_radius_meters": radius_meters,
            "search_available": False,
            "message": "تعذر البحث عن الأماكن القريبة مؤقتًا.",
            "available_minutes": available_minutes,
            "error": str(e),
        }

    # ========================================================
    # 3. No places
    # ========================================================

    if not places:
        return {
            "places": [],
            "searched_count": 0,
            "suitable_count": 0,
            "search_radius_meters": radius_meters,
            "search_available": True,
            "message": "لم يتم العثور على أماكن قريبة ضمن نطاق البحث.",
            "available_minutes": available_minutes,
        }

    # ========================================================
    # 4. User location
    # ========================================================

    user_location = (
        latitude,
        longitude,
    )

    return_location = next_destination or user_location

    # ========================================================
    # 5. ORS locations
    # ========================================================

    locations = [
        user_location,
    ]

    if return_location != user_location:
        locations.append(return_location)

    for place in places:
        locations.append(
            (
                place["latitude"],
                place["longitude"],
            )
        )

    # ========================================================
    # 6. Build route matrix
    # ========================================================

    route_cache = build_route_cache(locations)

    if route_cache.get("walking_error"):
        print(
            "Walking Matrix warning:",
            route_cache["walking_error"],
        )

    if route_cache.get("driving_error"):
        print(
            "Driving Matrix warning:",
            route_cache["driving_error"],
        )

    results = []

    # ========================================================
    # 7. Evaluate places
    # ========================================================

    for place in places:

        place_location = (
            place["latitude"],
            place["longitude"],
        )

        # ----------------------------------------------------
        # Outbound
        # ----------------------------------------------------

        outbound_route = get_cached_route(
            route_cache,
            user_location,
            place_location,
        )

        # ----------------------------------------------------
        # Return
        # ----------------------------------------------------

        return_route = get_cached_route(
            route_cache,
            place_location,
            return_location,
        )

        # ----------------------------------------------------
        # Walking fallback
        # ----------------------------------------------------

        if transport_mode == "walking":

            if not outbound_route:
                outbound_route = {}

            if not return_route:
                return_route = {}

            if not outbound_route.get("walking"):
                outbound_route["walking"] = estimate_walking_route(
                    user_location,
                    place_location,
                )

            if not return_route.get("walking"):
                return_route["walking"] = estimate_walking_route(
                    place_location,
                    return_location,
                )

        elif not outbound_route or not return_route:
            continue

        # ----------------------------------------------------
        # Transport selection
        # ----------------------------------------------------

        (
            selected_mode,
            outbound_data,
        ) = choose_route_mode(
            outbound_route,
            transport_mode,
        )

        if selected_mode is None or outbound_data is None:
            continue

        return_data = return_route.get(selected_mode)

        if return_data is None:
            continue

        # ----------------------------------------------------
        # Times
        # ----------------------------------------------------

        outbound_duration = outbound_data.get("duration_minutes")

        return_duration = return_data.get("duration_minutes")

        if any(
            not isinstance(
                value,
                (int, float),
            )
            or not math.isfinite(value)
            or value < 0
            for value in (
                outbound_duration,
                return_duration,
            )
        ):
            continue

        outbound_minutes = math.ceil(outbound_duration)

        return_minutes = math.ceil(return_duration)

        visit_minutes = int(
            place.get(
                "visit_minutes",
                20,
            )
        )

        # ----------------------------------------------------
        # Total required time
        # ----------------------------------------------------

        total_minutes = (
            outbound_minutes + visit_minutes + return_minutes + safety_buffer_minutes
        )

        # ----------------------------------------------------
        # Time fit
        # ----------------------------------------------------

        if total_minutes > available_minutes:
            continue

        remaining_minutes = available_minutes - total_minutes

        # ----------------------------------------------------
        # Routing source
        # ----------------------------------------------------

        estimated_walking = selected_mode == "walking" and (
            outbound_data.get("estimated") or return_data.get("estimated")
        )

        if estimated_walking:
            routing_source = "estimated_walking"
        else:
            routing_source = outbound_route.get(
                "source",
                "ors",
            )

        # ----------------------------------------------------
        # Result
        # ----------------------------------------------------

        results.append(
            {
                **place,
                "travel_mode": selected_mode,
                "outbound_minutes": outbound_minutes,
                "return_minutes": return_minutes,
                "outbound_travel_minutes": outbound_minutes,
                "return_travel_minutes": return_minutes,
                "outbound_distance_km": outbound_data.get("distance_km"),
                "return_distance_km": return_data.get("distance_km"),
                "safety_buffer_minutes": safety_buffer_minutes,
                "total_required_minutes": total_minutes,
                "total_time_minutes": total_minutes,
                "remaining_minutes": remaining_minutes,
                "walking_option": outbound_route.get("walking"),
                "driving_option": outbound_route.get("driving"),
                "routing_source": routing_source,
            }
        )

    # ========================================================
    # 8. Ranking
    # ========================================================

    results.sort(
        key=lambda place: (
            place["total_required_minutes"],
            place["outbound_minutes"],
        )
    )

    # ========================================================
    # 9. Response
    # ========================================================

    message = None

    if not results:
        message = "لم يتم العثور على أماكن " "تناسب الوقت وطريقة التنقل الحالية."

    return {
        "places": results[:max_results],
        "searched_count": len(places),
        "suitable_count": len(results),
        "search_radius_meters": radius_meters,
        "search_available": True,
        "message": message,
        "available_minutes": available_minutes,
        "next_destination": (
            {
                "lat": return_location[0],
                "lng": return_location[1],
            }
            if next_destination is not None
            else None
        ),
        "next_activity_start": (
            next_activity_start.isoformat() if next_activity_start is not None else None
        ),
    }
