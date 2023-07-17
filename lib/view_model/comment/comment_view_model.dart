import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/models/comment/data_comment_model.dart';
import 'package:sipencari_app/models/comment/payload_comment.dart';
import 'package:sipencari_app/service/database/comment/comment.dart';
import 'package:image_picker/image_picker.dart';

class CommentViewModel with ChangeNotifier {
  final _dioService = CommentApi();
  CommentResponseOne? dataComment;
  static final _shared = SharedPreferences.getInstance();
  String? isNext;
  String? message;

  String _simpanData = '';

  CommentModel? _data;
  CommentModel get data => _data!;

  void saveData(CommentModel dataComment) {
    _data = dataComment;
  }

  void postComment(BuildContext context, String message,
      List<XFile> commentPictures, String discussionID) async {
    bool isSuccess = false;
    try {
      print("create discussion");
      final result = await _dioService.postCommentData(
          context, message, commentPictures, discussionID);

      dataComment = result;
      isSuccess = true;
    } catch (e) {
      if (e is DioError) {
        print(e.response!.data["message"]);
        if (e.response!.data["message"] == "internal server error") {
          isNext = "internal server error";
          print("response internal server error");
        }

        if (e.response!.data["message"] == "invalid request") {
          isNext = "invalid request";
          print("response invalid request");
        }

        if (e.response!.data["message"] == "validation failed") {
          isNext = "validation failed";
          print("response invalid request");
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

  void putComment(
      BuildContext context, String message, String commentID) async {
    bool isSuccess = false;
    try {
      print("edit comment");
      final result =
          await _dioService.putCommentData(context, message, commentID);

      dataComment = result;
      isSuccess = true;
    } catch (e) {
      if (e is DioError) {
        //  print("gagal");
        print(e.response!.data["message"]);
        if (e.response!.data["message"] == "internal server error") {
          isNext = "internal server error";
          print("response internal server error");
        }

        if (e.response!.data["message"] == "invalid request") {
          isNext = "invalid request";
          print("response invalid request");
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
}
