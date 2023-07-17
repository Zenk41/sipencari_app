import 'dart:convert';

class RegisterResponse {
  String? status;
  String? message;
  UserData? data;

  RegisterResponse({this.message, this.data, this.status});

  factory RegisterResponse.fromRawJson(String str) =>
      RegisterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        status: json["status"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class UserData {
  String? id;
  String? name;
  String? role;
  String? email;
  String? picture;
  String? address;
  String? created_at;
  String? updated_at;

  UserData({
    this.id,
    this.name,
    this.role,
    this.email,
    this.picture,
    this.address,
    this.created_at,
    this.updated_at,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
    picture = json['picture'];
    address = json['address'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['email'] = this.email;
    data['picture'] = this.picture;
    data['address'] = this.address;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

class AlternateUserData {
  String? userId;
  String? name;
  String? role;
  String? email;
  String? picture;
  String? address;
  String? createdAt;
  String? updatedAt;
  AlternateUserData(
      {this.userId,
      this.name,
      this.role,
      this.email,
      this.picture,
      this.address,
      this.createdAt,
      this.updatedAt});
  AlternateUserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
    picture = json['picture'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['role'] = this.role;
    data['email'] = this.email;
    data['picture'] = this.picture;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
