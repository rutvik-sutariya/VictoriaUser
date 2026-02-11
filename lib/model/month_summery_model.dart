// To parse this JSON data, do
//
//     final monthSummeryModel = monthSummeryModelFromJson(jsonString);

import 'dart:convert';

MonthSummeryModel monthSummeryModelFromJson(String str) => MonthSummeryModel.fromJson(json.decode(str));

String monthSummeryModelToJson(MonthSummeryModel data) => json.encode(data.toJson());

class MonthSummeryModel {
  bool? success;
  List<PendingMonth>? pendingMonths;
  Summary? summary;

  MonthSummeryModel({
    this.success,
    this.pendingMonths,
    this.summary,
  });

  factory MonthSummeryModel.fromJson(Map<String, dynamic> json) => MonthSummeryModel(
    success: json["success"],
    pendingMonths: json["pendingMonths"] == null ? [] : List<PendingMonth>.from(json["pendingMonths"]!.map((x) => PendingMonth.fromJson(x))),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "pendingMonths": pendingMonths == null ? [] : List<dynamic>.from(pendingMonths!.map((x) => x.toJson())),
    "summary": summary?.toJson(),
  };
}

class PendingMonth {
  String? month;
  dynamic milkQuantity;
  dynamic deliveryDays;
  dynamic extraMilk;
  dynamic totalLitre;
  dynamic pricePerLiter;
  dynamic totalAmount;
  String? paymentStatus;

  PendingMonth({
    this.month,
    this.milkQuantity,
    this.deliveryDays,
    this.extraMilk,
    this.totalLitre,
    this.pricePerLiter,
    this.totalAmount,
    this.paymentStatus,
  });

  factory PendingMonth.fromJson(Map<String, dynamic> json) => PendingMonth(
    month: json["month"],
    milkQuantity: json["milkQuantity"],
    deliveryDays: json["deliveryDays"],
    extraMilk: json["extraMilk"],
    totalLitre: json["totalLitre"],
    pricePerLiter: json["pricePerLiter"],
    totalAmount: json["totalAmount"],
    paymentStatus: json["paymentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "milkQuantity": milkQuantity,
    "deliveryDays": deliveryDays,
    "extraMilk": extraMilk,
    "totalLitre": totalLitre,
    "pricePerLiter": pricePerLiter,
    "totalAmount": totalAmount,
    "paymentStatus": paymentStatus,
  };
}

class Summary {
  dynamic totalMilkQuantity;
  dynamic? totalExtraMilk;
  dynamic? totalDeliveryDays;
  dynamic? totalLiters;
  dynamic? pricePerLiter;
  dynamic? totalAmount;
  String? paymentStatus;

  Summary({
    this.totalMilkQuantity,
    this.totalExtraMilk,
    this.totalDeliveryDays,
    this.totalLiters,
    this.pricePerLiter,
    this.totalAmount,
    this.paymentStatus,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalMilkQuantity: json["totalMilkQuantity"],
    totalExtraMilk: json["totalExtraMilk"],
    totalDeliveryDays: json["totalDeliveryDays"],
    totalLiters: json["totalLiters"],
    pricePerLiter: json["pricePerLiter"],
    totalAmount: json["totalAmount"],
    paymentStatus: json["paymentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "totalMilkQuantity": totalMilkQuantity,
    "totalExtraMilk": totalExtraMilk,
    "totalDeliveryDays": totalDeliveryDays,
    "totalLiters": totalLiters,
    "pricePerLiter": pricePerLiter,
    "totalAmount": totalAmount,
    "paymentStatus": paymentStatus,
  };
}
