import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/helper/routes_helper.dart';
import 'package:victoria_user/services/constants.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/payment_page/upi_payment_screen.dart';
import 'package:victoria_user/view/payment_page/upi_success_sceen.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMonth = "";
  String selectedType = "due_amount".tr;
  String selectedPayment = "upi".tr;
  String? selectedPerson;
  File? uploadedImage;
  bool isImageUploaded = false;
  bool isUploading = false;
  final ApiController _controller = Get.put(ApiController());
  final ImagePicker _imagePicker = ImagePicker();
  bool _showFilters = false;

  // Month mapping for API (1-12) and display
  final List<Map<String, String>> months = [
    {"number": "1", "name": "january"},
    {"number": "2", "name": "february"},
    {"number": "3", "name": "march"},
    {"number": "4", "name": "april"},
    {"number": "5", "name": "may"},
    {"number": "6", "name": "june"},
    {"number": "7", "name": "july"},
    {"number": "8", "name": "august"},
    {"number": "9", "name": "september"},
    {"number": "10", "name": "october"},
    {"number": "11", "name": "november"},
    {"number": "12", "name": "december"},
  ];

  List<Map<String, String>> get availableMonths {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return months.where((month) {
      final monthNumber = int.parse(month["number"]!);
      // Include only past months and current month
      return monthNumber <= currentMonth;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final now = DateTime.now();
    final currentMonthNumber = now.month.toString();

    setState(() {
      selectedMonth = currentMonthNumber;
    });

    _loadPaymentSummary(month: currentMonthNumber, year: now.year.toString());
    _controller.employee();
  }

  void _loadPaymentSummary({required String month, required String year}) {
    final body = {
      "userId": Constant.userId.value,
      "month": month,
      "year": year,
    };
    print("Loading payment summary for: $body");
    _controller.paymentSummery(body);
  }

  String _getMonthNameFromNumber(String monthNumber) {
    return months.firstWhere(
      (month) => month["number"] == monthNumber,
      orElse: () => months[0],
    )["name"]!;
  }

  String _getMonthStatus(String monthNumber) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final selectedMonthNum = int.parse(monthNumber);

    if (selectedMonthNum == currentMonth) {
      return "current";
    } else if (selectedMonthNum < currentMonth) {
      return "past";
    } else {
      return "future";
    }
  }

  Color _getMonthStatusColor(String monthNumber) {
    final status = _getMonthStatus(monthNumber);
    switch (status) {
      case "current":
        return Colors.blue;
      case "past":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getMonthStatusText(String monthNumber) {
    final status = _getMonthStatus(monthNumber);
    switch (status) {
      case "current":
        return "current_month".tr;
      case "past":
        return "past_month".tr;
      default:
        return "future_month".tr;
    }
  }

  // Request gallery permission
  Future<bool> _requestGalleryPermission() async {
    PermissionStatus status;

    if (GetPlatform.isAndroid) {
      status = await Permission.storage.request(); // Android uses storage permission
    } else {
      status = await Permission.photos.request(); // iOS uses photos permission
    }

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      Get.snackbar(
        "permission_required".tr,
        "gallery_permission_required".tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }


  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final hasPermission = await _requestGalleryPermission();
      if (!hasPermission) return;

      setState(() {
        isUploading = true;
      });

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          uploadedImage = File(pickedFile.path);
          isImageUploaded = true;
          isUploading = false;
        });

        Get.snackbar(
          "success".tr,
          "image_uploaded_successfully".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        setState(() {
          isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      Get.snackbar(
        "error".tr,
        "failed_to_pick_image".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Image picker error: $e");
    }
  }

  // Remove uploaded image
  void _removeImage() {
    setState(() {
      isImageUploaded = false;
      uploadedImage = null;
    });
  }

  // Show image picker options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "choose_option".tr,
                  style: AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryDarkColor,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.appPrimaryDarkColor,
                ),
                title: Text("choose_from_gallery".tr),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: AppColors.appPrimaryDarkColor,
                ),
                title: Text("take_photo".tr),
                onTap: () {
                  Navigator.pop(context);
                  _takePhotoWithCamera();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text("cancel".tr, style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Take photo with camera
  Future<void> _takePhotoWithCamera() async {
    try {
      final hasPermission = await Permission.camera.request();
      if (!hasPermission.isGranted) {
        Get.snackbar(
          "permission_required".tr,
          "camera_permission_required".tr,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      setState(() {
        isUploading = true;
      });

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          uploadedImage = File(pickedFile.path);
          isImageUploaded = true;
          isUploading = false;
        });

        Get.snackbar(
          "success".tr,
          "image_uploaded_successfully".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        setState(() {
          isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      Get.snackbar(
        "error".tr,
        "failed_to_take_photo".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Camera error: $e");
    }
  }

  // Submit payment
  void _submitPayment() {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    if (selectedPayment == "upi".tr) {
      // Case 1: UPI selected but no image
      if (!isImageUploaded) {
        // print("hello");
        Get.to(
          UpiPaymentScreen(
            amount: amount.toString(),
            month: selectedMonth.toString(),
            year: DateTime.now().year.toString(),
          ),
        );
        return;
      }
      // Case 2: UPI selected and image uploaded
      _showUpiConfirmationDialog();
      return;
    }

    // Case 3: Cash on delivery selected
    if (selectedPayment == "cash_on_delivery".tr) {
      _showCashConfirmationDialog();
      return;
    }
  }

  // Show UPI Confirmation Dialog
  void _showUpiConfirmationDialog() {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.appPrimaryDarkColor.withOpacity(0.9),
                AppColors.appPrimaryDarkColor,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "confirm_upi_payment".tr,
                  style: AppTextStyle.medium20.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Amount Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "total_amount".tr,
                        style: AppTextStyle.small14.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ $amount",
                        style: AppTextStyle.medium24.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Month Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "month".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      "${_getMonthNameFromNumber(selectedMonth).tr} ${DateTime.now().year}",
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Payment Method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "payment_method".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "upi".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Screenshot Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "screenshot".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isImageUploaded ? Icons.check_circle : Icons.error,
                          size: 16,
                          color: isImageUploaded ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isImageUploaded ? "uploaded".tr : "pending".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: isImageUploaded
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "cancel".tr,
                            style: AppTextStyle.small16.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.green.shade700],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed:
                              _controller.isImageUploadLoading.value ||
                                  _controller.isUpiPaymentLoading.value
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  _processUpiPayment();
                                },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Center(
                            child:
                                _controller.isImageUploadLoading.value ||
                                    _controller.isUpiPaymentLoading.value
                                ? Row(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    "confirm_pay".tr,
                                    style: AppTextStyle.small16.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show Cash Confirmation Dialog
  void _showCashConfirmationDialog() {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.appPrimaryDarkColor.withOpacity(0.9),
                AppColors.appPrimaryDarkColor,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cash Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_atm_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "confirm_cash_payment".tr,
                  style: AppTextStyle.medium20.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Amount Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "payable_amount".tr,
                        style: AppTextStyle.small14.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ $amount",
                        style: AppTextStyle.medium24.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Month Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "month".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      "${_getMonthNameFromNumber(selectedMonth).tr} ${DateTime.now().year}",
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Payment Method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "payment_method".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.local_atm_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "cash".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Recipient
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "paying_to".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      selectedPerson ?? "",
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "cancel".tr,
                            style: AppTextStyle.small16.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.green.shade700],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _processCashPayment();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "confirm_pay".tr,
                            style: AppTextStyle.small16.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processUpiPayment() async {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";
    print("Processing UPI payment with image: ${uploadedImage?.path}");

    // TODO: Call your UPI payment API
    // Example: _controller.processUpiPayment(amount, month, imageFile);
    await _controller.uploadImage(File(uploadedImage!.path)).then((onValue) {
      final body = {
        "userId": Constant.userId.value,
        "month": selectedMonth,
        "year": DateTime.now().year,
        "totalAmount": amount,
        "image":_controller.imageUrl.value,
      };
      print("body :: $body");
      _controller.processUpiPayment(body);
    });

    // Reset after successful submission
    setState(() {
      isImageUploaded = false;
      uploadedImage = null;
    });
  }

  void _processCashPayment() {
    print("Processing cash payment to: $selectedPerson");
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";
    // TODO: Call your cash payment API
    final body = {
      "userId": Constant.userId.value,
      "month": selectedMonth,
      "year": DateTime.now().year,
      "totalAmount": amount,
      "recieverName": selectedPerson,
    };
    _controller.processCashPayment(body);

    print("body :: $body");

    // Reset after successful submission
    setState(() {
      selectedPerson = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Header Section
                _buildHeaderSection(),
                const SizedBox(height: 24),

                // ✅ Filter Section
                _buildFilterSection(),
                const SizedBox(height: 20),

                // ✅ Summary Card
                _buildSummaryCard(),
                const SizedBox(height: 24),

                // ✅ Show Payment Method & Actions only if NOT current or paid
                if (_controller.paymentDetails.value.data?.paymentStatus !=
                        "current" &&
                    _controller.paymentDetails.value.data?.paymentStatus !=
                        "paid") ...[
                  _buildPaymentMethodSection(),
                  const SizedBox(height: 16),

                  // ✅ UPI Image Upload Section
                  if (selectedPayment == "upi".tr) _buildUpiImageUpload(),

                  // ✅ Cash Person Selection Section
                  if (selectedPayment == "cash_on_delivery".tr)
                    _buildCashPersonSelection(),

                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ... (Keep all the existing widget methods exactly as they are: _buildHeaderSection, _buildFilterSection, _buildSummaryCard, etc.)
  // These methods remain unchanged from your original code

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.appPrimaryDarkColor.withOpacity(0.8),
            AppColors.appPrimaryDarkColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhiteColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.payment_rounded,
              color: AppColors.appWhiteColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "milk_payment".tr,
                  style: AppTextStyle.medium20.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhiteColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "monthly_summary".tr,
                  style: AppTextStyle.small14.copyWith(
                    color: AppColors.appWhiteColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Current Month & Year Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.appWhiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.appWhiteColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  _getMonthNameFromNumber(selectedMonth).tr,
                  style: AppTextStyle.small12.copyWith(
                    color: AppColors.appWhiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${DateTime.now().year}",
                  style: AppTextStyle.small12.copyWith(
                    color: AppColors.appWhiteColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMonthDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildTypeDropdown()),
            ],
          ),
          const SizedBox(height: 12),
          // Month Status Indicator
          _buildMonthStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_month".tr,
          style: AppTextStyle.small12.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.appPrimaryDarkColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedMonth,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
            ),
            dropdownColor: AppColors.appPrimaryDarkColor,
            style: AppTextStyle.small14.copyWith(color: Colors.white),
            items: availableMonths.map((month) {
              final monthNumber = month["number"]!;
              final monthName = month["name"]!;
              final isCurrentMonth = _getMonthStatus(monthNumber) == "current";

              return DropdownMenuItem<String>(
                value: monthNumber,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        monthName.tr,
                        style: AppTextStyle.small14.copyWith(
                          color: Colors.white,
                          fontWeight: isCurrentMonth
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isCurrentMonth)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "current".tr,
                          style: AppTextStyle.small12.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedMonth = value;
                });
                _loadPaymentSummary(
                  month: value,
                  year: DateTime.now().year.toString(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthStatusIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getMonthStatusColor(selectedMonth).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getMonthStatusColor(selectedMonth).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getMonthStatus(selectedMonth) == "current"
                ? Icons.circle_rounded
                : _getMonthStatus(selectedMonth) == "past"
                ? Icons.check_circle_rounded
                : Icons.schedule_rounded,
            color: _getMonthStatusColor(selectedMonth),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            _getMonthStatusText(selectedMonth),
            style: AppTextStyle.small12.copyWith(
              color: _getMonthStatusColor(selectedMonth),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_type".tr,
          style: AppTextStyle.small12.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.appPrimaryDarkColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedType,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
            ),
            dropdownColor: AppColors.appPrimaryDarkColor,
            style: AppTextStyle.small14.copyWith(color: Colors.white),
            items: [
              DropdownMenuItem(
                value: "due_amount".tr,
                child: Text(
                  "due_amount".tr,
                  style: AppTextStyle.small14.copyWith(color: Colors.white),
                ),
              ),
              DropdownMenuItem(
                value: "paid".tr,
                child: Text(
                  "paid".tr,
                  style: AppTextStyle.small14.copyWith(color: Colors.white),
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedType = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      final paymentData = _controller.paymentDetails.value.data;
      final isLoading =
          _controller.isSummeryLoading.value ||
          _controller.isEmployeeLoading.value;

      if (isLoading) {
        return _buildLoadingShimmer();
      }

      if (paymentData == null) {
        return _buildEmptyState();
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Month Header with Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_getMonthNameFromNumber(selectedMonth).tr} ${DateTime.now().year}",
                    style: AppTextStyle.small16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getMonthStatusColor(
                        selectedMonth,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getMonthStatusText(selectedMonth),
                      style: AppTextStyle.small12.copyWith(
                        color: _getMonthStatusColor(selectedMonth),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Summary Items
            _buildSummaryItem(
              icon: Icons.local_drink_outlined,
              title: "milk_quantity".tr,
              value: "${paymentData.milkQuantity ?? "0"} ${"liters".tr}",
            ),
            _buildDivider(),
            _buildSummaryItem(
              icon: Icons.calendar_today_outlined,
              title: "delivery_days".tr,
              value: "${paymentData.deliveryDays ?? "0"} ${"days".tr}",
            ),
            _buildDivider(),
            _buildSummaryItem(
              icon: Icons.add_circle_outline,
              title: "extra_milk".tr,
              value: "${paymentData.extraMilk ?? "0"} ${"liters".tr}",
            ),
            _buildDivider(),
            _buildSummaryItem(
              icon: Icons.inventory_2_outlined,
              title: "total_liters".tr,
              value: "${paymentData.totalLitre ?? "0"} ${"liters".tr}",
            ),
            _buildDivider(),
            _buildSummaryItem(
              icon: Icons.attach_money_outlined,
              title: "total_amount".tr,
              value: "₹ ${paymentData.totalAmount ?? "0"}",
              isTotal: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.appPrimaryDarkColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.small16.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.appPrimaryDarkColor,
                  )
                : AppTextStyle.small16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            5,
            (index) => Column(
              children: [
                Container(
                  height: 20,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                if (index < 4) _buildDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "no_payment_data".tr,
            style: AppTextStyle.medium18.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "no_data_for_selected_month".tr,
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "select_payment_method".tr,
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodTile(
            value: "upi".tr,
            title: "upi".tr,
            subtitle: "instant_upi_payment".tr,
            icon: Icons.phone_android_rounded,
            color: AppColors.appPrimaryDarkColor,
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodTile(
            value: "cash_on_delivery".tr,
            title: "cash_on_delivery".tr,
            subtitle: "pay_when_delivered".tr,
            icon: Icons.local_atm_rounded,
            color: AppColors.appPrimaryDarkColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedPayment == value ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedPayment,
        onChanged: (value) {
          setState(() {
            selectedPayment = value!;
            // Reset selections when changing payment method
            if (selectedPayment == "upi".tr) {
              selectedPerson = null;
            } else {
              isImageUploaded = false;
              uploadedImage = null;
            }
          });
        },
        activeColor: color,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.small16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.small12.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiImageUpload() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "upload_upi_screenshot".tr,
                style: AppTextStyle.small16.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _showFilters
                          ? AppColors.appPrimaryDarkColor
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _showFilters ? 'Hide' : 'Show',
                        style: AppTextStyle.small12.copyWith(
                          fontWeight: _showFilters
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _showFilters
                              ? AppColors.appPrimaryDarkColor
                              : AppColors.appBlackColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showFilters ? Icons.expand_less : Icons.expand_more,
                        color: _showFilters
                            ? AppColors.appPrimaryDarkColor
                            : AppColors.appBlackColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showFilters) ...[
            const SizedBox(height: 12),
            Text(
              "upload_upi_payment_screenshot".tr,
              style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            if (isUploading)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.appBgColor,
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.appPrimaryDarkColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "uploading_image".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else if (!isImageUploaded)
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.appBgColor,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "tap_to_upload_screenshot".tr,
                        style: AppTextStyle.small14.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "tap_to_select_from_gallery".tr,
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.shade50,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(uploadedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "screenshot_uploaded".tr,
                                style: AppTextStyle.small14.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              Text(
                                "image_ready_for_submission".tr,
                                style: AppTextStyle.small12.copyWith(
                                  color: Colors.green.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "tap_to_view".tr,
                                style: AppTextStyle.small16.copyWith(
                                  color: Colors.green.shade500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: _removeImage,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // Show image in full screen
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.file(
                                    uploadedImage!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16,
                              color: AppColors.appPrimaryDarkColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "view_image".tr,
                              style: AppTextStyle.small12.copyWith(
                                color: AppColors.appPrimaryDarkColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildCashPersonSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "select_person".tr,
            style: AppTextStyle.small16.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "select_who_received_payment".tr,
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.appPrimaryDarkColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: selectedPerson,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: Colors.white,
              ),
              dropdownColor: AppColors.appPrimaryDarkColor,
              style: AppTextStyle.small14.copyWith(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              hint: Text(
                "select_person".tr,
                style: AppTextStyle.small14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              items: _controller.employeeList.map((person) {
                return DropdownMenuItem<String>(
                  value: person,
                  child: Text(
                    person,
                    style: AppTextStyle.small14.copyWith(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPerson = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          text: isImageUploaded && selectedPayment == "upi".tr
              ? "submit_payment".tr
              : "pay_now".tr,
          onPressed: _submitPayment,
        ),
      ],
    );
  }
}

