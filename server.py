
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
import math
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
        "name": "Handiwale Bhaiya",
        "description": "Best Indian Food!",
        "address": "68, LP/16/14/6/1, Holding 191, Ground Floor, Sarat Colony, Birati, Ward 17, Jessore Road, Kaikhali, Kolkata",
        "cuisine_type": "Indian",
        "rating": 4.5,
        "owner_id": 101,
        "is_active": True,
        "is_approved": True,
        "image_url": "handiwale_bhaiya.png",
        "latitude": 22.652,
        "longitude": 88.452,
        "opening_time": "12:00:00",
        "closing_time": "22:30:00",
        "distance": 2.1,
        "is_open": True
    },
    {
        "id": 2,
        "name": "The Orient",
        "description": "Drinks, Juicy burgers and fries.",
        "address": "Ground Floor, City Center 2 Mall, Chinar Park, Kolkata",
        "cuisine_type": "Fast Food",
        "rating": 4.2,
        "owner_id": 102,
        "is_active": True,
        "is_approved": True,
        "image_url": "the_orient.png",
        "latitude": 22.589,
        "longitude": 88.475,
        "opening_time": "12:30:00",
        "closing_time": "23:00:00",
        "distance": 5.4,
        "is_open": False
    },
    {
        "id": 3,
        "name": "Ami Bangali",
        "description": "Authentic Bengali cuisine.",
        "address": "BMC, Narayanpur, Chinar Park, Kolkata",
        "cuisine_type": "Bengali",
        "rating": 4.8,
        "owner_id": 103,
        "is_active": True,
        "is_approved": False,
        "image_url": "ami_bangali.png",
        "latitude": 22.660,
        "longitude": 88.460,
        "opening_time": "11:30:00",
        "closing_time": "23:30:00",
        "distance": 8.3,
        "is_open": True
    },
    # {
    #     "id": 4,
    #     "name": "Aminia",
    #     "description": "Best Biriyani in town.",
    #     "address": "94, Bidhan Sarani, Faria Pukur Crossing, Shyam Bazar, Kolkata",
    #     "cuisine_type": "Indian",
    #     "rating": 4.8,
    #     "owner_id": 104,
    #     "is_active": True,
    #     "is_approved": False,
    #     "image_url": "sushi_central.png",
    #     "latitude": 22.595,
    #     "longitude": 88.371,
    #     "opening_time": "12:00:00",
    #     "closing_time": "21:00:00",
    #     "distance": 12.8,
    #     "is_open": True
    # },
]
@app.get("/api/v1/restaurants")
def get_restaurants(
    lat: float = Query(None, description="Latitude (optional, for distance calculation)"),
    lng: float = Query(None, description="Longitude (optional, for distance calculation)")
):
    return restaurants
@app.get("/api/v1/restaurants/{restaurant_id}")
def get_restaurant_by_id(
    restaurant_id: int,
    lat: float = Query(None, description="Latitude (optional, for distance calculation)"),
    lng: float = Query(None, description="Longitude (optional, for distance calculation)")
):
    for r in restaurants:
        if r["id"] == restaurant_id:
            return r
    return {"error": "Restaurant not found"}
@app.get("/api/v1/restaurants/nearby")
@app.get("/api/v1/restaurants/nearby/")
def get_nearby_restaurants(
    lat: float = Query(..., description="Latitude is required"),
    lng: float = Query(..., description="Longitude is required"),
    radius: float = Query(10.0, description="Radius in km (default 10.0)")
):
    # For demo, just return all restaurants with their mock distance
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
@app.get("/")
def root():
    return {"message": "Welcome to the Bhukk Food Delivery API! See /docs for API documentation."}
