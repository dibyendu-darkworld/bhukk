class ApiConfig {
  // Base URL for API endpoints
  static const String baseUrl = 'http://localhost:8001';

  // Authentication endpoints
  static const String register = '$baseUrl/api/v1/auth/register';
  static const String login = '$baseUrl/api/v1/auth/token';

  // Restaurant endpoints
  static const String restaurants = '$baseUrl/api/v1/restaurants';
  static const String nearbyRestaurants = '$baseUrl/api/v1/restaurants/nearby';

  // Order endpoints
  static const String orders = '$baseUrl/api/v1/orders';

  // Carousel endpoints
  static const String carousel = '$baseUrl/api/v1/carousel';

  // Health check
  static const String healthCheck = '$baseUrl/health';

  // Restaurant endpoints helper methods
  static String getRestaurantById(int id) => '$restaurants/$id';
  static String getRestaurantMenuItems(int restaurantId) =>
      '$restaurants/$restaurantId/menu-items';

  // Order endpoints helper methods
  static String getOrderById(int id) => '$orders/$id';
  static String updateOrderStatus(int id) => '$orders/$id/status';
}
