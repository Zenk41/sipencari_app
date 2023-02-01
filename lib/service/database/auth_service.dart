import 'package:dio/dio.dart';
import 'package:sipencari_app/models/auth/register_model.dart';

final _dio = Dio(
  BaseOptions(baseUrl: 'https://dev-api.sipencari.com/api/v1'),
);

class RegisterDioService {
  RegisterDioService() {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }
  String _isNext = "";
  String get isNext => _isNext;

  Future<Data> getAllRegister(
      String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        "name": name,
        "email": email,
        "password": password,
      });

      _isNext = "success";
      return response.data['data'];
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

      final data = response.data['data'];

      return data['token'];
    } on DioError catch (e) {
      rethrow;
    }
  }
}
