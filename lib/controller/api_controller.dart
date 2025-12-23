import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:victoria_user/global_variable.dart';
import 'package:victoria_user/model/notification_model.dart';
import 'package:victoria_user/model/payment_summary_model.dart';
import 'package:victoria_user/widget/app_snackbar.dart';
import '../helper/routes_helper.dart';
import '../main.dart';
import '../model/contact_model.dart';
import '../model/milk_history_model.dart';
import '../model/month_summery_model.dart';
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
  final RxBool isMonthSummeryLoading = false.obs;
  final RxBool isContactLoading = false.obs;

  final RxString imageUrl = "".obs;

  final RxList<String> employeeList = <String>[].obs;
  final Rx<UserModel> userDetails = UserModel().obs;
  final Rx<MilkHistoryModel> milkHistoryDetails = MilkHistoryModel().obs;
  final Rx<PaymentSummaryModel> paymentDetails = PaymentSummaryModel().obs;
  final Rx<NotificationModel> notificationDetails = NotificationModel().obs;
  final Rx<MonthSummeryModel> monthDetails = MonthSummeryModel().obs;
  final Rx<ContactModel> contactDetails = ContactModel().obs;


  // Login Api
  Future<void> login(BuildContext context, body) async {
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

        AppSnackbar.success(context, "Login Successful");

        Get.offAllNamed(Routes.dashboardPage);
      } else {
        AppSnackbar.error(context, jsonData["message"] ?? "Login failed");
      }
    } catch (e) {
      AppSnackbar.error(context, "Error");
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Get User
  Future<void> getUser(BuildContext context) async {
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
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Unable to fetch user",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, "Error");
    } finally {
      isUserLoading.value = false;
    }
  }

  // Milk History
  Future<void> getMilkHistory(BuildContext context, body) async {
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
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Unable to fetch milk history",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, "Error");
    } finally {
      isMilkHisLoading.value = false;
    }
  }

  // Cancel Order
  Future<void> cancelOrder(BuildContext context, body) async {
    isCancelLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.cancelOrder,
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppSnackbar.success(context, "cash_payment_recorded".tr);
      } else {
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "failed_cash_payment".tr,
        );
      }
    } catch (e) {
      AppSnackbar.error(context, "Error");
    } finally {
      isCancelLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> extraMilk(BuildContext context, body) async {
    isExtraMilkLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: "${Config.extraOrder}${Constant.userId.value}/extra",
        headers: true,
        body: body,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppSnackbar.success(context, "Extra milk added successfully");
      } else {
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Failed to add extra milk",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, e.toString());
    } finally {
      isExtraMilkLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> reducedMilk(BuildContext context, body) async {
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
        AppSnackbar.success(context, "Reduced milk added successfully");
      } else {
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Failed to add reduced milk",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, e.toString());
    } finally {
      isReducedMilkLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> paymentSummery(BuildContext context, body) async {
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
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Failed to add extra milk",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, e.toString());
    } finally {
      isSummeryLoading.value = false;
    }
  }

  // Extra Milk
  Future<void> monthSummery(BuildContext context) async {
    isMonthSummeryLoading.value = true;
    try {
      final response = await ApiManager.instance.post(
        endpoint: Config.monthSummery,
        headers: true,
        body: {"userId": Constant.userId.value},
      );
      final jsonData = jsonDecode(response.body);
      print("Month Summery :: ${response.body}");
      if (response.statusCode == 200) {
        monthDetails(monthSummeryModelFromJson(response.body));
      } else {
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Failed to add extra milk",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, e.toString());
    } finally {
      isMonthSummeryLoading.value = false;
    }
  }

  // Employee
  Future<void> employee(BuildContext context) async {
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
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "Failed to fetch employees",
        );
      }
    } catch (e) {
      AppSnackbar.error(context, e.toString());
    } finally {
      isEmployeeLoading.value = false;
    }
  }

  // Notification
  Future<void> notification(BuildContext context) async {
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
        AppSnackbar.error(context, jsonData["message"] ?? "Unable to order");
      }
    } catch (e) {
      AppSnackbar.error(context, e.toString());
    } finally {
      isNotificationLoading.value = false;
    }
  }

  // Contact Us
  Future<void> contactUs() async {
    isContactLoading.value = true;
    try {
      final response = await ApiManager.instance.get(
        endpoint: Config.contactUs,
        headers: false,
      );
      final jsonData = jsonDecode(response.body);
      print("Contact Us :: ${response.body}");
      if (response.statusCode == 200) {
        contactDetails(contactModelFromJson(response.body));
      } else {
        if (Get.context != null && Get.context!.mounted) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text(jsonData["message"] ?? "Unable to contact us"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          Get.snackbar(
            "Failed",
            jsonData["message"] ?? "Unable to contact us",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isContactLoading.value = false;
    }
  }

  // Milk History
  Future<void> milkPdfExport(BuildContext context, body) async {
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
      AppSnackbar.error(context, e.toString());
    } finally {
      isExportLoading.value = false;
    }
  }

  // Cash Payment
  Future<void> processCashPayment(BuildContext context, body) async {
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
        AppSnackbar.success(context, "cash_payment_recorded".tr);
        final whatsappLink = jsonData["whatsappLink"];

        if (whatsappLink != null && whatsappLink.toString().isNotEmpty) {
          sendWhatsAppMessage(whatsappLink);
        } else {
          AppSnackbar.error(context, "whatsapp_link_not_found".tr);
        }
      } else {
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "cash_payment_failed".tr,
        );
      }
    } catch (e) {
      AppSnackbar.error(context, "something_went_wrong".tr);
    } finally {
      isCashPaymentLoading.value = false;
    }
  }

  // UPI Payment
  Future<void> processUpiPayment(BuildContext context, body) async {
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
          AppSnackbar.error(context, "whatsapp_link_not_found".tr);
        }

        AppSnackbar.success(context, "upi_payment_submitted".tr);
      } else {
        AppSnackbar.error(
          context,
          jsonData["message"] ?? "upi_payment_failed".tr,
        );
      }
    } catch (e) {
      AppSnackbar.error(context, "something_went_wrong".tr);
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
