import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bhukk/config/api_config.dart';
import 'package:bhukk/models/carousel_item_model.dart';
import 'package:bhukk/services/auth_service.dart';

class CarouselService {
  final AuthService _authService = AuthService();
  final Dio _dio = Dio();

  // Get all active carousel items
  Future<List<CarouselItem>> getCarouselItems({
    int skip = 0,
    int limit = 10,
    bool activeOnly = true,
  }) async {
    try {
      final headers = await _authService.getAuthHeader();
      final url =
          '${ApiConfig.carousel}?skip=$skip&limit=$limit&active_only=$activeOnly';
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is String ? jsonDecode(response.data) : response.data;
        return data.map((item) => CarouselItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load carousel items');
      }
    } catch (e) {
      throw Exception('Failed to load carousel items: $e');
    }
  }
}
