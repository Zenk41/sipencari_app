import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';

final _dio = Dio(
  BaseOptions(baseUrl: ),
);

class AuthDioService {
  AuthDioService() {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }
  String _isNext = "";
  String get isNext => _isNext;

  Future<RegisterResponse> getAllRegister(
      BuildContext context, String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        "name": name,
        "email": email,
        "password": password,
      });

      _isNext = "success";
      RegisterResponse registerData = RegisterResponse.fromJson(response.data);
      return registerData;
    } on DioError catch (e) {
      print(e.response!.data['message']);
      _isNext = "failed";
      rethrow;
    }
  }

  Future getToken(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        "email": email,
        "password": password,
      });

      return response.data['data'];
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future getProfile(BuildContext context) async {
    try {
      final response = await _dio.get('/user/profile');
      return response.data['data'];
    } on DioError catch (e) {
      if ((e.response!.statusMessage.toString() == "invalid or expired jwt") ||
          (e.response!.statusMessage.toString() ==
              "missing or malformed jwt")) {
        AuthViewModel().removeToken();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => const WelcomePage())),
            (route) => false);
      }
      rethrow;
    }
  }
}
