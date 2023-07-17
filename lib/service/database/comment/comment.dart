import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/models/comment/data_comment_model.dart';
import 'package:image_picker/image_picker.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: '',
  ),
);

class CommentApi {
  CommentApi() {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }

  String _isNext = "";
  String get isNext => _isNext;

  Future<CommentResponse> getComments(
      BuildContext context, String discussionID) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.get(
        '/discussions/$discussionID/comments',
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      _isNext = "success";
      print("ini dong \n\n${response.data["data"]}");
      print("ini dong \n\n${response.data}");
      CommentResponse commentData = CommentResponse.fromJson(response.data);
      print("ini bang \n\n$commentData");
      return commentData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Comment data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<String> delComments(BuildContext context, String commentID) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";

    try {
      final response = await _dio.delete(
        '/comments/$commentID',
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      _isNext = "success";

      return response.data["message"].toString();
    } on DioError catch (e) {
      _isNext = "failed";
      rethrow;
    }
  }

  Future<CommentResponseOne> postCommentData(BuildContext context,
      String message, List<XFile> commentPictures, String discussionID) async {
    final prefs = await SharedPreferences.getInstance();

    final formData = FormData();
    if (commentPictures.isNotEmpty) {
      for (var img in commentPictures) {
        formData.files.addAll([
          MapEntry("comment_pictures", await MultipartFile.fromFile(img.path)),
        ]);
      }
    }
    formData.fields.add(MapEntry("message", message));

    final String token = prefs.getString("token") ?? "";
    try {
      final response = await _dio.post('/discussions/$discussionID/comments',
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
      CommentResponseOne missingData =
          CommentResponseOne.fromJson(response.data);
      print("$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Comment data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<CommentResponseOne> putCommentData(
      BuildContext context, String message, String commentID) async {
    final prefs = await SharedPreferences.getInstance();

    final formData = FormData();
    formData.fields.add(MapEntry("message", message));

    final String token = prefs.getString("token") ?? "";
    try {
      final response = await _dio.put('/comments/$commentID',
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
      CommentResponseOne missingData =
          CommentResponseOne.fromJson(response.data);
      print("$missingData");
      return missingData;
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot update Comment data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<String> postLikeComment(BuildContext context, String commentID) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";
    try {
      final response = await _dio.post('/comments/$commentID/likes',
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
      print('cannot get Comment data');
      _isNext = "failed";
      rethrow;
    }
  }

  Future<String> postReactionComment(
      BuildContext context, String commentID, String reaction) async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString("token") ?? "";
    try {
      final response = await _dio.post('/comments/$commentID/reactions',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
          data: {"helpful": reaction.toString()},
          onSendProgress: (int sent, int total) {
        print('$sent $total');
      });

      _isNext = "success";
      print("\n\n${response.data["status"]}");
      return response.data["status"].toString();
    } on DioError catch (e) {
      print(e.response!.data["mesage"]);
      print('cannot get Comment data');
      _isNext = "failed";
      rethrow;
    }
  }
}
