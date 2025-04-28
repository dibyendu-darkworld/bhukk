-- SQL script to create the restaurants table in the bhukk database
CREATE TABLE IF NOT EXISTS restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(255),
    cuisine_type VARCHAR(100),
    rating FLOAT DEFAULT 0.0,
    owner_id INTEGER NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_approved BOOLEAN DEFAULT FALSE,
    image_url VARCHAR(255),
    latitude FLOAT,
    longitude FLOAT,
    opening_time TIME,
    closing_time TIME
);
