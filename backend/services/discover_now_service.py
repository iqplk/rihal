import math
import os
import requests

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
]


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
            return 400

        if available_minutes <= 45:
            return 700

        if available_minutes <= 60:
            return 1000

        if available_minutes <= 90:
            return 1500

        return 2000

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
    max_results=20,
):
    """
    يبحث عن الأماكن القريبة
    باستخدام Geoapify Places API.
    """

    if not GEOAPIFY_API_KEY:

        raise RuntimeError("GEOAPIFY_API_KEY غير موجود " "في ملف .env")

    categories = ",".join(GEOAPIFY_CATEGORIES)

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

    features = data.get("features", [])

    places = []

    seen = set()

    for feature in features:

        properties = feature.get("properties", {})

        geometry = feature.get("geometry", {})

        coordinates = geometry.get("coordinates", [])

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

        categories_list = properties.get("categories", [])

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
                "straight_distance_km": round(distance_km, 2),
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

    # --------------------------------------------------------
    # Driving only
    # --------------------------------------------------------

    if transport_mode == "driving" and driving:
        return (
            "driving",
            driving,
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

    # Fallback

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
):
    """
    الاستكشاف اللحظي:

    1. يحسب نطاق البحث تلقائيًا.
    2. يبحث عن الأماكن عبر Geoapify.
    3. يستخدم ORS لحساب الطريق الحقيقي.
    4. يحسب:
       ذهاب + زيارة + رجوع + احتياط.
    5. يرجع فقط الأماكن التي تناسب وقت المستخدم.
    """

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
            max_results=20,
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
            "message": ("تعذر البحث عن الأماكن " "القريبة مؤقتًا."),
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
            "message": ("لم يتم العثور على أماكن " "قريبة ضمن نطاق البحث."),
        }

    # ========================================================
    # 4. User location
    # ========================================================

    user_location = (
        latitude,
        longitude,
    )

    # ========================================================
    # 5. ORS locations
    # ========================================================

    locations = [user_location]

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

        print("Walking Matrix warning:", route_cache["walking_error"])

    if route_cache.get("driving_error"):

        print("Driving Matrix warning:", route_cache["driving_error"])

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
            user_location,
        )

        if not outbound_route or not return_route:
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

        outbound_minutes = int(
            outbound_data.get(
                "duration_minutes",
                0,
            )
        )

        return_minutes = int(
            return_data.get(
                "duration_minutes",
                0,
            )
        )

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
        # Result
        # ----------------------------------------------------

        results.append(
            {
                **place,
                "travel_mode": selected_mode,
                "outbound_minutes": outbound_minutes,
                "return_minutes": return_minutes,
                "outbound_distance_km": outbound_data.get("distance_km"),
                "return_distance_km": return_data.get("distance_km"),
                "safety_buffer_minutes": safety_buffer_minutes,
                "total_required_minutes": total_minutes,
                "remaining_minutes": remaining_minutes,
                "walking_option": outbound_route.get("walking"),
                "driving_option": outbound_route.get("driving"),
                "routing_source": outbound_route.get("source"),
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

    return {
        "places": results[:max_results],
        "searched_count": len(places),
        "suitable_count": len(results),
        "search_radius_meters": radius_meters,
        "search_available": True,
        "message": None,
    }
