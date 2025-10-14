import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:victoria_user/main.dart';
import 'package:victoria_user/services/local_storage/local_storage.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Constant {
  static RxString userId = "${prefs.getString(LocalStorage.userId.value)}".obs;
  static RxString token =
      "${prefs.getString(LocalStorage.accessToken.toString())}".obs;

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }
}
