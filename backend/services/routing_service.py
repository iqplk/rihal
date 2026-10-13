import math
import os

import requests
from dotenv import load_dotenv

load_dotenv()

ORS_API_KEY = os.getenv("OPENROUTESERVICE_API_KEY")

BASE_MATRIX_URL = "https://api.heigit.org/" "openrouteservice/v2/matrix"


def _coord_key(coord):
    lat, lng = coord

    return (
        round(float(lat), 6),
        round(float(lng), 6),
    )


def _seconds_to_minutes(value):
    if value is None:
        return None

    return max(1, math.ceil(float(value) / 60))


def get_route_matrix(
    locations,
    profile="driving-car",
):
    """
    يرسل طلب Matrix واحد إلى ORS.

    locations:
        [(lat, lng), ...]

    profile:
        driving-car
        foot-walking
    """

    if not ORS_API_KEY:
        raise RuntimeError("OPENROUTESERVICE_API_KEY is missing from .env")

    url = f"{BASE_MATRIX_URL}/{profile}"

    # ORS يحتاج:
    # [longitude, latitude]
    ors_locations = [[lng, lat] for lat, lng in locations]

    body = {
        "locations": ors_locations,
        "metrics": [
            "duration",
            "distance",
        ],
        "units": "km",
    }

    headers = {
        "Authorization": ORS_API_KEY,
        "Content-Type": "application/json",
        "Accept": "application/json",
    }

    response = requests.post(
        url,
        headers=headers,
        json=body,
        timeout=25,
    )

    response.raise_for_status()

    data = response.json()

    durations_seconds = data.get("durations", [])

    distances_km = data.get("distances", [])

    durations_minutes = []

    for row in durations_seconds:
        converted_row = []

        for seconds in row:
            if seconds is None:
                converted_row.append(None)
            else:
                converted_row.append(_seconds_to_minutes(seconds))

        durations_minutes.append(converted_row)

    return {
        "durations_minutes": durations_minutes,
        "distances_km": distances_km,
    }


def build_route_cache(locations):
    """
    يسحب Matrix للمشي + السيارة مرة واحدة
    ويحفظها للاستخدام طوال التخطيط.
    """

    clean_locations = []
    seen = set()

    for coord in locations:

        if coord is None:
            continue

        key = _coord_key(coord)

        if key in seen:
            continue

        seen.add(key)

        clean_locations.append(
            (
                float(coord[0]),
                float(coord[1]),
            )
        )

    index_map = {
        _coord_key(coord): index for index, coord in enumerate(clean_locations)
    }

    cache = {
        "locations": clean_locations,
        "index_map": index_map,
        "walking": None,
        "driving": None,
        "walking_error": None,
        "driving_error": None,
    }

    # =========================================
    # Walking Matrix
    # =========================================

    try:
        cache["walking"] = get_route_matrix(
            clean_locations,
            profile="foot-walking",
        )

    except Exception as e:
        cache["walking_error"] = str(e)

    # =========================================
    # Driving Matrix
    # =========================================

    try:
        cache["driving"] = get_route_matrix(
            clean_locations,
            profile="driving-car",
        )

    except Exception as e:
        cache["driving_error"] = str(e)

    return cache


def _get_matrix_value(
    matrix,
    origin_index,
    destination_index,
):
    if not matrix:
        return None

    durations = matrix.get("durations_minutes", [])

    distances = matrix.get("distances_km", [])

    try:
        duration = durations[origin_index][destination_index]

        distance = distances[origin_index][destination_index]

    except (
        IndexError,
        TypeError,
    ):
        return None

    if duration is None or distance is None:
        return None

    return {
        "duration_minutes": int(duration),
        "distance_km": round(float(distance), 2),
    }


def get_cached_route(
    route_cache,
    origin,
    destination,
):
    """
    يقرأ المسافة والوقت من الـCache.
    لا يرسل أي API request جديد.
    """

    if origin is None or destination is None:
        return None

    index_map = route_cache.get("index_map", {})

    origin_index = index_map.get(_coord_key(origin))

    destination_index = index_map.get(_coord_key(destination))

    if origin_index is None or destination_index is None:
        return None

    walking = _get_matrix_value(
        route_cache.get("walking"),
        origin_index,
        destination_index,
    )

    driving = _get_matrix_value(
        route_cache.get("driving"),
        origin_index,
        destination_index,
    )

    recommended_mode = None

    # إذا مسافة المشي <= 1.5 كم
    if walking is not None:

        walking_distance = walking.get("distance_km")

        if walking_distance is not None and walking_distance <= 1.5:
            recommended_mode = "walking"

    if recommended_mode is None and driving is not None:
        recommended_mode = "driving"

    if recommended_mode is None and walking is not None:
        recommended_mode = "walking"

    return {
        "walking": walking,
        "driving": driving,
        "recommended_mode": recommended_mode,
        "source": "openrouteservice_matrix",
    }
