import 'dart:convert';

class DiscussionLocationResponse {
  DiscussionLocationResponse({
    this.status,
    this.message,
    this.data,
  });
  String? status;
  String? message;
  List<DiscussionLocationData>? data;

  factory DiscussionLocationResponse.fromRawJson(String str) =>
      DiscussionLocationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionLocationResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionLocationResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<DiscussionLocationData>.from(
                json["data"].map((x) => DiscussionLocationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DiscussionLocationData {
  DiscussionLocationData({
    this.locationId,
    this.lat,
    this.lng,
    this.locationName,
    this.discussionId,
  });
  int? locationId;
  double? lat;
  double? lng;
  String? locationName;
  String? discussionId;

  factory DiscussionLocationData.fromRawJson(String str) =>
      DiscussionLocationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscussionLocationData.fromJson(Map<String, dynamic> json) =>
      DiscussionLocationData(
        locationId: json["location_id"],
        lat: json["lat"],
        lng: json["lng"],
        locationName: json["location_name"],
        discussionId: json["discussion_id"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "lat": lat,
        "lng": lng,
        "location_name": locationName,
        "discussion_id": discussionId,
      };
}
