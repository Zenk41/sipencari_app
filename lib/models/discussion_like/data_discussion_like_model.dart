import 'dart:convert';

import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:sipencari_app/models/user/data_profile.dart';

class DiscussionLikeResponse {
  DiscussionLikeResponse({
    this.status,
    this.message,
    this.data,
  });
  String? status;
  String? message;
  List<DiscussionLikeData>? data;

  factory DiscussionLikeResponse.fromRawJson(String str) =>
      DiscussionLikeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionLikeResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionLikeResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<DiscussionLikeData>.from(
                json["data"].map((x) => DiscussionLikeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((e) => e.toJson())),
      };
}

class DiscussionLikeData {
  DiscussionLikeData(
      {this.userId,
      this.user,
      this.discussionId,
      this.createdAt,
      this.updatedAt});

  String? userId;
  ProfileData? user;
  String? discussionId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DiscussionLikeData.fromRawJson(String str) =>
      DiscussionLikeData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionLikeData.fromJson(Map<String, dynamic> json) =>
      DiscussionLikeData(
        userId: json["user_id"],
        user: json["user"] == null ? null : ProfileData.fromJson(json["user"]),
        discussionId: json["discussion_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user": user!.toJson(),
        "discussion_id": discussionId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
