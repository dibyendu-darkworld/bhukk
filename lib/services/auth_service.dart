import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bhukk/config/api_config.dart';
import 'package:bhukk/models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Create storage with explicit options to avoid platform issues
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // For fallback when secure storage is not available (debugging/testing)
  final Map<String, String> _memoryTokens = {};

  // Register a new user
  Future<User?> registerUser(
      {required String email,
      required String username,
      required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': email, 'username': username, 'password': password}),
      );

      if (response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // Login user and get access token
  Future<User?> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email, // API uses 'username' field for email login
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Store access token securely with error handling
        try {
          await _storage.write(key: 'access_token', value: data['access_token']);
          await _storage.write(key: 'token_type', value: data['token_type']);
        } catch (e) {
          debugPrint('Error storing auth tokens: $e');
          // Fallback to in-memory storage for development/testing
          _memoryTokens['access_token'] = data['access_token'];
          _memoryTokens['token_type'] = data['token_type'];
        }

        // Return user data
        if (data['user'] != null) {
          return User.fromJson(data['user']);
        }
        return null;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Get the stored access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: 'access_token');
    } catch (e) {
      debugPrint('Error reading access token: $e');
      // Return from memory fallback if available
      return _memoryTokens['access_token'];
    }
  }

  // Get authorization header for authenticated requests
  Future<Map<String, String>> getAuthHeader() async {
    String? token;
    String tokenType = 'bearer';

    try {
      token = await getAccessToken();
      final storedTokenType = await _storage.read(key: 'token_type');
      if (storedTokenType != null) {
        tokenType = storedTokenType;
      }
    } catch (e) {
      debugPrint('Error getting auth header: $e');
      token = _memoryTokens['access_token'];
      tokenType = _memoryTokens['token_type'] ?? tokenType;
    }

    if (token != null) {
      return {
        'Authorization': '$tokenType $token',
        'Content-Type': 'application/json',
      };
    }

    return {'Content-Type': 'application/json'};
  }

  // Log out user
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'token_type');
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
    // Clear memory tokens as well
    _memoryTokens.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAccessToken();
      return token != null;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return _memoryTokens['access_token'] != null;
    }
  }
}
