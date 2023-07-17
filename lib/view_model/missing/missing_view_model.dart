import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/models/missing/data_discussion_model.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:sipencari_app/service/database/discussion/discussion_service.dart';
import 'package:image_picker/image_picker.dart';

class MissingViewModel with ChangeNotifier {
  final _dioService = DiscussionApi();
  DiscussionResponseOne? dataDiscussion;
  static final _shared = SharedPreferences.getInstance();
  String? isNext;
  String? message;

  String _simpanData = '';

  DiscussionModel1? _data1;
  DiscussionModel2? _data2;
  DiscussionModel1 get data1 => _data1!;
  DiscussionModel2 get data2 => _data2!;

  void saveData1(DiscussionModel1 dataDiscussion) {
    _data1 = dataDiscussion;
  }

  void saveData2(DiscussionModel2 dataDiscussion) {
    _data2 = dataDiscussion;
  }

  void postDiscussion(
      BuildContext context,
      String title,
      String content,
      String category,
      List<XFile> discussionPictures,
      String lat,
      String lng,
      String status,
      String privacy) async {
    bool isSuccess = false;
    try {
      print("create discussion");
      final result = await _dioService.postDiscussionData(context, title,
          content, category, discussionPictures, lat, lng, status, privacy);

      dataDiscussion = result;
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
      } isSuccess = false;
    }
    if (isSuccess) {
      print("success");
      isNext = "success";
    }
    notifyListeners();
  }

  void putDiscussion(
      BuildContext context,
      String discussionID,
      String title,
      String content,
      String category,
      String lat,
      String lng,
      String status,
      String privacy) async {
    bool isSuccess = false; // Flag to track success status

    try {
      print("update discussion");
      final result = await _dioService.putDiscussionData(context, discussionID,
          title, content, category, lat, lng, status, privacy);

      dataDiscussion = result;
      isSuccess = true; // Set the flag to true if no error occurs
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
      } else {
        print("Non-DioError exception occurred");
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
