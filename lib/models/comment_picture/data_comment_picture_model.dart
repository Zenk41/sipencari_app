import 'dart:convert';

class CommentPictureResponse {
  CommentPictureResponse({
    this.status,
    this.message,
    this.data,
  });
  final String? status;
  final String? message;
  final List<CommentPictureData>? data;

  factory CommentPictureResponse.fromRawJson(String str) =>
      CommentPictureResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentPictureResponse.fromJson(Map<String, dynamic> json) =>
      CommentPictureResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<CommentPictureData>.from(
                json["data"].map((x) => CommentPictureData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}


class CommentPictureData {
  CommentPictureData(
      {this.pictureId,
      this.url,
      this.commentId,
      this.createdAt,
      this.updatedAt});

  int? pictureId;
  String? url;
  String? commentId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CommentPictureData.fromRawJson(String str) =>
      CommentPictureData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentPictureData.fromJson(Map<String, dynamic> json) =>
      CommentPictureData(
        pictureId: json["picture_id"],
        url: json["url"],
        commentId: json["comment_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "picture_id": pictureId,
        "url": url,
        "comment_id": commentId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
