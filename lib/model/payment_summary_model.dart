// To parse this JSON data, do
//
//     final paymentSummaryModel = paymentSummaryModelFromJson(jsonString);

import 'dart:convert';

PaymentSummaryModel paymentSummaryModelFromJson(String str) => PaymentSummaryModel.fromJson(json.decode(str));

String paymentSummaryModelToJson(PaymentSummaryModel data) => json.encode(data.toJson());

class PaymentSummaryModel {
  bool? success;
  Data? data;

  PaymentSummaryModel({
    this.success,
    this.data,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) => PaymentSummaryModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  String? month;
  int? milkQuantity;
  int? deliveryDays;
  int? extraMilk;
  int? totalLitre;
  int? pricePerLiter;
  int? totalAmount;
  String? paymentStatus;

  Data({
    this.month,
    this.milkQuantity,
    this.deliveryDays,
    this.extraMilk,
    this.totalLitre,
    this.pricePerLiter,
    this.totalAmount,
    this.paymentStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
