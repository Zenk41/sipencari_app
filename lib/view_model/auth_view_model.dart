import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sipencari_app/models/auth/data_register_model.dart';
import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/database/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final _dioService = RegisterDioService();

  Data? dataRegister;
  static final _shared = SharedPreferences.getInstance();
  static const _token = 'token';
  String? isNext;
  String? message;

  bool _is8Digit = false;
  bool _isLowerCase = false;
  bool _isCapital = false;
  bool _isNumber = false;
  String _saveData = '';
  bool _passVissible = true;
  bool _passVissible2 = true;
  RegisterModel? _data;

  bool get is8Digit => _is8Digit;
  bool get isLowerCase => _isLowerCase;
  bool get isCapital => _isCapital;
  bool get isNumber => _isNumber;
  String get saveData => _saveData;
  bool get passVissible => _passVissible;
  bool get passVissible2 => passVissible2;
  RegisterModel get data => data!;

  void saveDataUser(RegisterModel dataRegister) {
    _data = data;
  }

  void getAllRegister(String name, String email, String password) async {
    try {
      print("dijalankan");
      final result = await _dioService.getAllRegister(name, email, password);

      dataRegister = result;
      print("tes$result");
    } catch (e) {
      if (e is DioError) {
        print(e.response!.data["message"]);
        if (e.response!.data["message"] == "Email Already Exist") {
          isNext = "email";
          print("response email");
        }
      } else {
        print("success");
        isNext = "success";
      }
    }
    notifyListeners();
  }

  Future<void> getToken(String email, String password) async {
    try {
      final result = await _dioService.getToken(email, password);
      print('$result data result');
      message = "success";
      saveToken(result);
    } catch (e) {
      if (e is DioError) {
        print(e.response!.data['message']);
        message = e.response!.data['message'];
      }
      print(e);
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
