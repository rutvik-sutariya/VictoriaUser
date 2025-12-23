// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  bool? success;
  int? count;
  List<ContactData>? data;

  ContactModel({
    this.success,
    this.count,
    this.data,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null ? [] : List<ContactData>.from(json["data"]!.map((x) => ContactData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ContactData {
  String? id;
  String? name;
  String? number;
  String? email;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ContactData({
    this.id,
    this.name,
    this.number,
    this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
    id: json["_id"],
    name: json["name"],
    number: json["number"],
    email: json["email"],
    address: json["address"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "number": number,
    "email": email,
    "address": address,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
