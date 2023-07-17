import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:sipencari_app/models/user/data_profile.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:image_picker/image_picker.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: '',
  ),
);

class ProfileApi {
  ProfileApi() {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }

  String _isNext = "";
  String get isNext => _isNext;

  Future<DataProfile> getProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.get('/user/profile',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      _isNext = "success";
      print("\n\n${response.data}");
      DataProfile dataProfile = DataProfile.fromJson(response.data);
      return dataProfile;
    } on DioError catch (e) {
      if (e.response!.data['message'] == "invalid or expired jwt" ||
          e.response!.data['message'] == "missing or malformed jwt") {
        AuthViewModel().removeToken();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }
      print(e.response!.data['message']);
      print('cannot get user profile');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DataProfile> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.put('/user/setting/update-password',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }),
          data: {"old_password": oldPassword, "new_password": newPassword},
          onSendProgress: (int sent, int total) {
        print('$sent $total');
      });
      _isNext = "success";
      print("\n\n${response.data}");
      DataProfile dataProfile = DataProfile.fromJson(response.data);
      return dataProfile;
    } on DioError catch (e) {
      if (e.response!.data['message'] == "invalid or expired jwt" ||
          e.response!.data['message'] == "missing or malformed jwt") {
        AuthViewModel().removeToken();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }
      print(e.response!.data['message']);
      print('cannot update password ');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DataProfile> changeData(
      BuildContext context, String name, String email, String address) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? "";

    dynamic data;
    if (name.isNotEmpty && email.isNotEmpty && address.isNotEmpty) {
      data = {"name": name, "email": email, "address": address};
    }
    if (name.isNotEmpty && email.isEmpty && address.isEmpty) {
      data = {"name": name};
    }
    if (email.isNotEmpty && email.isNotEmpty && address.isEmpty) {
      data = {"name": name, "email": email};
    }
    if (name.isEmpty && email.isNotEmpty && address.isEmpty) {
      data = {"email": email};
    }
    if (name.isEmpty && email.isNotEmpty && address.isNotEmpty) {
      data = {"email": email, "address": address};
    }
    if (name.isEmpty && email.isEmpty && address.isNotEmpty) {
      data = {"address": address};
    }
    if (name.isNotEmpty && email.isEmpty && address.isNotEmpty) {
      data = {"name": name, "address": address};
    }
    print({data});
    try {
      final response = await _dio.put('/user/setting/update-data',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }),
          data: data, onSendProgress: (int sent, int total) {
        print('$sent $total');
      });
      _isNext = "success";
      print("\n\n${response.data}");
      DataProfile dataProfile = DataProfile.fromJson(response.data);
      return dataProfile;
    } on DioError catch (e) {
      if (e.response!.data['message'] == "invalid or expired jwt" ||
          e.response!.data['message'] == "missing or malformed jwt") {
        AuthViewModel().removeToken();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }
      print(e.response!.data['message']);
      print('cannot update password ');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DataProfile> updatePicture(
    BuildContext context,
    XFile picture,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    final formData = FormData();

    formData.files.add(MapEntry(
        "picture", await MultipartFile.fromFile(picture.path)));

    try {
      final response = await _dio.put('/user/setting/update-picture',
          options: Options(
            headers: {
              "Content-Type": "application/form-data",
              "Authorization": "Bearer $token",
            },
          ),
          data: formData, onSendProgress: (int sent, int total) {
        print('$sent $total');
      });

      _isNext = "success";
      print("\n\n${response.data["data"]}");
      DataProfile dataProfile = DataProfile.fromJson(response.data);
      print("$dataProfile");
      return dataProfile;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }
}
