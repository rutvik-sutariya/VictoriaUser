import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/helper/routes_helper.dart';
import 'package:victoria_user/services/constants.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/shimmer_widget.dart';
import 'package:victoria_user/view/payment_page/upi_payment_screen.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

import '../components/summery_item_widget.dart';
import 'due_amount_tab.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  String selectedMonth = "";
  String selectedType = "due_amount".tr;
  String selectedPayment = "upi".tr;
  String? selectedPerson;
  File? uploadedImage;
  bool isImageUploaded = false;
  bool isUploading = false;
  bool _paymentConfirmed = false;
  final ApiController _controller = Get.put(ApiController());

  // Add TabController
  late TabController _tabController;

  final String _whatsappNumber = "7656316516";

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
      return monthNumber <= currentMonth;
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    // Initialize TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);

    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeData() {
    final now = DateTime.now();
    final currentMonthNumber = now.month.toString();

    setState(() {
      selectedMonth = currentMonthNumber;
    });

    _loadPaymentSummary(month: currentMonthNumber, year: now.year.toString());
    _controller.employee(context);
  }

  void _loadPaymentSummary({required String month, required String year}) {
    final body = {
      "userId": Constant.userId.value,
      "month": month,
      "year": year,
    };
    print("Loading payment summary for: $body");
    _controller.paymentSummery(context,body);
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

  void _submitPayment() {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    if (selectedPayment == "upi".tr) {
      if (!_paymentConfirmed) {
        Get.to(
          UpiPaymentScreen(
            amount: amount.toString(),
            month: selectedMonth.toString(),
            year: DateTime.now().year.toString(),
          ),
        );
        return;
      }
      _showUpiConfirmationDialog();
      return;
    }

    if (selectedPayment == "cash_on_delivery".tr) {
      if (selectedPerson == null) {
        Get.snackbar(
          "error".tr,
          "please_select_person".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      _showCashConfirmationDialog();
      return;
    }
  }

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
                Text(
                  "confirm_upi_payment".tr,
                  style: AppTextStyle.medium20.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "payment_status".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          _paymentConfirmed ? Icons.check_circle : Icons.error,
                          size: 16,
                          color: _paymentConfirmed
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _paymentConfirmed ? "confirmed".tr : "pending".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: _paymentConfirmed
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "whatsapp_message".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.whatshot, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          "will_be_sent".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
                Text(
                  "confirm_cash_payment".tr,
                  style: AppTextStyle.medium20.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "whatsapp_message".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.whatshot, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          "will_be_sent".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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

/*  Future<void> _processUpiPayment() async {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    final body = {
      "userId": Constant.userId.value,
      "month": selectedMonth,
      "year": DateTime.now().year,
      "totalAmount": amount,
    };
    print("body :: $body");

    _controller.processUpiPayment(
      context,body,
    );

    setState(() {
      _paymentConfirmed = false;
    });
  }*/

  Future<void> _processUpiPayment() async {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    // Month को array में convert करें
    List<int> monthArray = [];
    if (selectedMonth.isNotEmpty) {
      try {
        // अगर selectedMonth comma-separated string है (जैसे "11,12")
        if (selectedMonth.contains(',')) {
          monthArray = selectedMonth.split(',').map((m) => int.parse(m.trim())).toList();
        } else {
          // अगर single month है
          monthArray = [int.parse(selectedMonth)];
        }
      } catch (e) {
        monthArray = [];
      }
    }

    final body = {
      "userId": Constant.userId.value,
      "month": monthArray, // Array के रूप में भेजें
      "year": DateTime.now().year,
      "totalAmount": amount,
    };
    print("body :: $body");

    _controller.processUpiPayment(
      context, body,
    );

    setState(() {
      _paymentConfirmed = false;
    });
  }

  void _processCashPayment() async {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    // Month को array में convert करें
    List<int> monthArray = [];
    if (selectedMonth.isNotEmpty) {
      try {
        // अगर selectedMonth comma-separated string है (जैसे "11,12")
        if (selectedMonth.contains(',')) {
          monthArray = selectedMonth.split(',').map((m) => int.parse(m.trim())).toList();
        } else {
          // अगर single month है
          monthArray = [int.parse(selectedMonth)];
        }
      } catch (e) {
        monthArray = [];
      }
    }

    final body = {
      "userId": Constant.userId.value,
      "month": monthArray, // Array के रूप में भेजें
      "year": DateTime.now().year,
      "totalAmount": amount,
      "recieverName": selectedPerson,
    };

    print("body :: $body");
    _controller.processCashPayment(
      context, body,
    );

    setState(() {
      selectedPerson = null;
    });
  }

/*  void _processCashPayment() async {
    final paymentData = _controller.paymentDetails.value.data;
    final amount = paymentData?.totalAmount ?? "0";

    final body = {
      "userId": Constant.userId.value,
      "month": selectedMonth,
      "year": DateTime.now().year,
      "totalAmount": amount,
      "recieverName": selectedPerson,
    };

    print("body :: $body");
    _controller.processCashPayment(
     context, body,
    );

    setState(() {
      selectedPerson = null;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.appBgColor,
          body: SafeArea(
            child: Column(
              children: [
                // ✅ Header Section
                _buildHeaderSection(),
                const SizedBox(height: 8),

                // ✅ TabBar Section
                _buildTabBarSection(),

                // ✅ TabBarView Section
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // First Tab: Payment Summary
                      _buildPaymentSummaryTab(),

                      // Second Tab: Due Amount Details
                      DueAmountTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.appPrimaryDarkColor,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        dividerColor: Colors.transparent,
        unselectedLabelColor: Colors.grey.shade700,
        labelStyle: AppTextStyle.small14.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyle.small14.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: "payment_summary".tr),
          Tab(text: "due_amount".tr),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16,right: 16,top: 8),
      child: Column(
        children: [
          // ✅ Filter Section
          _buildFilterSection(),
          const SizedBox(height: 8),

          // ✅ Summary Card
          _buildSummaryCard(),
          const SizedBox(height: 24),

          // ✅ Show different UI based on payment status
          _buildPaymentStatusSection(),
        ],
      ),
    );
  }











  // Your existing methods continue here...
  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),

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
              Expanded(child: _buildMonthStatusIndicator(),),
            ],
          ),


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
    return Column(
      children: [
        Text(
          "",
          style: AppTextStyle.small12.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
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
                maxLines: 1,
                style: AppTextStyle.small12.copyWith(
                  color: _getMonthStatusColor(selectedMonth),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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
        return ShimmerWidget();
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
            SummaryItemWidget(
              icon: Icons.local_drink_outlined,
              title: "milk_quantity".tr,
              value: "${paymentData.milkQuantity ?? "0"} ${"liters".tr}",
            ),
            _buildDivider(),
            SummaryItemWidget(
              icon: Icons.calendar_today_outlined,
              title: "delivery_days".tr,
              value: "${paymentData.deliveryDays ?? "0"} ${"days".tr}",
            ),
            _buildDivider(),
            SummaryItemWidget(
              icon: Icons.add_circle_outline,
              title: "extra_milk".tr,
              value: "${paymentData.extraMilk ?? "0"} ${"liters".tr}",
            ),
            _buildDivider(),
            SummaryItemWidget(
              icon: Icons.inventory_2_outlined,
              title: "total_liters".tr,
              value: "${paymentData.totalLitre ?? "0"} ${"liters".tr}",
            ),
            _buildDivider(),
            SummaryItemWidget(
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
            if (selectedPayment == "upi".tr) {
              selectedPerson = null;
              _paymentConfirmed = false;
            } else {
              _paymentConfirmed = false;
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

  Widget _buildUpiPaymentConfirmation() {
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
            "payment_confirmation".tr,
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _paymentConfirmed
                    ? AppColors.appPrimaryDarkColor
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: RadioListTile<bool>(
              value: true,
              groupValue: _paymentConfirmed,
              onChanged: (value) {
                setState(() {
                  _paymentConfirmed = value ?? false;
                });
              },
              activeColor: AppColors.appPrimaryDarkColor,
              title: Text(
                "payment_done".tr,
                style: AppTextStyle.small14.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_paymentConfirmed) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "cash_payment_whatsapp_info".tr,
                      style: AppTextStyle.small12.copyWith(
                        color: Colors.blue.shade700,
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
          text: _paymentConfirmed && selectedPayment == "upi".tr
              ? "submit_payment".tr
              : "pay_now".tr,
          onPressed: _submitPayment,
        ),
      ],
    );
  }

  // NEW: Build different UI sections based on payment status
  Widget _buildPaymentStatusSection() {
    final paymentStatus = _controller.paymentDetails.value.data?.paymentStatus;

    switch (paymentStatus) {
      case "created":
        return _buildPaymentFormSection();
      case "pending":
        return _buildPendingStatusSection();
      case "approved":
        return _buildApprovedStatusSection();
      case "rejected":
        return _buildRejectedStatusSection();
      case "current":
        return _buildCurrentStatusSection();
      default:
        return _buildPaymentFormSection();
    }
  }

  // NEW: Payment Form Section (for "created" status)
  Widget _buildPaymentFormSection() {
    return Column(
      children: [
        _buildPaymentMethodSection(),
        const SizedBox(height: 16),

        // ✅ UPI Payment Confirmation Section
        if (selectedPayment == "upi".tr)
          _buildUpiPaymentConfirmation(),

        // ✅ Cash Person Selection Section
        if (selectedPayment == "cash_on_delivery".tr)
          _buildCashPersonSelection(),

        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  // NEW: Pending Status Section
  Widget _buildPendingStatusSection() {
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
          // Status Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pending_actions_rounded,
              size: 40,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Status Title
          Text(
            "payment_pending".tr,
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 8),

          // Status Message
          Text(
            "payment_under_review".tr,
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Additional Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "admin_approval_pending".tr,
                    style: AppTextStyle.small12.copyWith(
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Approved Status Section
  Widget _buildApprovedStatusSection() {
    final paymentData = _controller.paymentDetails.value.data;

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
          // Success Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 40,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Success Title
          Text(
            "payment_approved".tr,
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),

          // Success Message
          Text(
            "payment_successfully_approved".tr,
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Payment Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.appBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPaymentDetailRow(
                  "amount_paid".tr,
                  "₹ ${paymentData?.totalAmount ?? "0"}",
                ),
                const SizedBox(height: 8),
                _buildPaymentDetailRow(
                  "month".tr,
                  "${_getMonthNameFromNumber(selectedMonth).tr} ${DateTime.now().year}",
                ),
                const SizedBox(height: 8),
                _buildPaymentDetailRow(
                  "payment_date".tr,
                  _getFormattedDate(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Rejected Status Section
  Widget _buildRejectedStatusSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
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
              // Rejected Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_rounded,
                  size: 40,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),

              // Rejected Title
              Text(
                "payment_rejected".tr,
                style: AppTextStyle.medium18.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),

              // Rejected Message
              Text(
                "payment_rejected_by_admin".tr,
                style: AppTextStyle.small14.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Contact Support
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.supportPage);
                },
                child: Text(
                  "contact_support".tr,
                  style: AppTextStyle.small14.copyWith(
                    color: AppColors.appPrimaryDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildPaymentFormSection()
      ],
    );
  }

  // NEW: Current Status Section
  Widget _buildCurrentStatusSection() {
    return Container(

    );
  }

  // NEW: Helper method for payment detail rows
  Widget _buildPaymentDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.small14.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.small14.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
      ],
    );
  }

  // NEW: Helper method to get formatted date
  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }
}
