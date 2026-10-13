from collections import Counter, defaultdict

from datetime import datetime, timedelta, time

import math

from zoneinfo import ZoneInfo


from services.routing_service import (
    build_route_cache,
    get_cached_route,
)

# ============================================================

# Constants

# ============================================================


DEFAULT_VISIT_MINUTES = 60

DEFAULT_AVG_SPEED_KMH = 25

DEFAULT_WALKING_SPEED_KMH = 5


PLANNING_WINDOWS = {
    "morning": (time(8, 0), time(13, 0)),
    "evening": (time(16, 0), time(22, 0)),
    "any": (time(8, 0), time(22, 0)),
}


# ============================================================

# Helpers

# ============================================================


def haversine_km(coord1, coord2):
    """

    Fallback only if ORS fails.

    Calculates straight-line distance.

    """

    lat1, lon1 = coord1

    lat2, lon2 = coord2

    r = 6371

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


def get_coordinates(place):

    location = place.get("location") or {}

    lat = location.get("lat")

    lng = location.get("lng")

    if lat is None or lng is None:

        return None

    try:

        return float(lat), float(lng)

    except (TypeError, ValueError):

        return None


def get_visit_duration_minutes(place):

    value = place.get("avg_visit_min")

    try:

        value = int(value)

        if value > 0:

            return value

    except (TypeError, ValueError):

        pass

    return DEFAULT_VISIT_MINUTES


# ============================================================

# Firestore loader

# ============================================================


def load_places_from_firestore(db):

    places = []

    docs = db.collection("places").stream()

    for doc in docs:

        data = doc.to_dict()

        if "place_id" not in data:

            data["place_id"] = doc.id

        places.append(data)

    return places


# ============================================================

# Interest rules

# ============================================================


def normalize_preferred_time(value):

    if not value:

        return "any"

    value = str(value).strip().lower()

    mapping = {
        "any": "any",
        "الكل": "any",
        "morning": "morning",
        "صباح": "morning",
        "الصباح": "morning",
        "afternoon": "afternoon",
        "ظهر": "afternoon",
        "الظهر": "afternoon",
        "عصر": "afternoon",
        "العصر": "afternoon",
        "evening": "evening",
        "مساء": "evening",
        "المساء": "evening",
        "ليل": "evening",
    }

    return mapping.get(value, value)


def ui_interest_score(place, preference):
    """

    Maps Flutter UI interests to Firebase fields.

    """

    category = str(place.get("category") or "").strip()

    interests = place.get("interests") or {}

    history = float(interests.get("history") or 0)

    culture = float(interests.get("culture") or 0)

    nature = float(interests.get("nature") or 0)

    shopping = float(interests.get("shopping") or 0)

    preference = str(preference or "").strip()

    # --------------------------------------------------------

    # All

    # --------------------------------------------------------

    if preference == "الكل":

        return 1.0

    # --------------------------------------------------------

    # Historical

    # --------------------------------------------------------

    if preference in {
        "مواقع تاريخية",
        "تاريخ",
        "تاريخي",
    }:

        score = history

        if category in {
            "تاريخي",
            "تراثي",
            "متحف",
        }:

            score += 1.5

        return score

    # --------------------------------------------------------

    # Heritage / Culture

    # --------------------------------------------------------

    if preference in {
        "تراث وثقافة",
        "ثقافة",
        "تراث",
    }:

        score = culture + history

        if category in {
            "تراثي",
            "متحف",
            "تاريخي",
        }:

            score += 1.5

        return score

    # --------------------------------------------------------

    # Religious

    # --------------------------------------------------------

    if preference in {
        "أماكن دينية",
        "ديني",
        "دينية",
    }:

        if category == "ديني":

            return 4.0

        return 0.0

    # --------------------------------------------------------

    # Nature

    # --------------------------------------------------------

    if preference == "طبيعة":

        score = nature

        if place.get("is_outdoor"):

            score += 1.0

        return score

    # --------------------------------------------------------

    # Shopping

    # --------------------------------------------------------

    if preference == "تسوق":

        score = shopping

        if category == "تسوق":

            score += 2.0

        return score

    # --------------------------------------------------------

    # Adventure

    # --------------------------------------------------------

    if preference == "مغامرة":

        score = nature

        if place.get("is_outdoor"):

            score += 2.0

        if category in {
            "طبيعي",
            "مزرعة",
            "جبلي",
            "تراثي",
        }:

            score += 1.0

        return score

    # --------------------------------------------------------

    # Events

    # --------------------------------------------------------

    if preference == "فعاليات":

        score = culture

        if category == "ترفيهي":

            score += 2.0

        return score

    return 0.0


def preference_score(
    place,
    user_preferences,
):

    if not user_preferences:

        return 0.0

    if "الكل" in user_preferences:

        return 1.0

    score = 0.0

    for preference in user_preferences:

        score += ui_interest_score(
            place,
            preference,
        )

    return score


def category_bonus(
    place,
    user_preferences,
):

    category = str(place.get("category") or "")

    bonus = 0.0

    if "أماكن دينية" in user_preferences and category == "ديني":

        bonus += 2.0

    if "مواقع تاريخية" in user_preferences and category in {
        "تاريخي",
        "تراثي",
        "متحف",
    }:

        bonus += 1.5

    if "تراث وثقافة" in user_preferences and category in {
        "تراثي",
        "متحف",
        "تاريخي",
    }:

        bonus += 1.5

    if "تسوق" in user_preferences and category == "تسوق":

        bonus += 2.0

    return bonus


# ============================================================

# Opening hours

# ============================================================


WEEKDAYS_AR = [
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
    "الأحد",
]


def parse_hhmm(value):

    return datetime.strptime(value, "%H:%M").time()


def is_open_for_visit(
    place,
    visit_start,
    visit_end,
):

    opening_hours = place.get("opening_hours") or {}

    day_key = WEEKDAYS_AR[visit_start.weekday()]

    day_data = opening_hours.get(day_key)

    if not day_data:

        return (True, "ساعات العمل غير متوفرة؛ يلزم التحقق")

    intervals = day_data.get("intervals", [])

    notes = day_data.get("notes", [])

    if not intervals:

        return (False, "المكان مغلق في هذا اليوم")

    for interval in intervals:

        open_value = interval.get("open")

        close_value = interval.get("close")

        if not open_value or not close_value:

            continue

        open_t = parse_hhmm(open_value)

        close_t = parse_hhmm(close_value)

        open_dt = datetime.combine(
            visit_start.date(),
            open_t,
        )

        close_dt = datetime.combine(
            visit_start.date(),
            close_t,
        )

        # Overnight closing

        if close_t <= open_t:

            close_dt += timedelta(days=1)

        if visit_start >= open_dt and visit_end <= close_dt:

            if notes:

                return (True, " / ".join(notes))

            return (True, "ضمن ساعات العمل")

    if notes:

        return (False, " / ".join(notes))

    return (False, "خارج ساعات العمل")


# ============================================================

# Time suitability

# ============================================================


def get_time_period(dt):

    hour = dt.hour

    if 5 <= hour < 12:

        return "morning"

    if 12 <= hour < 17:

        return "afternoon"

    return "evening"


def time_suitability_score(
    place,
    visit_start,
    preferred_time,
):

    score = 0.0

    notes = []

    actual_period = get_time_period(visit_start)

    preferred_time = normalize_preferred_time(preferred_time)

    if preferred_time != "any":

        if actual_period == preferred_time:

            score += 2.0

            notes.append("مطابق للوقت المفضل")

        else:

            score -= 0.8

    return score, notes


# ============================================================

# Weather / outdoor

# ============================================================


def outdoor_time_score(
    place,
    visit_start,
    weather_by_date,
):

    if not place.get("is_outdoor"):

        return 0.0, None

    score = 0.0

    note = None

    hour = visit_start.hour

    day_weather = weather_by_date.get(visit_start.date().isoformat())

    if 11 <= hour < 16:

        score -= 2.0

        note = "مكان خارجي في وقت الظهر"

    if day_weather == "hot":

        score -= 3.0

        note = "مكان خارجي والطقس حار"

    elif day_weather in {
        "rainy",
        "stormy",
    }:

        score -= 4.0

        note = f"مكان خارجي والطقس: " f"{day_weather}"

    return score, note


# ============================================================

# Diversity

# ============================================================


def diversity_score(
    place,
    daily_categories,
):

    category = str(place.get("category") or "غير محدد")

    count = daily_categories.get(category, 0)

    if count == 0:

        return 1.2

    if count == 1:

        return -0.5

    return -2.0


# ============================================================

# Routing

# ============================================================


def get_routing_options(
    origin,
    destination,
    route_cache=None,
):
    """

    Uses ORS Matrix Cache first.



    If ORS fails or route is missing,

    Haversine is used as fallback.

    """

    if origin is None:

        return {
            "walking": {
                "duration_minutes": 0,
                "distance_km": 0,
            },
            "driving": {
                "duration_minutes": 0,
                "distance_km": 0,
            },
            "recommended_mode": "walking",
            "source": "start",
        }

    # --------------------------------------------------------

    # ORS Matrix Cache

    # --------------------------------------------------------

    if route_cache is not None:

        try:

            result = get_cached_route(
                route_cache,
                origin,
                destination,
            )

            if result:

                walking = result.get("walking")

                driving = result.get("driving")

                if walking is not None or driving is not None:

                    return result

        except Exception:

            pass

    # --------------------------------------------------------

    # Haversine fallback

    # --------------------------------------------------------

    distance_km = haversine_km(
        origin,
        destination,
    )

    driving_minutes = max(1, math.ceil((distance_km / DEFAULT_AVG_SPEED_KMH) * 60))

    walking_minutes = max(1, math.ceil((distance_km / DEFAULT_WALKING_SPEED_KMH) * 60))

    recommended_mode = "walking" if distance_km <= 1.5 else "driving"

    return {
        "walking": {
            "duration_minutes": walking_minutes,
            "distance_km": round(distance_km, 2),
        },
        "driving": {
            "duration_minutes": driving_minutes,
            "distance_km": round(distance_km, 2),
        },
        "recommended_mode": recommended_mode,
        "source": "haversine_fallback",
    }


def choose_transport_option(
    routing,
    transport_mode="auto",
):

    walking = routing.get("walking")

    driving = routing.get("driving")

    # --------------------------------------------------------

    # Force walking

    # --------------------------------------------------------

    if transport_mode == "walking":

        if walking is not None:

            return ("walking", walking)

    # --------------------------------------------------------

    # Force driving

    # --------------------------------------------------------

    if transport_mode == "driving":

        if driving is not None:

            return ("driving", driving)

    # --------------------------------------------------------

    # Auto

    # --------------------------------------------------------

    recommended = routing.get("recommended_mode")

    if recommended == "walking" and walking is not None:

        return ("walking", walking)

    if recommended == "driving" and driving is not None:

        return ("driving", driving)

    # --------------------------------------------------------

    # Fallback

    # --------------------------------------------------------

    if driving is not None:

        return ("driving", driving)

    if walking is not None:

        return ("walking", walking)

    return (
        "unknown",
        {
            "duration_minutes": 1,
            "distance_km": 0,
        },
    )


# ============================================================

# Planner

# ============================================================


def build_free_time_gaps(
    plan, places_by_id, window_start, window_end, safety_buffer_minutes=5
):
    """Usable gaps only: reserve the next leg's travel before its activity."""

    gaps_by_date = {}

    for date_key, stops in plan.items():

        date = datetime.strptime(date_key, "%Y-%m-%d").date()

        day_start = datetime.combine(date, window_start)

        day_end = datetime.combine(date, window_end)

        gaps = []

        for previous, following in zip(stops, stops[1:]):

            previous_end = datetime.combine(date, parse_hhmm(previous["end"]))

            next_start = datetime.combine(date, parse_hhmm(following["start"]))

            travel = following.get("estimated_travel_minutes")

            if travel is None or travel < 0:

                continue

            travel = math.ceil(travel)

            start = max(previous_end, day_start)

            end = min(
                next_start - timedelta(minutes=travel + safety_buffer_minutes), day_end
            )

            available = math.floor((end - start).total_seconds() / 60)

            location = get_coordinates(places_by_id[previous["place_id"]])

            destination = get_coordinates(places_by_id[following["place_id"]])

            if available <= 0 or location is None or destination is None:

                continue

            gaps.append(
                {
                    "start": start.strftime("%H:%M"),
                    "end": end.strftime("%H:%M"),
                    "available_minutes": available,
                    "location": {"lat": location[0], "lng": location[1]},
                    "origin_name": (
                        places_by_id[previous["place_id"]].get("name_ar")
                        or places_by_id[previous["place_id"]].get("name_en")
                    ),
                    "next_destination": {"lat": destination[0], "lng": destination[1]},
                    "next_destination_name": (
                        places_by_id[following["place_id"]].get("name_ar")
                        or places_by_id[following["place_id"]].get("name_en")
                    ),
                    "next_activity_start": following["start"],
                    "start_datetime": start.replace(
                        tzinfo=ZoneInfo("Asia/Riyadh")
                    ).isoformat(),
                    "end_datetime": end.replace(
                        tzinfo=ZoneInfo("Asia/Riyadh")
                    ).isoformat(),
                    "next_activity_start_datetime": next_start.replace(
                        tzinfo=ZoneInfo("Asia/Riyadh")
                    ).isoformat(),
                    "travel_minutes_to_next": travel,
                    "safety_buffer_minutes": safety_buffer_minutes,
                    "previous_place_id": previous["place_id"],
                    "next_place_id": following["place_id"],
                }
            )

        gaps_by_date[date_key] = gaps

    return gaps_by_date


def recommend_and_plan(
    places,
    user_preferences,
    preferred_time,
    arrival_dt,
    departure_dt,
    lodging_coordinates=None,
    selected_place_ids=None,
    visited_place_ids=None,
    weather_by_date=None,
    max_travel_distance_km=None,
    max_places_per_day=None,
    transport_mode="auto",
):

    weather_by_date = weather_by_date or {}

    visited_place_ids = set(visited_place_ids or [])

    selected_place_ids = (
        set(selected_place_ids) if selected_place_ids is not None else None
    )

    preferred_time = normalize_preferred_time(preferred_time)

    # Departure is checkout, independent of the clock time supplied by callers.

    departure_dt = datetime.combine(departure_dt.date(), time.min)

    # --------------------------------------------------------

    # 1. Clean places

    # --------------------------------------------------------

    unique_places = {}

    for place in places:

        place_id = place.get("place_id")

        if not place_id:

            continue

        if place_id in visited_place_ids:

            continue

        if selected_place_ids is not None and place_id not in selected_place_ids:

            continue

        if get_coordinates(place) is None:

            continue

        unique_places[place_id] = dict(place)

    candidates = list(unique_places.values())

    # --------------------------------------------------------

    # 2. Initial ranking

    # --------------------------------------------------------

    ranked = []

    for place in candidates:

        interest = preference_score(
            place,
            user_preferences,
        )

        # If user didn't manually choose places,

        # exclude unrelated places.

        if selected_place_ids is None and user_preferences and interest <= 0:

            continue

        base_score = interest * 12

        base_score += category_bonus(
            place,
            user_preferences,
        )

        # Manual choice gets priority

        if (
            selected_place_ids is not None
            and place.get("place_id") in selected_place_ids
        ):

            base_score += 20

        ranked.append(
            (
                base_score,
                place,
            )
        )

    ranked.sort(
        key=lambda item: item[0],
        reverse=True,
    )

    remaining = [place for _, place in ranked]

    # ========================================================

    # 3. Build ORS Matrix Cache ONCE

    # ========================================================

    routing_locations = []

    if lodging_coordinates is not None:

        routing_locations.append(lodging_coordinates)

    for place in remaining:

        coords = get_coordinates(place)

        if coords is not None:

            routing_locations.append(coords)

    route_cache = None

    if routing_locations:

        print(f"Preparing route matrix for " f"{len(routing_locations)} locations...")

        try:

            route_cache = build_route_cache(routing_locations)

            if route_cache.get("walking_error"):

                print("Walking Matrix warning:", route_cache["walking_error"])

            if route_cache.get("driving_error"):

                print("Driving Matrix warning:", route_cache["driving_error"])

        except Exception as e:

            print("Route Matrix failed. " "Using Haversine fallback:", str(e))

            route_cache = None

    # --------------------------------------------------------

    # 4. Build dynamic plan

    # --------------------------------------------------------

    window_start, window_end = PLANNING_WINDOWS.get(
        preferred_time, PLANNING_WINDOWS["any"]
    )

    current_dt = max(arrival_dt, datetime.combine(arrival_dt.date(), window_start))

    current_location = lodging_coordinates

    plan = defaultdict(list)

    planning_date = arrival_dt.date()

    while planning_date < departure_dt.date():

        plan[planning_date.isoformat()] = []

        planning_date += timedelta(days=1)

    scheduled_ids = set()

    blocked_reasons = defaultdict(set)

    while remaining and current_dt < departure_dt:

        date_key = current_dt.date().isoformat()

        day_start = max(datetime.combine(current_dt.date(), window_start), arrival_dt)

        day_end = min(datetime.combine(current_dt.date(), window_end), departure_dt)

        current_dt = max(current_dt, day_start)

        # Every new day starts at the selected accommodation and window start.

        if current_dt >= day_end or (
            max_places_per_day is not None and len(plan[date_key]) >= max_places_per_day
        ):

            current_dt = datetime.combine(
                current_dt.date() + timedelta(days=1),
                window_start,
            )

            current_location = lodging_coordinates

            continue

        daily_categories = Counter(
            item.get(
                "category",
                "غير محدد",
            )
            for item in plan[date_key]
        )

        best_choice = None

        best_choice_value = None

        # ----------------------------------------------------

        # Compare remaining places

        # ----------------------------------------------------

        for place in remaining:

            coords = get_coordinates(place)

            if coords is None:

                continue

            # ================================================

            # Routing from Matrix Cache

            # ================================================

            routing = get_routing_options(
                current_location,
                coords,
                route_cache=route_cache,
            )

            (
                travel_mode_used,
                route_data,
            ) = choose_transport_option(
                routing,
                transport_mode=transport_mode,
            )

            travel_minutes = math.ceil(route_data.get("duration_minutes") or 0)

            distance_km = route_data.get("distance_km") or 0

            # Never allow zero travel between different points

            if (
                current_location is not None
                and current_location != coords
                and travel_minutes <= 0
            ):

                travel_minutes = 1

            # ================================================

            # Maximum travel distance

            # ================================================

            if (
                max_travel_distance_km is not None
                and distance_km > max_travel_distance_km
            ):

                blocked_reasons[place["place_id"]].add("travel_distance")

                continue

            # ================================================

            # Visit timing

            # ================================================

            start_dt = current_dt + timedelta(minutes=travel_minutes)

            duration = get_visit_duration_minutes(place)

            end_dt = start_dt + timedelta(minutes=duration)

            # Travel and the entire visit must fit within this day's window.

            if end_dt > day_end:

                reasons = blocked_reasons[place["place_id"]]

                if start_dt >= day_end:

                    reasons.add("travel_time")

                elif duration > (day_end - day_start).total_seconds() / 60:

                    reasons.add("visit_duration")

                else:

                    reasons.add("remaining_time")

                continue

            # ================================================

            # Opening hours

            # ================================================

            (
                is_open,
                opening_note,
            ) = is_open_for_visit(
                place,
                start_dt,
                end_dt,
            )

            if not is_open:

                # Try waiting until the exact opening boundary on the same day
                # before deciding that the place cannot be scheduled.

                day_hours = (place.get("opening_hours") or {}).get(
                    WEEKDAYS_AR[start_dt.weekday()], {}
                )

                intervals = day_hours.get("intervals", [])

                openings = sorted(
                    datetime.combine(start_dt.date(), parse_hhmm(interval["open"]))
                    for interval in intervals
                    if interval.get("open")
                )

                for opening in openings:

                    candidate_start = max(start_dt, opening)

                    candidate_end = candidate_start + timedelta(minutes=duration)

                    if candidate_end > day_end:

                        continue

                    candidate_open, candidate_note = is_open_for_visit(
                        place, candidate_start, candidate_end
                    )

                    if candidate_open:

                        start_dt, end_dt = candidate_start, candidate_end

                        is_open, opening_note = True, candidate_note

                        break

                if not is_open:

                    place_id = place["place_id"]

                    if not intervals:

                        blocked_reasons[place_id].add("closed")

                    else:

                        blocked_reasons[place_id].add("opening_hours")

                    continue

            # ================================================

            # Score

            # ================================================

            interest = preference_score(
                place,
                user_preferences,
            )

            score = interest * 12

            score += category_bonus(
                place,
                user_preferences,
            )

            # User-selected places have priority

            if selected_place_ids is not None:

                score += 20

            # Lower travel time = higher score

            score -= travel_minutes * 0.35

            # Lower distance = higher score

            score -= distance_km * 0.3

            (
                time_score,
                time_notes,
            ) = time_suitability_score(
                place,
                start_dt,
                preferred_time,
            )

            score += time_score

            (
                outdoor_score,
                outdoor_note,
            ) = outdoor_time_score(
                place,
                start_dt,
                weather_by_date,
            )

            score += outdoor_score

            score += diversity_score(
                place,
                daily_categories,
            )

            # ================================================

            # Best candidate

            # ================================================

            if best_choice_value is None or score > best_choice_value:

                best_choice_value = score

                best_choice = {
                    "place": place,
                    "distance_km": round(distance_km, 2),
                    "travel_minutes": int(travel_minutes),
                    "travel_mode": travel_mode_used,
                    "walking_option": routing.get("walking"),
                    "driving_option": routing.get("driving"),
                    "recommended_mode": routing.get("recommended_mode"),
                    "routing_source": routing.get("source"),
                    "start": start_dt,
                    "end": end_dt,
                    "opening_note": opening_note,
                    "outdoor_note": outdoor_note,
                    "time_notes": time_notes,
                    "score": round(score, 2),
                    "interest_score": round(interest, 2),
                }

        # ----------------------------------------------------

        # No place fits now

        # ----------------------------------------------------

        if best_choice is None:

            current_dt += timedelta(minutes=30)

            continue

        # ----------------------------------------------------

        # Add selected place

        # ----------------------------------------------------

        place = best_choice["place"]

        place_id = place.get("place_id")

        name_ar = place.get("name_ar")

        reason_parts = []

        if selected_place_ids is not None:

            reason_parts.append("من الأماكن التي اختارها المستخدم")

        if best_choice["interest_score"] > 0:

            reason_parts.append("متوافق مع اهتمامات المستخدم")

        if best_choice["travel_minutes"] <= 10:

            reason_parts.append("قريب نسبيًا من المكان السابق")

        if best_choice["time_notes"]:

            reason_parts.extend(best_choice["time_notes"])

        if best_choice["outdoor_note"]:

            reason_parts.append(best_choice["outdoor_note"])

        plan[date_key].append(
            {
                "place_id": place_id,
                "name_ar": name_ar,
                "name_en": place.get("name_en"),
                "category": place.get("category"),
                "start": best_choice["start"].strftime("%H:%M"),
                "end": best_choice["end"].strftime("%H:%M"),
                "visit_minutes": get_visit_duration_minutes(place),
                "distance_from_previous_km": best_choice["distance_km"],
                "estimated_travel_minutes": best_choice["travel_minutes"],
                "travel_mode": best_choice["travel_mode"],
                "recommended_mode": best_choice["recommended_mode"],
                "walking_option": best_choice["walking_option"],
                "driving_option": best_choice["driving_option"],
                "routing_source": best_choice["routing_source"],
                "total_time_used_minutes": best_choice["travel_minutes"]
                + get_visit_duration_minutes(place),
                "rule_score": best_choice["score"],
                "reason": (
                    "، ".join(reason_parts)
                    if reason_parts
                    else "مناسب ضمن الوقت المتاح"
                ),
                "opening_hours_note": best_choice["opening_note"],
            }
        )

        scheduled_ids.add(place_id)

        # ----------------------------------------------------

        # Update time and location

        # ----------------------------------------------------

        current_dt = best_choice["end"]

        current_location = get_coordinates(place)

        # Remove visited place

        remaining = [p for p in remaining if p.get("place_id") != place_id]

    # ========================================================

    # Unscheduled places

    # ========================================================

    unscheduled_places = []

    reason_messages = {
        "closed": "المكان مغلق في الوقت المحدد.",
        "travel_time": "وقت الوصول إلى المكان لا يتناسب مع وقت الخطة.",
        "visit_duration": "مدة الزيارة أطول من الوقت المتاح.",
        "remaining_time": "الوقت المتبقي لا يكفي للوصول والزيارة.",
        "opening_hours": "ساعات عمل المكان لا تسمح بزيارة كاملة ضمن الوقت المحدد.",
        "travel_distance": "المكان أبعد من نطاق التنقل المحدد.",
        "no_available_time": "لا يوجد وقت متاح لجدولة المكان ضمن أيام الرحلة.",
    }

    for place in remaining:

        place_id = place["place_id"]

        reason_codes = sorted(blocked_reasons[place_id])

        if not reason_codes:

            reason_codes = ["no_available_time"]

        is_closed = "closed" in reason_codes

        if is_closed:

            primary_reason = "المكان مغلق في الوقت المحدد."

        else:

            primary_reason = " ".join(
                reason_messages.get(code, "تعذر جدولة المكان.") for code in reason_codes
            )

        unscheduled_places.append(
            {
                "place_id": place.get("place_id"),
                "name_ar": place.get("name_ar"),
                "name_en": place.get("name_en"),
                "reason_codes": reason_codes,
                "reason": primary_reason,
                "can_replace": is_closed,
                "status": "closed" if is_closed else "unscheduled",
            }
        )

    # ========================================================

    # Return result

    # ========================================================

    return {
        "plan": dict(plan),
        "planning_dates": list(plan),
        "free_time_gaps": build_free_time_gaps(
            plan, unique_places, window_start, window_end
        ),
        "scheduled_place_ids": sorted(scheduled_ids),
        "unscheduled_places": unscheduled_places,
        "notes": [
            "عدد الأماكن ديناميكي وليس رقمًا ثابتًا.",
            "الخطة تعتمد على الوقت المتاح ومدة الزيارة وساعات العمل.",
            "يتم تحميل Matrix للمشي والسيارة مرة واحدة في بداية التخطيط.",
            "يتم استخدام openrouteservice لحساب طرق المشي والسيارة.",
            "لا يتم إرسال طلب API جديد لكل مقارنة بين الأماكن.",
            "يمكن اختيار transport_mode = auto أو walking أو driving.",
            "إذا فشل openrouteservice يتم استخدام Haversine كحل احتياطي.",
            "الأماكن التي يختارها المستخدم من الخريطة لها الأولوية.",
            "السعر غير مستخدم حاليًا.",
        ],
    }
