import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:victoria_user/global_variable.dart';
import 'package:victoria_user/model/notification_model.dart';
import 'package:victoria_user/model/payment_summary_model.dart';
import '../helper/routes_helper.dart';
import '../main.dart';
import '../model/milk_history_model.dart';
import '../model/user_model.dart';
import '../services/api_service/api_manager.dart';
import '../services/api_service/config.dart';
import '../services/constants.dart';
import '../services/local_storage/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ApiController extends GetxController {
  final RxBool isLoginLoading = false.obs;
  final RxBool isUserLoading = false.obs;
  final RxBool isMilkHisLoading = false.obs;
  final RxBool isExtraMilkLoading = false.obs;
  final RxBool isSummeryLoading = false.obs;
  final RxBool isCancelLoading = false.obs;
  final RxBool isEmployeeLoading = false.obs;
  final RxBool isCashPaymentLoading = false.obs;
  final RxBool isUpiPaymentLoading = false.obs;
  final RxBool isImageUploadLoading = false.obs;
  final RxBool isReducedMilkLoading = false.obs;
  final RxBool isNotificationLoading = false.obs;
  final RxBool isExportLoading = false.obs;
  final RxString imageUrl = "".obs;

  final RxList<String> employeeList = <String>[].obs;
  final Rx<UserModel> userDetails = UserModel().obs;
  final Rx<MilkHistoryModel> milkHistoryDetails = MilkHistoryModel().obs;
  final Rx<PaymentSummaryModel> paymentDetails = PaymentSummaryModel().obs;
  final Rx<NotificationModel> notificationDetails = NotificationModel().obs;

  // Login Api
  Future<void> login(body) async {
    isLoginLoading.value = true;

    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.login,
        headers: false,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Constant.userId.value = jsonData["User"]["_id"];
        Constant.token.value = jsonData["token"];
        await prefs.setString(LocalStorage.userId.value, Constant.userId.value);
        await prefs.setString(
          LocalStorage.accessToken.value,
          Constant.token.value,
        );

        Get.snackbar(
          "Success",
          "Login Successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.dashboardPage);
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Login failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Get User
  Future<void> getUser() async {
    isUserLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.getUser + Constant.userId.value,
        headers: false,
        body: {},
      );
      final jsonData = jsonDecode(response.body);
      print("User Details :: $jsonData");
      if (response.statusCode == 200) {
        userDetails(userModelFromJson(response.body));
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Unable to fetch user",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUserLoading.value = false;
    }
  }

  // Milk History
  Future<void> getMilkHistory(body) async {
    isMilkHisLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.milkHistory,
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        milkHistoryDetails(milkHistoryModelFromJson(response.body));
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Unable to fetch milk history",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isMilkHisLoading.value = false;
    }
  }

  // Cancel Order
  Future<void> cancelOrder(body) async {
    isCancelLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.cancelOrder,
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "success".tr,
          "cash_payment_recorded".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "failed".tr,
          jsonData["message"] ?? "failed_cash_payment".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCancelLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> extraMilk(body) async {
    isExtraMilkLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: "${Config.extraOrder}${Constant.userId.value}/extra",
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Extra milk added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Failed to add extra milk",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isExtraMilkLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> reducedMilk(body) async {
    isReducedMilkLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint:
            "${Config.extraOrder}${Constant.userId.value}/lessmilk-request",
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Reduced milk added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Failed to add reduced milk",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isReducedMilkLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> paymentSummery(body) async {
    isSummeryLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.paymentSummery,
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);
      print("Payment Summery :: $jsonData");
      if (response.statusCode == 200) {
        paymentDetails(paymentSummaryModelFromJson(response.body));
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Failed to add extra milk",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSummeryLoading.value = false;
    }
  }

  // Employee
  Future<void> employee() async {
    isEmployeeLoading.value = true;
    try {
      final response = await ApiManager.instance.get(
        endpoint: Config.employee,
        headers: true,
      );

      final jsonData = jsonDecode(response.body);
      print("Employee :: $jsonData");

      if (response.statusCode == 200 && jsonData["success"] == true) {
        // Clear old data
        employeeList.clear();

        // Extract names and add to list
        final List data = jsonData["data"] ?? [];
        for (var element in data) {
          employeeList.add(element["name"] ?? "Unknown");
        }

        print("Employee List: $employeeList");
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Failed to fetch employees",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isEmployeeLoading.value = false;
    }
  }

  // Notification
  Future<void> notification() async {
    isNotificationLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.notification + Constant.userId.value,
        headers: true,
        body: {},
      );
      final jsonData = jsonDecode(response.body);
      print("Notification :: ${response.body}");
      if (response.statusCode == 200) {
        notificationDetails(notificationModelFromJson(response.body));
      } else {
        Get.snackbar(
          "Failed",
          jsonData["message"] ?? "Unable to order",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isNotificationLoading.value = false;
    }
  }

  // Milk History
  Future<void> milkPdfExport(body) async {
    isExportLoading.value = true;
    try {
      final url = Uri.parse(Config.baseUrl + Config.milkExportPdf);
      print("Url :: $url");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/pdf",
        },
        body: jsonEncode(body), // <-- FIX here
      );
      print("Milk Pdf Export :: ${response.body}");
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/Victoria Milk.pdf");

        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(file.path); // open with default PDF viewer
      } else {
        debugPrint("Failed: ${response.statusCode} ${response.reasonPhrase}");
      }

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isExportLoading.value = false;
    }
  }

  // Cash Payment
  Future<void> processCashPayment(body, whatsappNumber, messages) async {
    isCashPaymentLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.cashPayment,
        headers: true,
        body: body,
      );

      final jsonData = jsonDecode(response.body);
      print("Cash Payment :: $jsonData :: ${response.statusCode}");

      if (response.statusCode == 200) {
        Get.snackbar(
          "success".tr,
          "cash_payment_recorded".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        final whatsappLink = jsonData["whatsappLink"];

        if (whatsappLink != null && whatsappLink.toString().isNotEmpty) {
          sendWhatsAppMessage(whatsappLink);
        } else {
          Get.snackbar(
            "error".tr,
            "whatsapp_link_not_found".tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "failed".tr,
          jsonData["message"] ?? "cash_payment_failed".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        "something_went_wrong".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCashPaymentLoading.value = false;
    }
  }

  // UPI Payment
  Future<void> processUpiPayment(body, whatsappNumber, messages) async {
    isUpiPaymentLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.upiPayment,
        headers: true,
        body: body,
      );

      final jsonData = jsonDecode(response.body);
      print("UPI Payment :: $jsonData");

      if (jsonData["success"] == true) {
        final whatsappLink = jsonData["whatsappLink"];

        if (whatsappLink != null && whatsappLink.toString().isNotEmpty) {
          sendWhatsAppMessage(whatsappLink);
        } else {
          Get.snackbar(
            "error".tr,
            "whatsapp_link_not_found".tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

        Get.snackbar(
          "success".tr,
          "upi_payment_submitted".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "failed".tr,
          jsonData["message"] ?? "upi_payment_failed".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        "something_went_wrong".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpiPaymentLoading.value = false;
    }
  }

  /// Upload Image (only image files allowed)
  Future<void> uploadImage(File imageFile) async {
    try {
      isImageUploadLoading.value = true; // Show loader
      // print("image File :: $imageFile");

      var uri = Uri.parse(Config.baseUrl + Config.uploadImage);
      var request = http.MultipartRequest('POST', uri);

      // Attach the file
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Image Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        imageUrl.value = jsonData['filePath'];
        // print("updateImage  :: ${uploadImage.value}");
      } else {
        // print("Upload Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Upload Error: $e");
    } finally {
      isImageUploadLoading.value = false; // Hide loader
    }
  }
}
