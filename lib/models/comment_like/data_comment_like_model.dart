import 'dart:convert';

import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:sipencari_app/models/user/data_profile.dart';

class CommentLikeResponse {
  CommentLikeResponse({
    this.status,
    this.message,
    this.data,
  });
  String? status;
  String? message;
  CommentLikeData? data;

  factory CommentLikeResponse.fromRawJson(String str) =>
      CommentLikeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentLikeResponse.fromJson(Map<String, dynamic> json) =>
      CommentLikeResponse(
        status: json["status"],
        message: json["message"],
        data: CommentLikeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class CommentLikeData {
  CommentLikeData(
      {this.userId, this.user, this.commentId, this.createdAt, this.updatedAt});

  String? userId;
  ProfileData? user;
  String? commentId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CommentLikeData.fromRawJson(String str) => CommentLikeData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());


  factory CommentLikeData.fromJson(Map<String, dynamic> json) =>
      CommentLikeData(
        userId: json["user_id"],
        user: json["user"] == null ? null : ProfileData.fromJson(json["user"]),
        commentId: json["comment_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user": user == null ? null : user!.toJson(),
        "comment_id": commentId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
