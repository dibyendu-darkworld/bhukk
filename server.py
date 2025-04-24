from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Allow all CORS for local development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mock data for restaurants with all required fields
restaurants = [
    {
        "id": 1,
        "name": "Pizza Palace",
        "location": "Downtown",
        "cuisineType": "Italian",
        "image": "pizza_palace.png",
        "latitude": 22.654,
        "longitude": 88.445
    },
    {
        "id": 2,
        "name": "Burger Bonanza",
        "location": "Uptown",
        "cuisineType": "Fast Food",
        "image": "burger_bonanza.png",
        "latitude": 22.655,
        "longitude": 88.446
    },
    {
        "id": 3,
        "name": "Sushi Central",
        "location": "Midtown",
        "cuisineType": "Chinese",
        "image": "sushi_central.png",
        "latitude": 22.656,
        "longitude": 88.447
    },
]

@app.get("/api/v1/restaurants")
def get_restaurants():
    return restaurants

@app.get("/api/v1/restaurants/{restaurant_id}")
def get_restaurant_by_id(restaurant_id: int):
    for r in restaurants:
        if r["id"] == restaurant_id:
            return r
    return {"error": "Restaurant not found"}

@app.get("/api/v1/restaurants/nearby")
@app.get("/api/v1/restaurants/nearby/")
def get_nearby_restaurants(
    lat: float = Query(..., description="Latitude is required"),
    lng: float = Query(..., description="Longitude is required"),
    radius: float = Query(5.0, description="Radius in km (default 5.0)")
):
    # For demo, just return all restaurants (later: filter by lat/lng/radius)
    return restaurants

@app.get("/api/v1/carousel")
def get_carousel():
    return [
        {"id": 1, "image": "carousel1.png", "title": "Welcome!"},
        {"id": 2, "image": "carousel2.png", "title": "Special Offers"},
    ]

@app.get("/health")
def health_check():
    return {"status": "ok"}
