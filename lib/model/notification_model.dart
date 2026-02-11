// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  bool? success;
  String? message;
  bool? sound;
  List<Notification>? data;

  NotificationModel({
    this.success,
    this.message,   this.sound,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    success: json["success"],
    message: json["message"],
    sound: json["sound"],
    data: json["data"] == null ? [] : List<Notification>.from(json["data"]!.map((x) => Notification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message, "sound": sound,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Notification {
  String? id;
  String? userId;
  String? title;
  String? body;
  bool? isRead;
  DateTime? sentAt;
  int? v;

  Notification({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.isRead,
    this.sentAt,
    this.v,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["_id"],
    userId: json["userId"],
    title: json["title"],
    body: json["body"],
    isRead: json["isRead"],
    sentAt: json["sentAt"] == null ? null : DateTime.parse(json["sentAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "title": title,
    "body": body,
    "isRead": isRead,
    "sentAt": sentAt?.toIso8601String(),
    "__v": v,
  };
}
