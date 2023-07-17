import 'dart:convert';

import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:sipencari_app/models/user/data_profile.dart';

class CommentReactionResponse {
  CommentReactionResponse({
    this.status,
    this.message,
    this.data,
  });
  String? status;
  String? message;
  CommentReactionData? data;

  factory CommentReactionResponse.fromRawJson(String str) =>
      CommentReactionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentReactionResponse.fromJson(Map<String, dynamic> json) =>
      CommentReactionResponse(
        status: json["status"],
        message: json["message"],
        data: CommentReactionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class CommentReactionData {
  CommentReactionData(
      {this.userId,
      this.user,
      this.helpful,
      this.commentId,
      this.createdAt,
      this.updatedAt});

  String? userId;
  ProfileData? user;
  String? helpful;
  String? commentId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CommentReactionData.fromRawJson(String str) =>
      CommentReactionData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentReactionData.fromJson(Map<String, dynamic> json) =>
      CommentReactionData(
        userId: json["user_id"],
        user: json["user"] == null ? null : ProfileData.fromJson(json["user"]),
        helpful: json["helpful"],
        commentId: json["comment_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user": user == null ? null : user!.toJson(),
        "helpful": helpful,
        "comment_id": commentId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
