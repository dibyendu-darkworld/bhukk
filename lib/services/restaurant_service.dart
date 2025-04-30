import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bhukk/config/api_config.dart';
import 'package:bhukk/models/restaurant_model.dart';
import 'package:bhukk/models/menu_item_model.dart';
import 'package:bhukk/services/auth_service.dart';

class RestaurantService {
  final AuthService _authService = AuthService();
  final Dio _dio = Dio();

  // Get all restaurants
  Future<List<Restaurant>> getAllRestaurants({
    int skip = 0,
    int limit = 10,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final headers = await _authService.getAuthHeader();
      String url = '${ApiConfig.restaurants}?skip=$skip&limit=$limit';
      if (latitude != null && longitude != null) {
        url += '&lat=$latitude&lng=$longitude';
      }
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return data
            .map((restaurant) => Restaurant.fromJson(restaurant))
            .toList();
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  // Get restaurant by ID
  Future<Restaurant> getRestaurantById(int id) async {
    try {
      final headers = await _authService.getAuthHeader();
      final response = await _dio.get(
        ApiConfig.getRestaurantById(id),
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return Restaurant.fromJson(data);
      } else {
        throw Exception('Failed to load restaurant details');
      }
    } catch (e) {
      throw Exception('Failed to load restaurant details: $e');
    }
  }

  // Get nearby restaurants
  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    String? cuisineType,
  }) async {
    try {
      final headers = await _authService.getAuthHeader();

      String url =
          '${ApiConfig.nearbyRestaurants}/?lat=$latitude&lng=$longitude&radius=$radius';
      if (cuisineType != null && cuisineType.isNotEmpty) {
        url += '&cuisine_type=$cuisineType';
      }

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;
        // Check if the response is the "not found" message format
        if (data is Map &&
            data.containsKey('status') &&
            data['status'] == 'not_found') {
          return [];
        }
        final List<dynamic> restaurants = data;
        return restaurants
            .map((restaurant) => Restaurant.fromJson(restaurant))
            .toList();
      } else {
        throw Exception('Failed to load nearby restaurants');
      }
    } catch (e) {
      throw Exception('Failed to load nearby restaurants: $e');
    }
  }

  // Get restaurant menu items
  Future<List<MenuItem>> getRestaurantMenuItems(int restaurantId) async {
    try {
      final headers = await _authService.getAuthHeader();
      final response = await _dio.get(
        ApiConfig.getRestaurantMenuItems(restaurantId),
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return data.map((item) => MenuItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      throw Exception('Failed to load menu items: $e');
    }
  }
}
