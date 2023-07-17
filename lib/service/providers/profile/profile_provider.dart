import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/models/user/data_profile.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/service/database/profile/profile_service.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileApi service = ProfileApi();

  DataProfile? profil;
  String _isNext = "";

  MyState myState = MyState.loading;

  Future fetchProfil(BuildContext context) async {
    try {
      myState = MyState.loading;
      notifyListeners();

      profil = await service.getProfile(context);

      // check response
      if (profil!.message == "invalid or expired jwt" ||
          profil!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }

      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        /// If want to check status code from service error
        e.response!.statusCode;
      }

      myState = MyState.failed;
      notifyListeners();
    }
  }

  Future changePicture(BuildContext context, XFile picture) async {
    try {
      myState = MyState.loading;
      notifyListeners();

      profil = await service.updatePicture(context, picture);

      // check response
      if (profil!.message == "invalid or expired jwt" ||
          profil!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }

      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        /// If want to check status code from service error
        e.response!.statusCode;
      }

      myState = MyState.failed;
      notifyListeners();
    }
  }
}
