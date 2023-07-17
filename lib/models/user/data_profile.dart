import 'dart:convert';

class DataProfile {
  DataProfile({this.status, this.message, this.data});

  final String? status;
  final String? message;
  final ProfileData? data;

  factory DataProfile.fromRawJson(String str) =>
      DataProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataProfile.fromJson(Map<String, dynamic> json) => DataProfile(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class ProfileData {
  ProfileData({
    this.userId,
    this.name,
    this.role,
    this.email,
    this.picture,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  final String? userId;
  final String? name;
  final String? role;
  final String? email;
  final String? picture;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProfileData.fromRawJson(String str) =>
      ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        userId: json["user_id"],
        name: json["name"],
        role: json["role"],
        email: json["email"],
        picture: json["picture"],
        address: json["address"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "role": role,
        "email": email,
        "picture": picture,
        "address": address,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
