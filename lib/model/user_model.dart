// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? success;
  Data? data;

  UserModel({this.success, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  String? profileImage;
  bool? isPersonal;
  String? fcmToken;
  String? id;
  String? name;
  String? mobile;
  String? password;
  String? address;
  dynamic sequenceNumber;
  dynamic morningLiters;
  dynamic eveningLiters;
  String? milkPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.profileImage,
    this.isPersonal,
    this.fcmToken,
    this.id,
    this.name,
    this.mobile,
    this.password,
    this.address,
    this.sequenceNumber,
    this.morningLiters,
    this.eveningLiters,
    this.milkPrice,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    profileImage: json["profileImage"],
    isPersonal: json["isPersonal"],
    fcmToken: json["fcmToken"],
    id: json["_id"],
    name: json["name"],
    mobile: json["mobile"],
    password: json["password"],
    address: json["address"],
    sequenceNumber: json["sequenceNumber"],
    morningLiters: json["morningLiters"],
    eveningLiters: json["eveningLiters"],
    milkPrice: json["milkPrice"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "profileImage": profileImage,
    "isPersonal": isPersonal,
    "fcmToken": fcmToken,
    "_id": id,
    "name": name,
    "mobile": mobile,
    "password": password,
    "address": address,
    "sequenceNumber": sequenceNumber,
    "morningLiters": morningLiters,
    "eveningLiters": eveningLiters,
    "milkPrice": milkPrice,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
