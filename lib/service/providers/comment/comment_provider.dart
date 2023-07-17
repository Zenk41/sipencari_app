import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sipencari_app/models/comment/data_comment_model.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/service/database/comment/comment.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';

class CommentProvider extends ChangeNotifier {
  final CommentApi service = CommentApi();

  CommentResponse? commentInList;
  CommentResponseOne? commentDetail;

  MyState myState = MyState.loading;
  MyState myState2 = MyState.loading;

  List<int> currentPosts = [];

  Future fetchComments(BuildContext context, String discussionID) async {
    try {
      myState = MyState.loading;
      notifyListeners();

      commentInList = await service.getComments(context, discussionID);
      // check response
      if (commentInList!.message == "invalid or expired jwt" ||
          commentInList!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }
      for (var i = 0; i < commentInList!.data!.length; i++) {
        currentPosts.add(0);
      }

      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          AuthViewModel().removeToken();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }
      }
      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      notifyListeners();
    }
  }

  Future likeComment(BuildContext context, String commentID) async {
    try {
      myState = MyState.loading;
      myState2 = MyState.loading;
      notifyListeners();

      final String isLike = await service.postLikeComment(context, commentID);
      myState = MyState.loaded;
      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      myState2 = MyState.failed;
      notifyListeners();
    }
  }

  Future reactYesComment(BuildContext context, String commentID) async {
    try {
      myState = MyState.loading;
      myState2 = MyState.loading;
      notifyListeners();

      final String isLike =
          await service.postReactionComment(context, commentID, "Yes");
      myState = MyState.loaded;
      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      myState2 = MyState.failed;
      notifyListeners();
    }
  }

  Future reactNoComment(BuildContext context, String commentID) async {
    try {
      myState = MyState.loading;
      myState2 = MyState.loading;
      notifyListeners();

      final String isLike =
          await service.postReactionComment(context, commentID, "No");
      myState = MyState.loaded;
      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      myState2 = MyState.failed;
      notifyListeners();
    }
  }
  Future delComment(BuildContext context, String commentID) async {
    try {
      myState = MyState.loading;
      myState2 = MyState.loading;
      notifyListeners();

      final String isDelete =
          await service.delComments(context, commentID);
      if (commentInList!.message == "invalid or expired jwt" ||
          commentInList!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      }
      myState = MyState.loaded;
      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      myState2 = MyState.failed;
      notifyListeners();
    }
  }

}
