// To parse this JSON data, do
//
//     final milkNotesModel = milkNotesModelFromJson(jsonString);

import 'dart:convert';

MilkNotesModel milkNotesModelFromJson(String str) => MilkNotesModel.fromJson(json.decode(str));

String milkNotesModelToJson(MilkNotesModel data) => json.encode(data.toJson());

class MilkNotesModel {
  bool? success;
  List<Notes>? data;

  MilkNotesModel({
    this.success,
    this.data,
  });

  factory MilkNotesModel.fromJson(Map<String, dynamic> json) => MilkNotesModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<Notes>.from(json["data"]!.map((x) => Notes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Notes {
  String? english;
  String? gujarati;

  Notes({
    this.english,
    this.gujarati,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    english: json["english"],
    gujarati: json["gujarati"],
  );

  Map<String, dynamic> toJson() => {
    "english": english,
    "gujarati": gujarati,
  };
}
