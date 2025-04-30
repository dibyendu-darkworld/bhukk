from fastapi import FastAPI
from app.api.v1 import restaurants

app = FastAPI()

app.include_router(restaurants.router, prefix='/api/v1')