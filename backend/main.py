from datetime import datetime
from typing import Literal
import os

import firebase_admin

from fastapi import (
    FastAPI,
    HTTPException,
)

from fastapi.middleware.cors import (
    CORSMiddleware,
)

from firebase_admin import (
    credentials,
    firestore,
)

from pydantic import (
    BaseModel,
    Field,
)


from rahhal_rules_dynamic import (
    load_places_from_firestore,
    recommend_and_plan,
)

from llm.plan_explainer import (
    explain_plan,
)

from llm.discover_explainer import (
    explain_discover_now,
)

from services.discover_now_service import (
    discover_now,
)

from services.shade_route_service import (
    calculate_shade_route,
)

# ============================================================
# FastAPI
# ============================================================

app = FastAPI(
    title="Rihal API",
    version="1.0.0",
)


# ============================================================
# CORS
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# Firebase
# ============================================================

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

FIREBASE_KEY_PATH = os.path.join(
    BASE_DIR,
    "firebase_key.json",
)


if not firebase_admin._apps:

    cred = credentials.Certificate(FIREBASE_KEY_PATH)

    firebase_admin.initialize_app(cred)


db = firestore.client()


# ============================================================
# Models
# ============================================================


class UserLocation(BaseModel):
    lat: float
    lng: float


class PlannerRequest(BaseModel):

    interests: list[str] = Field(default_factory=list)

    selected_place_ids: list[str] = Field(default_factory=list)

    start_datetime: datetime

    end_datetime: datetime

    user_location: UserLocation

    preferred_time: str = "any"

    transport_mode: str = "auto"


class DiscoverNowRequest(BaseModel):

    user_location: UserLocation

    available_minutes: int = Field(
        gt=0,
        le=1440,
    )

    transport_mode: str = "walking"

    safety_buffer_minutes: int = Field(
        default=5,
        ge=0,
        le=30,
    )

    max_results: int = Field(
        default=10,
        ge=1,
        le=20,
    )
    category: Literal["all", "cafes", "markets"] | None = None
    next_destination: UserLocation | None = None
    departure_datetime: datetime | None = None
    next_activity_start: datetime | None = None


class ShadeRouteRequest(BaseModel):

    origin: UserLocation

    destination: UserLocation

    departure_datetime: datetime | None = None


# ============================================================
# Home
# ============================================================


@app.get("/")
def home():

    return {"message": "Welcome to Rihal API!"}


# ============================================================
# Firebase Test
# ============================================================


@app.get("/firebase-test")
def firebase_test():

    return {
        "message": "Firebase connected successfully",
        "project": "Rihal",
    }


# ============================================================
# Places
# ============================================================


@app.get("/places")
def get_places():

    docs = db.collection("places").stream()

    places = []

    for doc in docs:

        data = doc.to_dict()

        places.append(
            {
                "document_id": doc.id,
                **data,
            }
        )

    return {
        "count": len(places),
        "places": places,
    }


# ============================================================
# Planner
# ============================================================


@app.post("/planner")
def create_plan(request: PlannerRequest):

    try:

        # ----------------------------------------------------
        # Validate dates
        # ----------------------------------------------------

        if request.end_datetime <= request.start_datetime:

            raise HTTPException(
                status_code=400,
                detail=("end_datetime must be " "after start_datetime"),
            )

        # ----------------------------------------------------
        # Validate transport
        # ----------------------------------------------------

        allowed_transport_modes = {
            "auto",
            "walking",
            "driving",
        }

        if request.transport_mode not in allowed_transport_modes:

            raise HTTPException(
                status_code=400,
                detail=("transport_mode must be " "auto, walking, or driving"),
            )

        # ----------------------------------------------------
        # Firebase places
        # ----------------------------------------------------

        places = load_places_from_firestore(db)

        if not places:

            raise HTTPException(
                status_code=404,
                detail=("No places found in Firebase"),
            )

        # ----------------------------------------------------
        # User location
        # ----------------------------------------------------

        user_coordinates = (
            request.user_location.lat,
            request.user_location.lng,
        )

        # ----------------------------------------------------
        # Planner
        # ----------------------------------------------------

        planner_result = recommend_and_plan(
            places=places,
            user_preferences=(request.interests),
            preferred_time=(request.preferred_time),
            arrival_dt=(request.start_datetime),
            departure_dt=(request.end_datetime),
            lodging_coordinates=(user_coordinates),
            selected_place_ids=(
                request.selected_place_ids if request.selected_place_ids else None
            ),
            visited_place_ids=[],
            weather_by_date={},
            max_travel_distance_km=None,
            max_places_per_day=None,
            transport_mode=(request.transport_mode),
        )

        # ----------------------------------------------------
        # LLM explanation
        # ----------------------------------------------------

        try:
            explanation = explain_plan(planner_result)
        except Exception:
            # A narrative outage must not discard an otherwise valid schedule.
            explanation = ""

        # ----------------------------------------------------
        # Response
        # ----------------------------------------------------

        return {
            "success": True,
            "plan": planner_result.get("plan", {}),
            "planning_dates": planner_result.get("planning_dates", list(planner_result.get("plan", {}))),
            "free_time_gaps": planner_result.get("free_time_gaps", {}),
            "explanation": explanation,
            "scheduled_place_ids": planner_result.get("scheduled_place_ids", []),
            "unscheduled_places": planner_result.get("unscheduled_places", []),
            "notes": planner_result.get("notes", []),
        }

    except HTTPException:

        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# Discover Now
# ============================================================


@app.post("/discover-now")
def discover_now_endpoint(request: DiscoverNowRequest):

    try:

        # ----------------------------------------------------
        # Validate transport
        # ----------------------------------------------------

        allowed_transport_modes = {
            "auto",
            "walking",
            "driving",
        }

        if request.transport_mode not in allowed_transport_modes:

            raise HTTPException(
                status_code=400,
                detail=("transport_mode must be " "auto, walking, or driving"),
            )

        # ----------------------------------------------------
        # Discover
        # ----------------------------------------------------

        if request.next_activity_start is not None and (
            request.next_destination is None or request.departure_datetime is None
        ):
            raise HTTPException(status_code=400, detail="Next activity requires destination and departure time")

        result = discover_now(
            latitude=(request.user_location.lat),
            longitude=(request.user_location.lng),
            available_minutes=(request.available_minutes),
            transport_mode=(request.transport_mode),
            safety_buffer_minutes=(request.safety_buffer_minutes),
            max_results=(request.max_results),
            category_filter=request.category,
            next_destination=(
                (request.next_destination.lat, request.next_destination.lng)
                if request.next_destination is not None else None
            ),
            departure_datetime=request.departure_datetime,
            next_activity_start=request.next_activity_start,
        )

        # ----------------------------------------------------
        # LLM explanation
        # ----------------------------------------------------

        try:
            explanation = explain_discover_now(
                discover_result=result,
                available_minutes=result.get("available_minutes", request.available_minutes),
            )
        except Exception:
            # Keep validated options available when only the narrative fails.
            explanation = ""

        # ----------------------------------------------------
        # Response
        # ----------------------------------------------------

        return {
            "success": True,
            "user_location": {
                "lat": request.user_location.lat,
                "lng": request.user_location.lng,
            },
            "available_minutes": result.get("available_minutes", request.available_minutes),
            "transport_mode": request.transport_mode,
            "search_radius_meters": result.get("search_radius_meters"),
            "search_available": result.get(
                "search_available",
                True,
            ),
            "message": result.get("message"),
            "searched_count": result.get(
                "searched_count",
                0,
            ),
            "suitable_count": result.get(
                "suitable_count",
                0,
            ),
            "places": result.get(
                "places",
                [],
            ),
            "explanation": explanation,
        }

    except HTTPException:

        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# Shaded Walking Route
# ============================================================


@app.post("/shade-route")
def shade_route_endpoint(request: ShadeRouteRequest):

    try:

        result = calculate_shade_route(
            origin_lat=(request.origin.lat),
            origin_lng=(request.origin.lng),
            destination_lat=(request.destination.lat),
            destination_lng=(request.destination.lng),
            departure_datetime=(request.departure_datetime),
        )

        return {
            "success": True,
            **result,
        }

    except ValueError as e:

        raise HTTPException(
            status_code=400,
            detail=str(e),
        )

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )
