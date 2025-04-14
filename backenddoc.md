# Bhukk Food Delivery API Backend

A FastAPI-based backend system for a food delivery platform similar to Zomato.

## Project Structure

```
bhukkBackend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── admin.py      # Admin panel routes
│   │       ├── auth.py       # Authentication routes
│   │       ├── orders.py     # Order management
│   │       └── restaurants.py # Restaurant management
│   ├── core/
│   │   └── security.py       # Security utilities
│   ├── db/
│   │   └── database.py       # Database configuration
│   ├── models/
│   │   └── models.py         # SQLAlchemy models
│   └── schemas/
│       └── schemas.py        # Pydantic schemas
├── static/                   # Static files for admin panel
├── templates/                # HTML templates for admin panel
├── docker-compose.dev.yml    # Development Docker compose
├── docker-compose.yml        # Production Docker compose
├── Dockerfile               # Docker configuration
├── init-dev-db.sh          # Database initialization script
├── main.py                 # Application entry point
└── requirements.txt        # Python dependencies
```

## Features

- 🔐 **Authentication System**
  - User registration and login with JWT-based authentication
  - Role-based access control (Admin, Restaurant Owner, Customer)
  - Secure password hashing with bcrypt

- 🍽️ **Restaurant Management**
  - Create and manage restaurants
  - Menu item management with categories
  - Restaurant search and filtering
  - Approval system for new restaurants
  - Nearby restaurant search based on user location
  - Opening hours tracking and real-time open status

- 📦 **Order Management**
  - Place new orders with multiple items
  - Real-time order status tracking
  - Order history and details
  - Multiple order statuses (pending, confirmed, preparing, out_for_delivery, delivered, cancelled)

- 👨‍💼 **Admin Panel**
  - Modern dashboard with key metrics
  - User management with admin privileges
  - Restaurant approval system
  - Order monitoring and management
  - Restaurant location and hours management
  - Built with TailwindCSS and HTMX for dynamic updates

## Technology Stack

- **Framework**: FastAPI with Python 3.11+
- **Database**: PostgreSQL 14
- **ORM**: SQLAlchemy 2.0
- **Authentication**: JWT (JSON Web Tokens) with python-jose
- **Password Hashing**: Bcrypt
- **Documentation**: Swagger/OpenAPI (FastAPI automatic docs)
- **Frontend**: TailwindCSS 2.2 & HTMX 1.9
- **Containerization**: Docker & Docker Compose
- **Template Engine**: Jinja2
- **Form Handling**: python-multipart
- **Email Validation**: email-validator

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Python 3.11 or higher (for local development)

### Development Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd bhukkBackend
   ```

2. Start the development environment:
   ```bash
   docker compose -f docker-compose.dev.yml up --build
   ```

3. Access the services:
   - API: http://localhost:8001
   - API Documentation: http://localhost:8001/docs
   - Admin Panel: http://localhost:8001/api/v1/admin/dashboard

### Default Admin Credentials

- Email: admin@bhukk.com
- Password: admin123

## API Documentation

This section provides detailed information about all API endpoints, including request/response formats, authentication requirements, and error handling.

### Authentication Endpoints

#### Register User
```
POST /api/v1/auth/register
```

Register a new user in the system.

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "username",
  "password": "securepassword123"
}
```

**Success Response (201 Created):**
```json
{
  "id": 1,
  "email": "user@example.com",
  "username": "username",
  "is_active": true,
  "is_restaurant": false,
  "is_admin": false
}
```

**Error Responses:**
- **400 Bad Request**: Invalid input data
  ```json
  {
    "detail": "Email already registered"
  }
  ```
  ```json
  {
    "detail": "Username already exists"
  }
  ```
- **422 Unprocessable Entity**: Validation error
  ```json
  {
    "detail": [
      {
        "loc": ["body", "email"],
        "msg": "value is not a valid email address",
        "type": "value_error.email"
      }
    ]
  }
  ```

#### Login
```
POST /api/v1/auth/token
```

Authenticate a user and receive an access token.

**Request Body:**
```json
{
  "username": "user@example.com",
  "password": "securepassword123"
}
```

**Success Response (200 OK):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "username",
    "is_active": true,
    "is_restaurant": false,
    "is_admin": false
  }
}
```

**Error Responses:**
- **401 Unauthorized**: Invalid credentials
  ```json
  {
    "detail": "Incorrect email or password"
  }
  ```
- **400 Bad Request**: User is inactive
  ```json
  {
    "detail": "Inactive user"
  }
  ```

### Restaurant Endpoints

#### List All Restaurants
```
GET /api/v1/restaurants
```

Get a paginated list of all approved and active restaurants.

**Query Parameters:**
- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Maximum number of records to return (default: 10)

**Success Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "Restaurant Name",
    "description": "Description of the restaurant",
    "address": "123 Main St",
    "cuisine_type": "Italian",
    "rating": 4.5,
    "owner_id": 2,
    "is_active": true,
    "is_approved": true,
    "image_url": "https://example.com/image.jpg",
    "latitude": 37.7749,
    "longitude": -122.4194,
    "opening_time": "09:00:00",
    "closing_time": "22:00:00"
  },
  // More restaurants...
]
```

**Error Responses:**
- **500 Internal Server Error**: Database error
  ```json
  {
    "detail": "Failed to fetch restaurants"
  }
  ```

#### Create Restaurant
```
POST /api/v1/restaurants
```

Create a new restaurant (requires authentication).

**Authentication**: Bearer token required

**Request Body:**
```json
{
  "name": "New Restaurant",
  "description": "Description of new restaurant",
  "address": "456 Oak St",
  "cuisine_type": "Mexican",
  "latitude": 37.7749,
  "longitude": -122.4194,
  "opening_time": "10:00:00",
  "closing_time": "23:00:00"
}
```

**Success Response (200 OK):**
```json
{
  "id": 3,
  "name": "New Restaurant",
  "description": "Description of new restaurant",
  "address": "456 Oak St",
  "cuisine_type": "Mexican",
  "owner_id": 2,
  "rating": 0.0,
  "is_active": true,
  "is_approved": false,
  "image_url": null,
  "latitude": 37.7749,
  "longitude": -122.4194,
  "opening_time": "10:00:00",
  "closing_time": "23:00:00"
}
```

**Error Responses:**
- **401 Unauthorized**: Missing or invalid token
  ```json
  {
    "detail": "Not authenticated"
  }
  ```
- **500 Internal Server Error**: Database error
  ```json
  {
    "detail": "Failed to create restaurant: [error message]"
  }
  ```
- **422 Unprocessable Entity**: Validation error
  ```json
  {
    "detail": [
      {
        "loc": ["body", "name"],
        "msg": "field required",
        "type": "value_error.missing"
      }
    ]
  }
  ```

#### Get Restaurant by ID
```
GET /api/v1/restaurants/{restaurant_id}
```

Get detailed information about a specific restaurant.

**Path Parameters:**
- `restaurant_id`: ID of the restaurant to retrieve

**Success Response (200 OK):**
```json
{
  "id": 1,
  "name": "Restaurant Name",
  "description": "Description of the restaurant",
  "address": "123 Main St",
  "cuisine_type": "Italian",
  "rating": 4.5,
  "owner_id": 2,
  "is_active": true,
  "is_approved": true,
  "image_url": "https://example.com/image.jpg",
  "latitude": 37.7749,
  "longitude": -122.4194,
  "opening_time": "09:00:00",
  "closing_time": "22:00:00"
}
```

**Error Responses:**
- **404 Not Found**: Restaurant does not exist
  ```json
  {
    "detail": "Restaurant not found"
  }
  ```

#### Add Menu Item
```
POST /api/v1/restaurants/{restaurant_id}/menu-items
```

Add a new menu item to a restaurant (requires authentication).

**Authentication**: Bearer token required

**Path Parameters:**
- `restaurant_id`: ID of the restaurant to add the menu item to

**Request Body:**
```json
{
  "name": "Spaghetti Carbonara",
  "description": "Classic Italian pasta dish",
  "price": 12.99,
  "category": "Pasta",
  "is_available": true
}
```

**Success Response (200 OK):**
```json
{
  "id": 5,
  "name": "Spaghetti Carbonara",
  "description": "Classic Italian pasta dish",
  "price": 12.99,
  "restaurant_id": 1,
  "is_available": true,
  "category": "Pasta"
}
```

**Error Responses:**
- **401 Unauthorized**: Missing or invalid token
  ```json
  {
    "detail": "Not authenticated"
  }
  ```
- **403 Forbidden**: User is not the restaurant owner
  ```json
  {
    "detail": "Not authorized to add menu items to this restaurant"
  }
  ```

#### Get Menu Items
```
GET /api/v1/restaurants/{restaurant_id}/menu-items
```

Get all menu items for a specific restaurant.

**Path Parameters:**
- `restaurant_id`: ID of the restaurant to get menu items from

**Success Response (200 OK):**
```json
[
  {
    "id": 5,
    "name": "Spaghetti Carbonara",
    "description": "Classic Italian pasta dish",
    "price": 12.99,
    "restaurant_id": 1,
    "is_available": true,
    "category": "Pasta"
  },
  // More menu items...
]
```

**Error Responses:**
- **404 Not Found**: Restaurant does not exist
  ```json
  {
    "detail": "Restaurant not found"
  }
  ```

#### Find Nearby Restaurants
```
GET /api/v1/restaurants/nearby/
```

Find restaurants near a specific location.

**Query Parameters:**
- `lat` (required): User's latitude
- `lng` (required): User's longitude
- `radius` (optional): Search radius in kilometers (default: 5.0)
- `cuisine_type` (optional): Filter by cuisine type

**Success Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "Restaurant Name",
    "description": "Description of the restaurant",
    "address": "123 Main St",
    "cuisine_type": "Italian",
    "rating": 4.5,
    "distance": 1.23,
    "is_open": true,
    "image_url": "https://example.com/image.jpg"
  },
  // More restaurants...
]
```

**No Results Response (200 OK):**
```json
{
  "status": "not_found",
  "message": "No restaurants found in your area. Try increasing the search radius."
}
```

**Error Responses:**
- **422 Unprocessable Entity**: Missing required parameters
  ```json
  {
    "detail": [
      {
        "loc": ["query", "lat"],
        "msg": "field required",
        "type": "value_error.missing"
      }
    ]
  }
  ```
- **500 Internal Server Error**: Calculation error
  ```json
  {
    "detail": "Failed to fetch nearby restaurants: [error message]"
  }
  ```

### Order Endpoints

#### List User Orders
```
GET /api/v1/orders
```

Get all orders for the authenticated user.

**Authentication**: Bearer token required

**Success Response (200 OK):**
```json
[
  {
    "id": 1,
    "restaurant_id": 1,
    "customer_id": 3,
    "total_amount": 25.98,
    "status": "delivered",
    "created_at": "2023-07-15T12:30:45",
    "updated_at": "2023-07-15T13:15:22",
    "order_items": [
      {
        "id": 1,
        "menu_item_id": 5,
        "order_id": 1,
        "quantity": 2,
        "unit_price": 12.99
      }
    ]
  },
  // More orders...
]
```

**Error Responses:**
- **401 Unauthorized**: Missing or invalid token
  ```json
  {
    "detail": "Not authenticated"
  }
  ```
- **500 Internal Server Error**: Database error
  ```json
  {
    "detail": "Failed to fetch orders"
  }
  ```

#### Create Order
```
POST /api/v1/orders
```

Create a new order.

**Authentication**: Bearer token required

**Request Body:**
```json
{
  "restaurant_id": 1,
  "order_items": [
    {
      "menu_item_id": 5,
      "quantity": 2
    },
    {
      "menu_item_id": 8,
      "quantity": 1
    }
  ]
}
```

**Success Response (201 Created):**
```json
{
  "id": 5,
  "restaurant_id": 1,
  "customer_id": 3,
  "total_amount": 38.97,
  "status": "pending",
  "created_at": "2023-07-20T15:45:30",
  "updated_at": "2023-07-20T15:45:30",
  "order_items": [
    {
      "id": 8,
      "menu_item_id": 5,
      "order_id": 5,
      "quantity": 2,
      "unit_price": 12.99
    },
    {
      "id": 9,
      "menu_item_id": 8,
      "order_id": 5,
      "quantity": 1,
      "unit_price": 12.99
    }
  ]
}
```

**Error Responses:**
- **401 Unauthorized**: Missing or invalid token
  ```json
  {
    "detail": "Not authenticated"
  }
  ```
- **404 Not Found**: Restaurant or menu item not found
  ```json
  {
    "detail": "Restaurant not found"
  }
  ```
  ```json
  {
    "detail": "Menu item not found"
  }
  ```
- **400 Bad Request**: Invalid order data
  ```json
  {
    "detail": "Order must contain at least one item"
  }
  ```
- **500 Internal Server Error**: Database error
  ```json
  {
    "detail": "Failed to create order"
  }
  ```

#### Get Order by ID
```
GET /api/v1/orders/{order_id}
```

Get detailed information about a specific order.

**Authentication**: Bearer token required

**Path Parameters:**
- `order_id`: ID of the order to retrieve

**Success Response (200 OK):**
```json
{
  "id": 1,
  "restaurant_id": 1,
  "customer_id": 3,
  "total_amount": 25.98,
  "status": "delivered",
  "created_at": "2023-07-15T12:30:45",
  "updated_at": "2023-07-15T13:15:22",
  "order_items": [
    {
      "id": 1,
      "menu_item_id": 5,
      "order_id": 1,
      "quantity": 2,
      "unit_price": 12.99
    }
  ]
}
```

**Error Responses:**
- **401 Unauthorized**: Missing or invalid token
  ```json
  {
    "detail": "Not authenticated"
  }
  ```
- **403 Forbidden**: User is not authorized to view this order
  ```json
  {
    "detail": "Not authorized to view this order"
  }
  ```
- **404 Not Found**: Order does not exist
  ```json
  {
    "detail": "Order not found"
  }
  ```

#### Update Order Status
```
PUT /api/v1/orders/{order_id}/status
```

Update the status of an order.

**Authentication**: Bearer token required

**Path Parameters:**
- `order_id`: ID of the order to update

**Request Body:**
```json
{
  "status": "confirmed"
}
```

**Success Response (200 OK):**
```json
{
  "id": 1,
  "restaurant_id": 1,
  "customer_id": 3,
  "total_amount": 25.98,
  "status": "confirmed",
  "created_at": "2023-07-15T12:30:45",
  "updated_at": "2023-07-15T12:45:30",
  "order_items": [
    {
      "id": 1,
      "menu_item_id": 5,
      "order_id": 1,
      "quantity": 2,
      "unit_price": 12.99
    }
  ]
}
```

**Error Responses:**
- **401 Unauthorized**: Missing or invalid token
  ```json
  {
    "detail": "Not authenticated"
  }
  ```
- **403 Forbidden**: User is not authorized to update this order
  ```json
  {
    "detail": "Not authorized to update this order"
  }
  ```
- **404 Not Found**: Order does not exist
  ```json
  {
    "detail": "Order not found"
  }
  ```
- **400 Bad Request**: Invalid status
  ```json
  {
    "detail": "Invalid status. Must be one of: pending, confirmed, preparing, out_for_delivery, delivered, cancelled"
  }
  ```

### Admin Endpoints

#### Admin Dashboard
```
GET /api/v1/admin/dashboard
```

Access the admin dashboard.

**Authentication**: Admin cookie required

**Success Response**: HTML dashboard page

**Error Responses:**
- **303 See Other**: Redirect to login if not authenticated
- **500 Internal Server Error**: Server error
  ```json
  {
    "detail": "Dashboard error: [error message]"
  }
  ```

#### List Users (Admin)
```
GET /api/v1/admin/users
```

View all users in the system.

**Authentication**: Admin cookie required

**Success Response**: HTML page with user list

**Error Responses:**
- **303 See Other**: Redirect to login if not authenticated

#### List Restaurants (Admin)
```
GET /api/v1/admin/restaurants
```

View all restaurants in the system.

**Authentication**: Admin cookie required

**Success Response**: HTML page with restaurant list

**Error Responses:**
- **303 See Other**: Redirect to login if not authenticated

#### List Orders (Admin)
```
GET /api/v1/admin/orders
```

View all orders in the system.

**Authentication**: Admin cookie required

**Success Response**: HTML page with order list

**Error Responses:**
- **303 See Other**: Redirect to login if not authenticated

#### Approve Restaurant
```
POST /api/v1/admin/restaurants/{restaurant_id}/approve
```

Approve a restaurant.

**Authentication**: Admin cookie required

**Path Parameters:**
- `restaurant_id`: ID of the restaurant to approve

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Restaurant approved successfully"
}
```

**Error Responses:**
- **401 Unauthorized**: Not authenticated as admin
  ```json
  {
    "success": false,
    "message": "Unauthorized"
  }
  ```
- **404 Not Found**: Restaurant does not exist
  ```json
  {
    "detail": "Restaurant not found"
  }
  ```

#### Toggle Admin Status
```
POST /api/v1/admin/users/{user_id}/toggle-admin
```

Toggle the admin status of a user.

**Authentication**: Admin cookie required

**Path Parameters:**
- `user_id`: ID of the user to update

**Success Response (200 OK):**
```json
{
  "success": true,
  "is_admin": true
}
```

**Error Responses:**
- **401 Unauthorized**: Not authenticated as admin
  ```json
  {
    "success": false,
    "message": "Unauthorized"
  }
  ```
- **404 Not Found**: User does not exist
  ```json
  {
    "detail": "User not found"
  }
  ```

### Health Endpoint

#### Health Check
```
GET /health
```

Check the health status of the API.

**Success Response (200 OK):**
```json
{
  "status": "healthy",
  "database": "connected",
  "version": "1.0.0",
  "timestamp": "2023-07-20T15:45:30"
}
```

**Partial Failure Response (200 OK):**
```json
{
  "status": "degraded",
  "database": "connected",
  "error": "Some services unavailable",
  "version": "1.0.0",
  "timestamp": "2023-07-20T15:45:30"
}
```

**Error Response (503 Service Unavailable):**
```json
{
  "status": "unhealthy",
  "database": "disconnected",
  "error": "Database connection failed",
  "version": "1.0.0",
  "timestamp": "2023-07-20T15:45:30"
}
```

## Nearby Restaurants API

The nearby restaurants API allows users to find restaurants in their vicinity based on their current location.

### Features

- **Location-Based Search**: Find restaurants within a specified radius from the user's location
- **Real-time Open Status**: Check if restaurants are currently open based on their operating hours
- **Distance Calculation**: Shows distance to each restaurant in kilometers
- **Sorting by Proximity**: Results are sorted by distance (closest first)
- **Cuisine Filtering**: Optional filtering by cuisine type

### Using the API

```
GET /api/v1/restaurants/nearby/
```

#### Required Parameters

- `lat` - User's latitude (float)
- `lng` - User's longitude (float)

#### Optional Parameters

- `radius` - Search radius in kilometers (default: 5.0)
- `cuisine_type` - Filter by specific cuisine type

#### Response

- List of nearby restaurants with distance and open status
- If no restaurants are found, returns a message indicating no restaurants in the area

#### Example Request

```
GET /api/v1/restaurants/nearby/?lat=37.7749&lng=-122.4194&radius=2.5&cuisine_type=Italian
```

#### Example Response

```json
[
  {
    "id": 1,
    "name": "Pasta Palace",
    "description": "Authentic Italian cuisine",
    "address": "123 Main St",
    "cuisine_type": "Italian",
    "rating": 4.5,
    "distance": 1.23,
    "is_open": true,
    "image_url": "https://example.com/images/pasta-palace.jpg"
  },
  {
    "id": 3,
    "name": "Gusto Italiano",
    "description": "Traditional Italian dishes",
    "address": "789 Oak St",
    "cuisine_type": "Italian",
    "rating": 4.2,
    "distance": 1.86,
    "is_open": false,
    "image_url": "https://example.com/images/gusto.jpg"
  }
]
```

#### No Results Response

```json
{
  "status": "not_found",
  "message": "No restaurants found in your area. Try increasing the search radius."
}
```

### Restaurant Location and Hours Management

Restaurant owners and administrators can manage restaurant locations and opening hours through:

- The admin panel interface
- API endpoints for restaurant creation and updates
- CSV bulk upload with location and hours data

### Location Data Requirements

For optimal performance in the nearby search feature, restaurants should include:

- Accurate latitude and longitude coordinates
- Opening and closing times in 24-hour format (HH:MM)

## Development

### Environment Variables

Required environment variables in `.env` file:

- `DATABASE_URL`: PostgreSQL connection string
- `SECRET_KEY`: JWT secret key
- `ALGORITHM`: JWT algorithm (default: HS256)
- `ACCESS_TOKEN_EXPIRE_MINUTES`: JWT token expiry (default: 30)
- `ENVIRONMENT`: Development/Production mode

### Database Management

The system automatically creates tables on first run. For manual initialization:

```bash
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up --build
```

### Adding New Features

1. Create new routes in `app/api/v1/`
2. Define models in `app/models/models.py`
3. Create schemas in `app/schemas/schemas.py`
4. Update documentation

## Production Deployment

1. Update environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with production values
   ```

2. Deploy using production compose:
   ```bash
   docker compose up -d
   ```

3. Configure reverse proxy (nginx recommended)

## Security Considerations

- Use strong passwords
- Keep SECRET_KEY secure
- Enable HTTPS in production
- Regularly update dependencies
- Monitor logs for suspicious activities
- Set up proper database backup
- Implement rate limiting for API endpoints
- Regular security audits

## Health Monitoring

The application includes a health check endpoint:
- `GET /health` - Returns system health status including:
  - API status
  - Database connectivity
  - Overall system state

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.