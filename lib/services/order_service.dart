import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bhukk/config/api_config.dart';
import 'package:bhukk/models/order_model.dart';
import 'package:bhukk/services/auth_service.dart';

class OrderService {
  final AuthService _authService = AuthService();
  final Dio _dio = Dio();

  // Get all orders for the authenticated user
  Future<List<Order>> getUserOrders() async {
    try {
      final headers = await _authService.getAuthHeader();
      final response = await _dio.get(
        ApiConfig.orders,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return data.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  // Get a specific order by ID
  Future<Order> getOrderById(int orderId) async {
    try {
      final headers = await _authService.getAuthHeader();
      final response = await _dio.get(
        ApiConfig.getOrderById(orderId),
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return Order.fromJson(data);
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  // Create a new order
  Future<Order> createOrder({
    required int restaurantId,
    required List<Map<String, dynamic>> orderItems,
    String? deliveryAddress,
    required String phoneNumber,
    String? deliveryInstructions,
    required String deliveryType,
    required String paymentMethod,
  }) async {
    try {
      final headers = await _authService.getAuthHeader();
      final orderData = {
        'restaurant_id': restaurantId,
        'order_items': orderItems,
        'phone_number': phoneNumber,
        'delivery_type': deliveryType,
        'payment_method': paymentMethod,
      };

      // Add optional fields if they're provided
      if (deliveryAddress != null) {
        orderData['delivery_address'] = deliveryAddress;
      }

      if (deliveryInstructions != null) {
        orderData['delivery_instructions'] = deliveryInstructions;
      }

      final response = await _dio.post(
        ApiConfig.orders,
        options: Options(headers: headers),
        data: jsonEncode(orderData),
      );
      if (response.statusCode == 201) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return Order.fromJson(data);
      } else {
        final error =
            response.data is String ? jsonDecode(response.data) : response.data;
        throw Exception(error['detail'] ?? 'Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Update order status
  Future<Order> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final headers = await _authService.getAuthHeader();
      final response = await _dio.put(
        ApiConfig.updateOrderStatus(orderId),
        options: Options(headers: headers),
        data: jsonEncode({'status': status}),
      );
      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return Order.fromJson(data);
      } else {
        final error =
            response.data is String ? jsonDecode(response.data) : response.data;
        throw Exception(error['detail'] ?? 'Failed to update order status');
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
