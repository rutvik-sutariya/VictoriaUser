import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:flutter/material.dart';


void showSnackBar(String message,) {

  final snackBar = GetSnackBar(
    backgroundColor: AppColors.appBlackColor,
    message: message,
    duration: const Duration(milliseconds: 1500),
  );
  Get.showSnackbar(snackBar);
}

double height = Get.height;
double width = Get.width;

Future<void> delay(int time) async {
  await Future.delayed(Duration(milliseconds: time), () {});
}
String convertToMinuteFormat(String timeString) {
  List<String> parts = timeString.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  // Convert full time to minutes
  double totalMinutes = hours * 60 + minutes + (seconds / 60);

  return totalMinutes.toStringAsFixed(1)+" min";
}

Future<void> sendWhatsAppMessage(String whatsappLink) async {
  final uri = Uri.parse(whatsappLink);

  try {
    bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      Get.snackbar(
        "error".tr,
        "whatsapp_not_installed".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      "error".tr,
      "failed_to_open_whatsapp".tr,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    print("WhatsApp error: $e");
  }
}

