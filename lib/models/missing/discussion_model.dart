import 'dart:convert';

import 'package:sipencari_app/models/auth/register_model.dart';
import 'package:sipencari_app/models/comment/data_comment_model.dart';
import 'package:sipencari_app/models/discussion_like/data_discussion_like_model.dart';
import 'package:sipencari_app/models/discussion_location/data_discussion_location.dart';
import 'package:sipencari_app/models/discussion_picture/data_discussion_picture_model.dart';
import 'package:sipencari_app/models/user/data_profile.dart';

class DiscussionResponse {
  DiscussionResponse({this.status, this.message, this.data});

  final String? status;
  final String? message;
  final Data? data;

  factory DiscussionResponse.fromRawJson(String str) =>
      DiscussionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data,
      };
}

class DiscussionResponseOne {
  DiscussionResponseOne({this.status, this.message, this.data});

  final String? status;
  final String? message;
  final DiscussionData? data;

  factory DiscussionResponseOne.fromRawJson(String str) =>
      DiscussionResponseOne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionResponseOne.fromJson(Map<String, dynamic> json) =>
      DiscussionResponseOne(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : DiscussionData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data,
      };
}

class DiscussionResponseNoPag {
  DiscussionResponseNoPag({this.status, this.message, this.data});

  final String? status;
  final String? message;
  final List<DiscussionData>? data;

  factory DiscussionResponseNoPag.fromRawJson(String str) =>
      DiscussionResponseNoPag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionResponseNoPag.fromJson(Map<String, dynamic> json) =>
      DiscussionResponseNoPag(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<DiscussionData>.from(
                json["data"].map((x) => DiscussionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((e) => e.toJson())),
      };
}

class Data {
  List<DiscussionData>? items;
  int? page;
  int? size;
  int? maxPage;
  int? totalPages;
  int? total;
  bool? last;
  bool? first;
  int? visible;

  Data(
      {this.items,
      this.page,
      this.size,
      this.maxPage,
      this.totalPages,
      this.total,
      this.last,
      this.first,
      this.visible});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <DiscussionData>[];
      json['items'].forEach((v) {
        items!.add(new DiscussionData.fromJson(v));
      });
    }
    page = json['page'];
    size = json['size'];
    maxPage = json['max_page'];
    totalPages = json['total_pages'];
    total = json['total'];
    last = json['last'];
    first = json['first'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((x) => x.toJson()).toList();
    }
    data['page'] = this.page;
    data['size'] = this.size;
    data['max_page'] = this.maxPage;
    data['total_pages'] = this.totalPages;
    data['total'] = this.total;
    data['last'] = this.last;
    data['first'] = this.first;
    data['visible'] = this.visible;
    return data;
  }
}

class DiscussionData {
  DiscussionData({
    this.discussionId,
    this.title,
    this.category,
    this.content,
    this.discussionPictures,
    this.discussionLocation,
    this.discussionLikes,
    this.userId,
    this.user,
    this.comments,
    this.status,
    this.privacy,
    this.iLike,
    this.likeTotal,
    this.commmentTotal,
    this.createdAt,
    this.updatedAt,
  });

  String? discussionId;
  String? title;
  String? category;
  String? content;
  List<DiscussionPictureData>? discussionPictures;
  DiscussionLocationData? discussionLocation;
  List<DiscussionLikeData>? discussionLikes;
  String? userId;
  ProfileData? user;
  List<CommentData>? comments;
  String? status;
  String? privacy;
  bool? iLike;
  int? likeTotal;
  int? commmentTotal;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DiscussionData.fromRawJson(String str) =>
      DiscussionData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionData.fromJson(Map<String, dynamic> json) => DiscussionData(
        discussionId:
            json["discussion_id"] == null ? null : json["discussion_id"],
        title: json["title"] == null ? null : json["title"],
        category: json["category"] == null ? null : json["category"],
        content: json["content"] == null ? null : json["content"],
        discussionPictures: json["discussion_pictures"] == null
            ? null
            : List<DiscussionPictureData>.from(json["discussion_pictures"]
                .map((x) => DiscussionPictureData.fromJson(x))),
        discussionLocation: json["discussion_location"] == null
            ? null
            : DiscussionLocationData.fromJson(json["discussion_location"]),
        discussionLikes: json["discussion_likes"] == null
            ? null
            : List<DiscussionLikeData>.from(json["discussion_likes"]
                .map((x) => DiscussionLikeData.fromJson(x))),
        userId: json["user_id"] == null ? null : json["user_id"],
        user: json["user"] == null ? null : ProfileData.fromJson(json["user"]),
        comments: json["comments"] == null
            ? null
            : List<CommentData>.from(
                json["comments"].map((x) => CommentData.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
        privacy: json["privacy"] == null ? null : json["privacy"],
        iLike: json["i_like"] == null ? null : json["i_like"],
        likeTotal: json["like_total"] == null ? null : json["like_total"],
        commmentTotal:
            json["comment_total"] == null ? null : json["comment_total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "discussion_id": discussionId,
        "title": title,
        "category": category,
        "content": content,
        "discussion_pictures": discussionPictures == null
            ? null
            : List<dynamic>.from(discussionPictures!.map((x) => x.toJson())),
        "discussion_location":
            discussionLocation == null ? null : discussionLocation!.toJson(),
        "discussion_likes": discussionLikes == null
            ? null
            : List<dynamic>.from(discussionLikes!.map((x) => x.toJson())),
        "user_id": userId,
        "user": user == null ? null : user!.toJson(),
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "status": status,
        "privacy": privacy,
        "i_like": iLike,
        "like_total": likeTotal,
        "comment_total": commmentTotal,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
