// To parse this JSON data, do
//
//     final milkHistoryModel = milkHistoryModelFromJson(jsonString);

import 'dart:convert';

MilkHistoryModel milkHistoryModelFromJson(String str) => MilkHistoryModel.fromJson(json.decode(str));

String milkHistoryModelToJson(MilkHistoryModel data) => json.encode(data.toJson());

class MilkHistoryModel {
  bool? success;
  String? filterType;
  int? count;
  List<Datum>? data;

  MilkHistoryModel({
    this.success,
    this.filterType,
    this.count,
    this.data,
  });

  factory MilkHistoryModel.fromJson(Map<String, dynamic> json) => MilkHistoryModel(
    success: json["success"],
    filterType: json["filterType"],
    count: json["count"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "filterType": filterType,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? date;
  String? time;
  String? slot;
  int? liters;
  String? status;
  String? paymentStatus;

  Datum({
    this.date,
    this.time,
    this.slot,
    this.liters,
    this.status,
    this.paymentStatus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: json["date"],
    time: json["time"],
    slot: json["slot"],
    liters: json["liters"],
    status: json["status"],
    paymentStatus: json["paymentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "time": time,
    "slot": slot,
    "liters": liters,
    "status": status,
    "paymentStatus": paymentStatus,
  };
}
