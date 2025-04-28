from fastapi import FastAPI, Query, APIRouter
from fastapi.middleware.cors import CORSMiddleware
import math
from app.db.database import fetch_all_restaurants

app = FastAPI()
router = APIRouter()
# Allow all CORS for local development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@router.get("/restaurants")
def get_restaurants(
    lat: float = Query(None, description="Latitude (optional, for distance calculation)"),
    lng: float = Query(None, description="Longitude (optional, for distance calculation)"),
    skip: int = Query(0, description="Number of records to skip (pagination)"),
    limit: int = Query(10, description="Maximum number of records to return (pagination)")
):
    restaurants = fetch_all_restaurants()
    # If lat/lng are provided, calculate distance for all restaurants
    if lat is not None and lng is not None:
        for r in restaurants:
            try:
                lat_rest = float(r["latitude"])
                lng_rest = float(r["longitude"])
                dist = haversine(lat, lng, lat_rest, lng_rest)
                # Always set as float, not string
                r["distance"] = float(dist)
            except (TypeError, ValueError, KeyError):
                r["distance"] = None
    # Pagination
    return restaurants[skip:skip+limit]

@router.get("/restaurants/{restaurant_id}")
def get_restaurant_by_id(
    restaurant_id: int,
    lat: float = Query(None, description="Latitude (optional, for distance calculation)"),
    lng: float = Query(None, description="Longitude (optional, for distance calculation)")
):
    restaurants = fetch_all_restaurants()
    for r in restaurants:
        if r["id"] == restaurant_id:
            return r
    return {"error": "Restaurant not found"}

def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # Earth radius in kilometers
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

@router.get("/restaurants/nearby/")
def get_nearby_restaurants(
    lat: float = Query(..., description="Latitude is required"),
    lng: float = Query(..., description="Longitude is required"),
    radius: float = Query(10.0, description="Radius in km (default 10.0)")
):
    # Fetch restaurants from the database
    restaurants = fetch_all_restaurants()
    # Calculate distance for each restaurant and filter by radius
    nearby = []
    for r in restaurants:
        # Ensure latitude and longitude are present and not None and valid
        try:
            lat_rest = float(r["latitude"])
            lng_rest = float(r["longitude"])
        except (TypeError, ValueError, KeyError):
            continue
        dist = haversine(lat, lng, lat_rest, lng_rest)
        r_copy = dict(r)
        r_copy["distance"] = round(dist, 2)
        if dist <= radius:
            nearby.append(r_copy)
    return nearby

@app.get("/api/v1/carousel")
def get_carousel():
    return [
        {"id": 1, "image_url": "carousel1.png", "title": "Welcome!"},
        {"id": 2, "image_url": "carousel2.png", "title": "Special Offers"},
    ]

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/")
def root():
    return {"message": "Welcome to the Bhukk Food Delivery API! See /docs for API documentation."}

