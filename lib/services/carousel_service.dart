import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bhukk/config/api_config.dart';
import 'package:bhukk/models/carousel_item_model.dart';
import 'package:bhukk/services/auth_service.dart';

class CarouselService {
  final AuthService _authService = AuthService();

  // Get all active carousel items
  Future<List<CarouselItem>> getCarouselItems({
    int skip = 0,
    int limit = 10,
    bool activeOnly = true,
  }) async {
    try {
      final headers = await _authService.getAuthHeader();
      final url = Uri.parse(
          '${ApiConfig.carousel}?skip=$skip&limit=$limit&active_only=$activeOnly');

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => CarouselItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load carousel items');
      }
    } catch (e) {
      throw Exception('Failed to load carousel items: $e');
    }
  }
}
