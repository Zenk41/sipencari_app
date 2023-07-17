import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/models/discussion_like/data_discussion_like_model.dart';
import 'package:sipencari_app/models/missing/data_discussion_model.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:image_picker/image_picker.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: '',
  ),
);

class DiscussionApi {
  DiscussionApi() {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }

  String _isNext = "";
  String get isNext => _isNext;

  Future<DiscussionResponse> getDiscussionPublic(
      BuildContext context, String? size, String? page) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.get('/discussions',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }),
          queryParameters: {
            "size": size,
            "page": page,
            "sort": "-created_at",
            "privacy": "Public",
          });
      _isNext = "success";
      print("ini dong \n\n${response.data["data"]}");
      print("ini dong \n\n${response.data}");
      DiscussionResponse missingData =
          DiscussionResponse.fromJson(response.data);
      print("ini bang \n\n$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DiscussionResponseNoPag> getMyDiscussion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.get(
        '/discussions/mine',
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      _isNext = "success";
      print("my discussion \n\n${response.data["data"]}");
      print("my discussion \n\n${response.data}");
      DiscussionResponseNoPag missingData =
          DiscussionResponseNoPag.fromJson(response.data);
      print("my discussion \n\n$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DiscussionResponseOne> getDetailDiscussion(
      BuildContext context, String discussionID) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.get(
        '/discussions/$discussionID',
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      _isNext = "success";
      print("my discussion \n\n${response.data["data"]}");
      print("my discussion \n\n${response.data}");
      DiscussionResponseOne missingData =
          DiscussionResponseOne.fromJson(response.data);
      print("my discussion \n\n$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<String> delDiscussion(
      BuildContext context, String discussionID) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";
    try {
      final response = await _dio.delete('/discussions/$discussionID',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          ));

      _isNext = "success";
      print("\n\n${response.data["status"]}");
      return response.data["status"].toString();
    } on DioError catch (e) {
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DiscussionResponseOne> putDiscussionData(
      BuildContext context,
      String discussionID,
      String title,
      String content,
      String category,
      String lat,
      String lng,
      String status,
      String privacy) async {
    final prefs = await SharedPreferences.getInstance();
    final formData = FormData();
    final String token = prefs.getString("token") ?? "";

    formData.fields.add(MapEntry("title", title));
    formData.fields.add(MapEntry("category", category));
    formData.fields.add(MapEntry("content", content));
    formData.fields.add(MapEntry("lat", lat));
    formData.fields.add(MapEntry("lng", lng));
    formData.fields.add(MapEntry("status", status));
    formData.fields.add(MapEntry("privacy", privacy));

    try {
      final response = await _dio.put('/discussions/$discussionID',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }),
          data: formData, onSendProgress: (int sent, int total) {
        print('$sent $total');
      });
      _isNext = "success";
      print("my discussion \n\n${response.data["data"]}");
      print("my discussion \n\n${response.data}");
      DiscussionResponseOne missingData =
          DiscussionResponseOne.fromJson(response.data);
      print("my discussion \n\n$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<DiscussionResponseOne> postDiscussionData(
      BuildContext context,
      String title,
      String content,
      String category,
      List<XFile> discussionPictures,
      String lat,
      String lng,
      String status,
      String privacy) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    final formData = FormData();
    for (var img in discussionPictures) {
      formData.files.addAll([
        MapEntry("discussion_pictures", await MultipartFile.fromFile(img.path)),
      ]);
    }
    formData.fields.add(MapEntry("title", title));
    formData.fields.add(MapEntry("category", category));
    formData.fields.add(MapEntry("content", content));
    formData.fields.add(MapEntry("lat", lat));
    formData.fields.add(MapEntry("lng", lng));
    formData.fields.add(MapEntry("status", status));
    formData.fields.add(MapEntry("privacy", privacy));

    try {
      final response = await _dio.post('/discussions',
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
      DiscussionResponseOne missingData =
          DiscussionResponseOne.fromJson(response.data);
      print("$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<String> postLikeDiscussion(
      BuildContext context, String discussionID) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";
    try {
      final response = await _dio.post('/discussions/$discussionID/likes',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          ), onSendProgress: (int sent, int total) {
        print('$sent $total');
      });

      _isNext = "success";
      print("\n\n${response.data["status"]}");
      return response.data["status"].toString();
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Discussion data');
      _isNext = "failed";
      rethrow;
    }
  }
}
