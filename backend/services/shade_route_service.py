import math
import os
import re
from datetime import datetime
from zoneinfo import ZoneInfo

import networkx as nx
import osmium
import pandas as pd

from astral import Observer
from astral.sun import azimuth, elevation

from pyproj import Transformer

from shapely.geometry import (
    LineString,
    Polygon,
)

from shapely.ops import transform

# ============================================================
# Paths
# ============================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DATA_DIR = os.path.join(
    BASE_DIR,
    "data",
)

NODES_FILE = os.path.join(
    DATA_DIR,
    "madinah_walking_nodes.parquet",
)

EDGES_FILE = os.path.join(
    DATA_DIR,
    "madinah_walking_edges.parquet",
)

PBF_FILE = os.path.join(
    DATA_DIR,
    "madinah.osm.pbf",
)

PLACES_FILE = os.path.join(
    DATA_DIR,
    "places_with_nearest_nodes.csv",
)


# ============================================================
# Settings
# ============================================================

TZ = ZoneInfo("Asia/Riyadh")

DEFAULT_BUILDING_HEIGHT_M = 10.0

MAX_DETOUR_RATIO = 1.50

EXPOSURE_PENALTY = 4.0

ANALYSIS_BUFFER_M = 250

WALKING_SPEED_M_PER_SECOND = 1.2


# ============================================================
# Coordinate Systems
# ============================================================

# WGS84 -> UTM Zone 37N
# مناسب لمنطقة المدينة المنورة

TO_METERS = Transformer.from_crs(
    "EPSG:4326",
    "EPSG:32637",
    always_xy=True,
).transform


TO_LATLON = Transformer.from_crs(
    "EPSG:32637",
    "EPSG:4326",
    always_xy=True,
).transform


# ============================================================
# Helpers
# ============================================================


def normalize_id(value):

    if pd.isna(value):
        return None

    try:

        number = float(value)

        if number.is_integer():
            return str(int(number))

    except (
        ValueError,
        TypeError,
    ):
        pass

    return str(value).strip()


def haversine_m(
    a,
    b,
):
    lat1, lon1 = a
    lat2, lon2 = b

    radius = 6371000.0

    p1 = math.radians(lat1)

    p2 = math.radians(lat2)

    dp = math.radians(lat2 - lat1)

    dl = math.radians(lon2 - lon1)

    h = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2

    return (
        2
        * radius
        * math.asin(
            min(
                1.0,
                math.sqrt(h),
            )
        )
    )


# ============================================================
# Validate Files
# ============================================================

required_files = [
    NODES_FILE,
    EDGES_FILE,
    PBF_FILE,
    PLACES_FILE,
]


for file_path in required_files:

    if not os.path.isfile(file_path):

        raise FileNotFoundError(f"Required shade route file not found: " f"{file_path}")


# ============================================================
# Load Walking Network
# ============================================================

print("Loading Rihal shaded walking network...")

nodes = pd.read_parquet(NODES_FILE)

edges = pd.read_parquet(EDGES_FILE)


# ============================================================
# Detect Columns
# ============================================================


def find_column(
    dataframe,
    candidates,
    required=True,
):

    for column in candidates:

        if column in dataframe.columns:
            return column

    if required:

        raise ValueError(
            f"Could not find any of these columns: "
            f"{candidates}. "
            f"Available columns: "
            f"{list(dataframe.columns)}"
        )

    return None


node_id_col = find_column(
    nodes,
    [
        "id",
        "osmid",
        "node_id",
        "nearest_node_id",
    ],
)

node_lat_col = find_column(
    nodes,
    [
        "lat",
        "latitude",
        "y",
        "node_lat",
    ],
)

node_lon_col = find_column(
    nodes,
    [
        "lon",
        "lng",
        "longitude",
        "x",
        "node_lon",
    ],
)

edge_u_col = find_column(
    edges,
    [
        "u",
        "source",
        "from",
        "u_id",
    ],
)

edge_v_col = find_column(
    edges,
    [
        "v",
        "target",
        "to",
        "v_id",
    ],
)

edge_length_col = find_column(
    edges,
    [
        "length",
        "length_m",
        "distance_m",
    ],
    required=False,
)


# ============================================================
# Prepare Nodes
# ============================================================

nodes["_rihal_id"] = nodes[node_id_col].map(normalize_id)

node_latlon = {}


for _, row in nodes.iterrows():

    node_id = row["_rihal_id"]

    if node_id is None:
        continue

    try:

        latitude = float(row[node_lat_col])

        longitude = float(row[node_lon_col])

        if not (
            math.isfinite(latitude)
            and math.isfinite(longitude)
            and -90 <= latitude <= 90
            and -180 <= longitude <= 180
        ):
            continue

    except (
        ValueError,
        TypeError,
    ):
        continue

    node_latlon[node_id] = (
        latitude,
        longitude,
    )


# ============================================================
# Build Walking Graph
# ============================================================

G = nx.Graph()


for node_id, (
    latitude,
    longitude,
) in node_latlon.items():

    G.add_node(
        node_id,
        lat=latitude,
        lon=longitude,
    )


for _, row in edges.iterrows():

    u = normalize_id(row[edge_u_col])

    v = normalize_id(row[edge_v_col])

    if u not in G or v not in G or u == v:
        continue

    try:

        if edge_length_col and pd.notna(row[edge_length_col]):

            length = float(row[edge_length_col])

        else:

            length = haversine_m(
                node_latlon[u],
                node_latlon[v],
            )

    except (
        ValueError,
        TypeError,
        KeyError,
    ):
        continue

    if not math.isfinite(length) or length <= 0:
        continue

    # لو فيه أكثر من وصلة بين نفس العقدتين،
    # نحتفظ بالأقصر.

    if G.has_edge(
        u,
        v,
    ):

        old_length = G[u][v]["length"]

        if old_length <= length:
            continue

    G.add_edge(
        u,
        v,
        length=length,
        _shade_fraction=0.0,
        _shade_known=False,
    )


print(
    "Walking nodes:",
    G.number_of_nodes(),
)

print(
    "Walking edges:",
    G.number_of_edges(),
)


if G.number_of_nodes() == 0 or G.number_of_edges() == 0:

    raise RuntimeError("تعذر تجهيز شبكة المشي.")


# ============================================================
# Cached Node Lists
# ============================================================

NODE_IDS = list(node_latlon.keys())

NODE_COORDINATES = [node_latlon[node_id] for node_id in NODE_IDS]


# ============================================================
# Nearest Graph Node
# ============================================================


def nearest_graph_node(
    latitude,
    longitude,
):

    best_node = None

    best_distance = float("inf")

    target = (
        latitude,
        longitude,
    )

    for node_id, node_location in zip(
        NODE_IDS,
        NODE_COORDINATES,
    ):

        distance = haversine_m(
            target,
            node_location,
        )

        if distance < best_distance:

            best_distance = distance

            best_node = node_id

    return (
        best_node,
        best_distance,
    )


# ============================================================
# Building Height
# ============================================================


def parse_building_height(
    tags,
):

    raw_height = tags.get("height")

    if raw_height:

        text = str(raw_height).strip().lower()

        match = re.match(
            r"^\s*(\d+(?:\.\d+)?)\s*" r"(m|meter|meters|metre|metres|ft|feet)?\s*$",
            text,
        )

        if match:

            value = float(match.group(1))

            unit = match.group(2)

            if unit in (
                "ft",
                "feet",
            ):

                value *= 0.3048

            if 1 <= value <= 300:

                return (
                    value,
                    "explicit_height",
                )

    raw_levels = tags.get("building:levels")

    if raw_levels:

        try:

            levels = float(raw_levels)

            if 1 <= levels <= 100:

                return (
                    levels * 3.0,
                    "levels_height",
                )

        except (
            ValueError,
            TypeError,
        ):
            pass

    return (
        DEFAULT_BUILDING_HEIGHT_M,
        "default_height",
    )


# ============================================================
# Building Extraction
# ============================================================


class LocalBuildingHandler(osmium.SimpleHandler):

    def __init__(
        self,
        analysis_area,
        bounds,
    ):

        super().__init__()

        self.analysis_area = analysis_area

        (
            self.west,
            self.south,
            self.east,
            self.north,
        ) = bounds

        self.buildings = []

        self.stats = {
            "total": 0,
            "explicit_height": 0,
            "levels_height": 0,
            "default_height": 0,
            "invalid_geometry": 0,
        }

    def way(
        self,
        way,
    ):

        tags = way.tags

        if not tags.get("building"):
            return

        coords = []

        try:

            for node in way.nodes:

                if not (node.location.valid()):
                    return

                lon = node.location.lon

                lat = node.location.lat

                coords.append(
                    (
                        lon,
                        lat,
                    )
                )

        except Exception:
            return

        if len(coords) < 4:
            return

        if coords[0] != coords[-1]:
            return

        # Quick bounding-box filter

        xs = [point[0] for point in coords]

        ys = [point[1] for point in coords]

        if (
            max(xs) < self.west
            or min(xs) > self.east
            or max(ys) < self.south
            or min(ys) > self.north
        ):
            return

        try:

            polygon_ll = Polygon(coords)

            if not (polygon_ll.is_valid):

                polygon_ll = polygon_ll.buffer(0)

            if polygon_ll.is_empty or polygon_ll.area == 0:

                self.stats["invalid_geometry"] += 1

                return

            polygon_m = transform(
                TO_METERS,
                polygon_ll,
            )

            if not (polygon_m.intersects(self.analysis_area)):
                return

            height, source = parse_building_height(tags)

            self.buildings.append(
                (
                    polygon_m,
                    height,
                )
            )

            self.stats["total"] += 1

            self.stats[source] += 1

        except Exception:

            self.stats["invalid_geometry"] += 1


# ============================================================
# Shadow Projection
# ============================================================


def project_shadow(
    building,
    height,
    azimuth_deg,
    elevation_deg,
):

    if elevation_deg <= 1:
        return None

    shadow_bearing = math.radians((azimuth_deg + 180.0) % 360.0)

    shadow_length = height / math.tan(math.radians(elevation_deg))

    # حماية من الظلال شديدة الطول
    shadow_length = max(
        0.0,
        min(
            shadow_length,
            200.0,
        ),
    )

    dx = shadow_length * math.sin(shadow_bearing)

    dy = shadow_length * math.cos(shadow_bearing)

    shifted = transform(
        lambda x, y, z=None: (
            x + dx,
            y + dy,
        ),
        building,
    )

    return building.union(shifted).convex_hull


# ============================================================
# Path Helpers
# ============================================================


def path_distance(
    path,
):

    return sum(
        G[a][b]["length"]
        for a, b in zip(
            path[:-1],
            path[1:],
        )
    )


def path_coordinates(
    path,
):

    coordinates = []

    for node_id in path:

        lat, lon = node_latlon[node_id]

        coordinates.append(
            {
                "lat": round(
                    lat,
                    7,
                ),
                "lng": round(
                    lon,
                    7,
                ),
            }
        )

    return coordinates


# ============================================================
# Summarize Route
# ============================================================


def summarize_path(
    path,
):

    distance = path_distance(path)

    duration_minutes = distance / WALKING_SPEED_M_PER_SECOND / 60

    known_length = 0.0

    shaded_length = 0.0

    for u, v in zip(
        path[:-1],
        path[1:],
    ):

        edge = G[u][v]

        if edge.get(
            "_shade_known",
            False,
        ):

            length = edge["length"]

            known_length += length

            shaded_length += length * edge.get(
                "_shade_fraction",
                0.0,
            )

    shade_percent = None

    if known_length > 0:

        shade_percent = 100 * shaded_length / known_length

    evaluated_percent = 0.0

    if distance > 0:

        evaluated_percent = 100 * known_length / distance

    return {
        "distance_meters": round(distance),
        "duration_minutes": round(
            duration_minutes,
            1,
        ),
        "shade_percent": (
            round(
                shade_percent,
                1,
            )
            if shade_percent is not None
            else None
        ),
        "evaluated_route_percent": round(
            evaluated_percent,
            1,
        ),
        "node_count": len(path),
        "coordinates": path_coordinates(path),
    }


# ============================================================
# Main Function
# ============================================================


def calculate_shade_route(
    origin_lat,
    origin_lng,
    destination_lat,
    destination_lng,
    departure_datetime=None,
):

    # ========================================================
    # 1. Departure Time
    # ========================================================

    if departure_datetime is None:

        departure = datetime.now(TZ)

    else:

        departure = departure_datetime

        if departure.tzinfo is None:

            departure = departure.replace(tzinfo=TZ)

        else:

            departure = departure.astimezone(TZ)

    # ========================================================
    # 2. Snap Coordinates to Walking Graph
    # ========================================================

    (
        start_node,
        start_snap_distance,
    ) = nearest_graph_node(
        origin_lat,
        origin_lng,
    )

    (
        end_node,
        end_snap_distance,
    ) = nearest_graph_node(
        destination_lat,
        destination_lng,
    )

    if start_node is None or end_node is None:

        raise RuntimeError("تعذر ربط البداية أو الوجهة " "بشبكة المشي.")

    if start_node == end_node:

        raise ValueError("البداية والوجهة قريبتان جدًا " "ومرتبطتان بنفس عقدة المشي.")

    if not nx.has_path(
        G,
        start_node,
        end_node,
    ):

        raise RuntimeError("لا يوجد مسار مشي متصل " "بين البداية والوجهة.")

    # ========================================================
    # 3. Shortest Route
    # ========================================================

    shortest_path = nx.shortest_path(
        G,
        start_node,
        end_node,
        weight="length",
    )

    shortest_distance = path_distance(shortest_path)

    max_allowed_distance = shortest_distance * MAX_DETOUR_RATIO

    # ========================================================
    # 4. Sun Position
    # ========================================================

    observer = Observer(
        latitude=origin_lat,
        longitude=origin_lng,
    )

    sun_azimuth = float(
        azimuth(
            observer,
            departure,
        )
    )

    sun_elevation = float(
        elevation(
            observer,
            departure,
        )
    )

    # ========================================================
    # 5. Analysis Area
    # ========================================================

    route_line = transform(
        TO_METERS,
        LineString(
            [
                (
                    node_latlon[node][1],
                    node_latlon[node][0],
                )
                for node in shortest_path
            ]
        ),
    )

    analysis_area = route_line.buffer(ANALYSIS_BUFFER_M)

    bounds = transform(
        TO_LATLON,
        analysis_area,
    ).bounds

    # ========================================================
    # 6. Extract Buildings
    # ========================================================

    building_handler = LocalBuildingHandler(
        analysis_area=(analysis_area),
        bounds=(bounds),
    )

    building_handler.apply_file(
        PBF_FILE,
        locations=True,
    )

    buildings = building_handler.buildings

    # ========================================================
    # 7. Build Shadow Polygons
    # ========================================================

    shadow_polygons = []

    if sun_elevation > 1:

        for (
            building,
            height,
        ) in buildings:

            try:

                shadow = project_shadow(
                    building,
                    height,
                    sun_azimuth,
                    sun_elevation,
                )

                if shadow is not None and not shadow.is_empty:

                    shadow_polygons.append(shadow)

            except Exception:
                continue

    # ========================================================
    # 8. Reset Shade Data
    # ========================================================

    for _, _, data in G.edges(data=True):

        data["_shade_fraction"] = 0.0

        data["_shade_known"] = False

    # ========================================================
    # 9. Evaluate Edges Against Shadows
    # ========================================================

    if shadow_polygons and sun_elevation > 1:

        shadow_bounds = [
            (
                polygon,
                polygon.bounds,
            )
            for polygon in shadow_polygons
        ]

        for (
            u,
            v,
            data,
        ) in G.edges(data=True):

            try:

                lat1, lon1 = node_latlon[u]

                lat2, lon2 = node_latlon[v]

                edge_line = transform(
                    TO_METERS,
                    LineString(
                        [
                            (
                                lon1,
                                lat1,
                            ),
                            (
                                lon2,
                                lat2,
                            ),
                        ]
                    ),
                )

                if not (analysis_area.intersects(edge_line)):
                    continue

                sample_count = max(
                    3,
                    min(
                        12,
                        int(data["length"] / 8) + 1,
                    ),
                )

                shaded_points = 0

                for index in range(sample_count):

                    point = edge_line.interpolate(
                        (index + 0.5) / sample_count,
                        normalized=True,
                    )

                    px = point.x
                    py = point.y

                    in_shadow = False

                    for (
                        polygon,
                        polygon_bounds,
                    ) in shadow_bounds:

                        (
                            bx1,
                            by1,
                            bx2,
                            by2,
                        ) = polygon_bounds

                        if not (bx1 <= px <= bx2 and by1 <= py <= by2):
                            continue

                        if polygon.covers(point):

                            in_shadow = True
                            break

                    if in_shadow:

                        shaded_points += 1

                fraction = shaded_points / sample_count

                data["_shade_fraction"] = fraction

                data["_shade_known"] = True

            except Exception:

                continue

    # ========================================================
    # 10. Shade-Aware Weight
    # ========================================================

    def shade_weight(
        u,
        v,
        data,
    ):

        length = data["length"]

        if data.get(
            "_shade_known",
            False,
        ):

            shade_fraction = data.get(
                "_shade_fraction",
                0.0,
            )

            return length * (1 + EXPOSURE_PENALTY * (1 - shade_fraction))

        # إذا ما قيمنا هذه الوصلة،
        # ما نفترض أنها مكشوفة للشمس.
        # نستخدم طولها الطبيعي.

        return length

    # ========================================================
    # 11. Find Shaded Alternative
    # ========================================================

    shaded_path = None

    message = None

    if sun_elevation <= 1:

        message = (
            "الشمس منخفضة جدًا أو تحت الأفق، " "لذلك لا يحتاج النظام لمسار ظل نهاري."
        )

    elif not buildings:

        message = "لم تتوفر مبانٍ كافية قرب المسار " "لحساب مسار أقل تعرضًا للشمس."

    elif not shadow_polygons:

        message = "لم تتوفر مناطق ظل قابلة للاستخدام " "في هذا الوقت."

    else:

        try:

            candidate = nx.shortest_path(
                G,
                start_node,
                end_node,
                weight=shade_weight,
            )

            candidate_distance = path_distance(candidate)

            if candidate_distance <= max_allowed_distance:

                shaded_path = candidate

                if candidate == shortest_path:

                    message = "المسار الأقل تعرضًا للشمس " "هو نفسه المسار الأقصر."

                else:

                    message = "تم العثور على مسار بديل " "أقل تعرضًا للشمس."

            else:

                message = (
                    "المسار الأقل تعرضًا للشمس "
                    "أطول من الحد المسموح، "
                    "لذلك لم يتم اعتماده."
                )

        except nx.NetworkXNoPath:

            message = "تعذر العثور على مسار بديل " "أقل تعرضًا للشمس."

    # ========================================================
    # 12. Summaries
    # ========================================================

    shortest_result = summarize_path(shortest_path)

    shaded_result = None

    if shaded_path is not None:

        shaded_result = summarize_path(shaded_path)

    # ========================================================
    # 13. Final Response
    # ========================================================

    return {
        "origin": {
            "lat": origin_lat,
            "lng": origin_lng,
            "nearest_node_id": start_node,
            "snap_distance_meters": round(
                start_snap_distance,
                1,
            ),
        },
        "destination": {
            "lat": destination_lat,
            "lng": destination_lng,
            "nearest_node_id": end_node,
            "snap_distance_meters": round(
                end_snap_distance,
                1,
            ),
        },
        "departure_datetime": departure.isoformat(),
        "sun": {
            "azimuth_degrees": round(
                sun_azimuth,
                1,
            ),
            "elevation_degrees": round(
                sun_elevation,
                1,
            ),
            "is_daylight": sun_elevation > 1,
        },
        "shortest_route": shortest_result,
        "shaded_route": shaded_result,
        "building_analysis": {
            **building_handler.stats,
            "shadow_polygons": len(shadow_polygons),
        },
        "settings": {
            "max_detour_ratio": MAX_DETOUR_RATIO,
            "exposure_penalty": EXPOSURE_PENALTY,
            "analysis_buffer_meters": ANALYSIS_BUFFER_M,
            "walking_speed_m_per_second": WALKING_SPEED_M_PER_SECOND,
        },
        "message": message,
        "disclaimer": (
            "المسار ونسبة الظل تقدير هندسي "
            "يعتمد على بيانات المباني "
            "وارتفاعاتها وموقع الشمس، "
            "وليست قياسًا ميدانيًا للظل."
        ),
    }
