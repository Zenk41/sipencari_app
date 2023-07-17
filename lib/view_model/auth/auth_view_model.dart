import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sipencari_app/models/auth/data_register_model.dart';
import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sipencari_app/service/database/auth/auth_service.dart';
import 'package:sipencari_app/service/database/profile/profile_service.dart';

class AuthViewModel with ChangeNotifier {
  final _dioService = AuthDioService();
  final _dioServiceProfile = ProfileApi();

  RegisterResponse? registerR;

  UserData? dataRegister;
  static final _shared = SharedPreferences.getInstance();
  static const _token = 'token';
  String? isNext;
  String? message;
  String? error;

  bool _is8Digit = false;
  bool _isLowerCase = false;
  bool _isCapital = false;
  bool _isNumber = false;
  String _saveData = '';
  bool _passVissibleOld = true;
  bool _passVissible = true;
  bool _passVissible2 = true;
  RegisterModel? _data;

  bool get is8Digit => _is8Digit;
  bool get isLowerCase => _isLowerCase;
  bool get isCapital => _isCapital;
  bool get isNumber => _isNumber;
  String get saveData => _saveData;
  bool get passVissibleOld => _passVissibleOld;
  bool get passVissible => _passVissible;
  bool get passVissible2 => _passVissible2;
  RegisterModel get data => _data!;

  // void saveDataUser(RegisterModel dataRegister) {
  //   _data = dataRegister;
  //   notifyListeners();
  // }

  Future<void> getAllRegister(
      BuildContext context, String name, String email, String password) async {
    bool isSuccess = false;
    try {
      print("run");
      final result =
          await _dioService.getAllRegister(context, name, email, password);
      isSuccess = true;
      registerR = result;
    } catch (e) {
      if (e is DioError) {
        if (e.response!.data["message"] == "Email Already Exist") {
          isNext = "email";
          print(e.response!.data["message"].toString());
        }
      }
      isSuccess = false;
    }
    if (isSuccess) {
      print("success");
      isNext = "success";
    }
    notifyListeners();
  }

  Future<void> getToken(String email, String password) async {
    bool isSuccess = false;
    try {
      final result = await _dioService.getToken(email, password);
      final token = result['token'];
      print('$token data result');
      message = "login success";
      saveToken(token);
      isSuccess = true;
    } catch (e) {
      if (e is DioError) {
        print(e.response!.data['message']);
        message = e.response!.data['message'];
      }
      print(e);
    }
    if (isSuccess) {
      print("success");
      isNext = "success";
    }
    notifyListeners();
  }

  Future<void> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    bool isSuccess = false;
    try {
      final result = await _dioServiceProfile.changePassword(
          context, oldPassword, newPassword);
      isNext = "success";
      message = "success update password";
      isSuccess = true;
    } catch (e) {
      if (e is DioError) {
        print(e.response!.data['message']);
        error = e.response!.data['error'];
        isNext = error;
      }
      print(e);
    }
    if (isSuccess) {
      print("success");
      isNext = "success";
    }
    notifyListeners();
  }

  Future<void> changeData(BuildContext context, String? name, String? email,
      String? address) async {
    bool isSuccess = false;
    try {
      final result =
          await _dioServiceProfile.changeData(context, name!, email!, address!);
      isNext = "success";
      message = "success update password";
      isSuccess = true;
    } catch (e) {
      if (e is DioError) {
        print(e.response!.data["message"]);
        if (e.response!.data["message"] == "Email Already Exist") {
          isNext = "email";
          print("response email");
        }
      }
    }
    if (isSuccess) {
      print("success");
      isNext = "success";
    }
    notifyListeners();
  }

  void setIfValueEmpty() {
    _is8Digit = false;
    _isLowerCase = false;
    _isCapital = false;
    _isNumber = false;
    notifyListeners();
  }

  void setIfValueNotEmpty() {
    _is8Digit = true;
    _isLowerCase = true;
    _isCapital = true;
    _isNumber = true;
    notifyListeners();
  }

  void setIfValueNotMatch() {
    _is8Digit = false;
    notifyListeners();
  }

  void setIfLowerCaseNotMatch() {
    _isLowerCase = false;
    notifyListeners();
  }

  void setIfCapitalNotMatch() {
    _isCapital = false;
    notifyListeners();
  }

  void setIfNumberNotMatch() {
    _isNumber = false;
    notifyListeners();
  }

  void setPassVissible() {
    _passVissible = !_passVissible;
    notifyListeners();
  }

  void setPassVissibleOld() {
    _passVissibleOld = !_passVissibleOld;
    notifyListeners();
  }

  void setPassVissible2() {
    _passVissible2 = !_passVissible2;
    notifyListeners();
  }

  Future<bool> saveToken(String token) async {
    final shared = await _shared;
    return await shared.setString(_token, token);
  }

  Future<String?> getToken1() async {
    final shared = await _shared;
    return shared.getString(_token);
  }

  Future<bool> removeToken() async {
    final token = await getToken1();
    if (token == null) return false;

    final shared = await _shared;
    return await shared.remove(_token);
  }
}
