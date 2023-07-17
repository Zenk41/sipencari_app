import 'dart:convert';

import 'package:sipencari_app/models/comment_like/data_comment_like_model.dart';
import 'package:sipencari_app/models/comment_picture/data_comment_picture_model.dart';
import 'package:sipencari_app/models/comment_reaction/data_comment_reaction_model.dart';
import 'package:sipencari_app/models/user/data_profile.dart';

class CommentResponse {
  CommentResponse({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<CommentData>? data;

  factory CommentResponse.fromRawJson(String str) =>
      CommentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      CommentResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<CommentData>.from(
                json["data"].map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((e) => e.toJson())),
      };
}

class CommentResponseOne {
  CommentResponseOne({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  CommentData? data;

  factory CommentResponseOne.fromRawJson(String str) =>
      CommentResponseOne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentResponseOne.fromJson(Map<String, dynamic> json) =>
      CommentResponseOne(
        status: json["status"],
        message: json["message"],
        data: CommentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class CommentData {
  CommentData(
      {this.commentId,
      this.message,
      this.discussionId,
      this.commentPictures,
      this.commentLikes,
      this.commentReactions,
      this.parentComment,
      this.userId,
      this.user,
      this.isLike,
      this.isHelpfulNo,
      this.isHelpfulYes,
      this.likeTotal,
      this.totalHelpfulYes,
      this.totalHelpfulNo,
      this.totalReaction,
      this.createdAt,
      this.updatedAt});

  String? commentId;
  String? message;
  String? discussionId;
  List<CommentPictureData>? commentPictures;
  List<CommentLikeData>? commentLikes;
  List<CommentReactionData>? commentReactions;
  String? parentComment;
  String? userId;
  ProfileData? user;
  bool? isLike;
  bool? isHelpfulYes;
  bool? isHelpfulNo;
  int? likeTotal;
  int? totalHelpfulYes;
  int? totalHelpfulNo;
  int? totalReaction;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CommentData.fromRawJson(String str) =>
      CommentData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        commentId: json["comment_id"],
        message: json["message"],
        discussionId: json["discussion_id"],
        commentPictures: json["comment_pictures"] == null
            ? null
            : List<CommentPictureData>.from(json["comment_pictures"]
                .map((x) => CommentPictureData.fromJson(x))),
        commentLikes: json["comment_likes"] == null
            ? null
            : List<CommentLikeData>.from(
                json["comment_likes"].map((x) => CommentLikeData.fromJson(x))),
        commentReactions: json["comment_reactions"] == null
            ? null
            : List<CommentReactionData>.from(json["comment_reactions"]
                .map((x) => CommentReactionData.fromJson(x))),
        parentComment: json["parent_comment"],
        userId: json["user_id"],
        user: json["user"] == null ? null : ProfileData.fromJson(json["user"]),
        isLike: json["is_like"],
        isHelpfulNo: json["is_helpful_no"],
        isHelpfulYes: json["is_helpful_yes"],
        likeTotal: json["like_total"],
        totalHelpfulYes: json["total_helpful_yes"],
        totalHelpfulNo: json["total_helpful_no"],
        totalReaction: json["total_reaction"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "message": message,
        "discussion_id": discussionId,
        "comment_pictures": commentPictures == null
            ? null
            : List<dynamic>.from(commentPictures!.map((x) => x.toJson())),
        "comment_likes": commentLikes == null
            ? null
            : List<dynamic>.from(commentLikes!.map((x) => x.toJson())),
        "comment_reactions": commentReactions == null
            ? null
            : List<dynamic>.from(commentReactions!.map((x) => x.toJson())),
        "parent_comment": parentComment,
        "user_id": userId,
        "user": user == null ? null : user!.toJson(),
        "is_like": isLike,
        "is_helpful_yes": isHelpfulYes,
        "is_helpful_no": isHelpfulNo,
        "like_total": likeTotal,
        "total_helpful_yes": totalHelpfulYes,
        "total_helpful_no": totalHelpfulNo,
        "total_reaction": totalReaction,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
