import 'dart:convert';

class DiscussionPictureResponse {
  DiscussionPictureResponse({
    this.status,
    this.message,
    this.data,
  });
  final String? status;
  final String? message;
  final List<DiscussionPictureData>? data;

  factory DiscussionPictureResponse.fromRawJson(String str) =>
      DiscussionPictureResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionPictureResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionPictureResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<DiscussionPictureData>.from(
                json["data"].map((x) => DiscussionPictureData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DiscussionPictureData {
  DiscussionPictureData(
      {this.pictureId,
      this.url,
      this.discussionId,
      this.createdAt,
      this.updatedAt});

  int? pictureId;
  String? url;
  String? discussionId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DiscussionPictureData.fromRawJson(String str) =>
      DiscussionPictureData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionPictureData.fromJson(Map<String, dynamic> json) =>
      DiscussionPictureData(
        pictureId: json["picture_id"],
        url: json["url"],
        discussionId: json["discussion_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "picture_id": pictureId,
        "url": url,
        "discussion_id": discussionId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
