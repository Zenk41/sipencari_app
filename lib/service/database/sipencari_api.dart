// import 'dart:io';

// import 'package:dio/dio.dart';

// final _dio = Dio(
//   BaseOptions(
//     baseUrl: 'https://dev-api.sipencari.com/api/v1',
//   ),
// );

// class SipencariApi {
//   SipencariApi() {
//     _dio.interceptors.add(
//       LogInterceptor(
//         responseBody: true,
//         requestBody: true,
//       ),
//     );
//   }

//   String _isNext = "";
//   String get isNext => _isNext;

//   Future<List<user>> getProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String token = prefs.getString("token") ?? "";
    
//     try {
//       final response = await _dio.get('/user/profile')
//     }
//   }
// }
