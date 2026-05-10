import 'package:dio/dio.dart';
import 'package:insight_hub/model/register_model.dart';

final dio = Dio();

Future<Map<String, dynamic>> registerUser(RegisterModel userData) async {
  try {
    print('Sending registration data: ${userData.toJson()}');
    final response = await dio.post(
      Endpoints.register,
      data: userData.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print('Registration successful: ${response.statusCode} - ${response.data}');
    return {
      'success': true,
      'statusCode': response.statusCode,
      'data': response.data,
    };
  } on DioException catch (e) {
    print('Dio Error: ${e.type}');
    print('Status Code: ${e.response?.statusCode}');
    print('Response Data: ${e.response?.data}');
    print('Error Message: ${e.message}');
    
    String errorMessage = 'Registration failed';
    if (e.response?.data != null) {
      if (e.response!.data is Map && e.response!.data.containsKey('message')) {
        errorMessage = e.response!.data['message'];
      } else if (e.response!.data is String) {
        errorMessage = e.response!.data;
      }
    }
    
    return {
      'success': false,
      'statusCode': e.response?.statusCode,
      'error': errorMessage,
      'data': e.response?.data,
    };
  } catch (e) {
    print('Unexpected error: $e');
    return {
      'success': false,
      'error': 'Unexpected error: $e',
    };
  }
}

class Endpoints {
  static const String baseUrl = "https://saccharinely-hormonal-annelle.ngrok-free.dev/api";
  static const String register = "$baseUrl/Account/register";
  static const String login = "$baseUrl/account/login";
}