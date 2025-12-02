import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/view/components/payment_method_tile.dart';
import 'package:victoria_user/view/components/shimmer_widget.dart';
import 'package:victoria_user/view/payment_page/upi_payment_screen.dart';

import '../../helper/routes_helper.dart';
import '../../model/month_summery_model.dart';
import '../../services/constants.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widget/button/primary_button.dart';
import '../components/summery_item_widget.dart';

class DueAmountTab extends StatefulWidget {
  const DueAmountTab({super.key});

  @override
  State<DueAmountTab> createState() => _DueAmountTabState();
}

class _DueAmountTabState extends State<DueAmountTab> {
  final ApiController _controller = Get.put(ApiController());
  bool _paymentConfirmed = false;
  String? selectedPerson;
  String selectedPayment = "upi".tr;
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

  @override
  void initState() {
    super.initState();
    _controller.monthSummery(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _controller.isMonthSummeryLoading.value
          ? ShimmerWidget()
          : ((_controller.monthDetails.value.pendingMonths?.length ?? 0) <= 0)
          ? _buildEmptyState()
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Due Amount Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade400,
                    Colors.orange.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
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
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "total_due_amount".tr,
                          style: AppTextStyle.medium20.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹ ${_controller.monthDetails.value.summary?.totalAmount?.toString() ?? "0"}",
                          style: AppTextStyle.large28.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "pay_all_pending_months".tr,
                          style: AppTextStyle.small14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "total_amount_includes_all_pending_months".tr,
                          style: AppTextStyle.small12.copyWith(
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Due Amount Details Title
            Text(
              "due_amount_details".tr,
              style: AppTextStyle.medium18.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.appPrimaryDarkColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "pay_pending_amounts".tr,
              style: AppTextStyle.small14.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Due Amount List
            _buildDueAmountList(),
            const SizedBox(height: 20),
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildPaymentStatusSection(),
          ],
        ),
      );
    });
  }

  // Get all pending month numbers
  List<String> _getAllPendingMonthNumbers() {
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];
    List<String> monthNumbers = [];

    for (var month in pendingMonths) {
      // Extract month number from month name (e.g., "September 2025" -> "9")
      final monthName = month.month?.split(' ').first ?? "";
      final monthNumber = _getMonthNumberFromName(monthName);
      if (monthNumber.isNotEmpty) {
        monthNumbers.add(monthNumber);
      }
    }

    return monthNumbers;
  }

  // Get month number from month name
  String _getMonthNumberFromName(String monthName) {
    final monthMap = {
      'January': '1',
      'February': '2',
      'March': '3',
      'April': '4',
      'May': '5',
      'June': '6',
      'July': '7',
      'August': '8',
      'September': '9',
      'October': '10',
      'November': '11',
      'December': '12',
    };
    return monthMap[monthName] ?? '';
  }

  // Get total amount from summary
  int _getTotalAmount() {
    return _controller.monthDetails.value.summary?.totalAmount ?? 0;
  }

  // Build different UI sections based on payment status
  Widget _buildPaymentStatusSection() {
    final paymentStatus = _controller.monthDetails.value.summary?.paymentStatus;

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

  // Pending Status Section
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
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
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

  // Approved Status Section
  Widget _buildApprovedStatusSection() {
    final totalAmount = _getTotalAmount();
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];
    final pendingMonthsCount = pendingMonths.length;

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
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
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
                  "₹ $totalAmount",
                ),
                const SizedBox(height: 8),
                _buildPaymentDetailRow(
                  "pending_months_cleared".tr,
                  "$pendingMonthsCount ${"months".tr}",
                ),
                const SizedBox(height: 8),
                _buildPaymentDetailRow(
                  "year".tr,
                  DateTime.now().year.toString(),
                ),
                const SizedBox(height: 8),
                _buildPaymentDetailRow("payment_date".tr, _getFormattedDate()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Rejected Status Section
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
        _buildPaymentFormSection(),
      ],
    );
  }

  // Current Status Section
  Widget _buildCurrentStatusSection() {
    return Container();
  }

  // Helper method for payment detail rows
  Widget _buildPaymentDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
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

  // Payment Form Section (for "created" status)
  Widget _buildPaymentFormSection() {
    final totalAmount = _getTotalAmount();
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];
    final pendingMonthsCount = pendingMonths.length;

    return Column(
      children: [
        // Pending Months Info
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.shade200, width: 2),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.orange.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "clearing_all_pending_months".tr,
                      style: AppTextStyle.small14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$pendingMonthsCount ${"months".tr} • ₹$totalAmount",
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildPaymentMethodSection(),
        const SizedBox(height: 16),

        // UPI Payment Confirmation Section
        if (selectedPayment == "upi".tr) _buildUpiPaymentConfirmation(),

        // Cash Person Selection Section
        if (selectedPayment == "cash_on_delivery".tr)
          _buildCashPersonSelection(),

        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildUpiPaymentConfirmation() {
    final totalAmount = _getTotalAmount();

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

  void _submitPayment() {
    final totalAmount = _getTotalAmount();
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];

    if (pendingMonths.isEmpty) {
      Get.snackbar(
        "error".tr,
        "no_pending_months_to_pay".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedPayment == "upi".tr) {
      if (!_paymentConfirmed) {
        Get.to(
          UpiPaymentScreen(
            amount: totalAmount.toString(),
            month: _getAllPendingMonthNumbers().join(','),
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
    final totalAmount = _getTotalAmount();
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];
    final pendingMonthsCount = pendingMonths.length;

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
                        "₹ $totalAmount",
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
                      "pending_months".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      "$pendingMonthsCount ${"months".tr}",
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
                          onPressed: _controller.isUpiPaymentLoading.value
                              ? null
                              : () {
                            Navigator.pop(context);
                            _processUpiPayment();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Center(
                            child: _controller.isUpiPaymentLoading.value
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
    final totalAmount = _getTotalAmount();
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];
    final pendingMonthsCount = pendingMonths.length;

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
                        "₹ $totalAmount",
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
                      "pending_months".tr,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      "$pendingMonthsCount ${"months".tr}",
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

  Future<void> _processUpiPayment() async {
    final totalAmount = _getTotalAmount();
    final monthArray = _getAllPendingMonthNumbers();

    if (monthArray.isEmpty) {
      Get.snackbar(
        "error".tr,
        "no_pending_months_to_pay".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final body = {
      "userId": Constant.userId.value,
      "month": monthArray, // Send as array: [2,3]
      "year": DateTime.now().year,
      "totalAmount": totalAmount,
    };
    print("UPI Payment body :: $body");

    _controller.processUpiPayment(context,body);

    setState(() {
      _paymentConfirmed = false;
    });
  }

  void _processCashPayment() async {
    final totalAmount = _getTotalAmount();
    final monthArray = _getAllPendingMonthNumbers();

    if (monthArray.isEmpty) {
      Get.snackbar(
        "error".tr,
        "no_pending_months_to_pay".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final body = {
      "userId": Constant.userId.value,
      "month": monthArray, // Send as array: [2,3]
      "year": DateTime.now().year,
      "totalAmount": totalAmount,
      "recieverName": selectedPerson,
    };

    print("Cash Payment body :: $body");
    _controller.processCashPayment(context,body);

    setState(() {
      selectedPerson = null;
    });
  }

  Widget _buildActionButtons() {
    final totalAmount = _getTotalAmount();
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];
    final pendingMonthsCount = pendingMonths.length;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
                "clearing".tr,
                style: AppTextStyle.small14.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "$pendingMonthsCount ${"months".tr} • ₹$totalAmount",
                style: AppTextStyle.small14.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
            ],
          ),
        ),
        PrimaryButton(
          text: _paymentConfirmed && selectedPayment == "upi".tr
              ? "submit_payment".tr
              : "pay_now".tr,
          onPressed: _submitPayment,
        ),
      ],
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
          PaymentMethodTile(
            value: "upi".tr,
            groupValue: selectedPayment,
            title: "upi".tr,
            subtitle: "instant_upi_payment".tr,
            icon: Icons.phone_android_rounded,
            color: AppColors.appPrimaryDarkColor,
            onChanged: (val) {
              setState(() {
                selectedPayment = val!;
                if (selectedPayment == "upi".tr) {
                  selectedPerson = null;
                  _paymentConfirmed = false;
                } else {
                  _paymentConfirmed = false;
                }
              });
            },
          ),
          const SizedBox(height: 12),
          PaymentMethodTile(
            value: "cash_on_delivery".tr,
            groupValue: selectedPayment,
            title: "cash_on_delivery".tr,
            subtitle: "pay_when_delivered".tr,
            icon: Icons.local_atm_rounded,
            color: AppColors.appPrimaryDarkColor,
            onChanged: (val) {
              setState(() {
                selectedPayment = val!;
                if (selectedPayment == "upi".tr) {
                  selectedPerson = null;
                  _paymentConfirmed = false;
                } else {
                  _paymentConfirmed = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Helper method to get formatted date
  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

  Widget _buildDueAmountList() {
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];

    if (pendingMonths.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: pendingMonths.map((month) {
        final isOverdue = month.paymentStatus?.toLowerCase() == "pending";
        final monthName = month.month ?? "Unknown Month";
        final amount = month.totalAmount ?? 0;
        final overdueDays = _calculateOverdueDays(monthName);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.appWhiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      monthName,
                      style: AppTextStyle.small16.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOverdue
                          ? Colors.red.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isOverdue
                            ? Colors.red.shade200
                            : Colors.orange.shade200,
                      ),
                    ),
                    child: Text(
                      isOverdue ? "overdue".tr : "pending".tr,
                      style: AppTextStyle.small12.copyWith(
                        color: isOverdue ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "amount".tr,
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ ${amount.toString()}",
                        style: AppTextStyle.medium18.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.appPrimaryDarkColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "milk_quantity".tr,
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${month.totalLitre ?? 0} ${"liters".tr}",
                        style: AppTextStyle.small14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isOverdue ? Colors.red : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isOverdue && overdueDays > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "$overdueDays ${"days_overdue".tr}",
                          style: AppTextStyle.small12.copyWith(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _viewDueAmountDetails(month);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPrimaryDarkColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "view_details".tr,
                    style: AppTextStyle.small14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard() {
    final paymentData = _controller.monthDetails.value.summary;

    if (paymentData == null) {
      return Container();
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
          Text(
            "total_summary".tr,
            style: AppTextStyle.small16.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 16),
          SummaryItemWidget(
            icon: Icons.local_drink_outlined,
            title: "milk_quantity".tr,
            value: "${paymentData.totalMilkQuantity ?? "0"} ${"liters".tr}",
          ),
          _buildDivider(),
          SummaryItemWidget(
            icon: Icons.calendar_today_outlined,
            title: "delivery_days".tr,
            value: "${paymentData.totalDeliveryDays ?? "0"} ${"days".tr}",
          ),
          _buildDivider(),
          SummaryItemWidget(
            icon: Icons.add_circle_outline,
            title: "extra_milk".tr,
            value: "${paymentData.totalExtraMilk ?? "0"} ${"liters".tr}",
          ),
          _buildDivider(),
          SummaryItemWidget(
            icon: Icons.inventory_2_outlined,
            title: "total_liters".tr,
            value: "${paymentData.totalLiters ?? "0"} ${"liters".tr}",
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
  }

  void _viewDueAmountDetails(PendingMonth month) {
    final isOverdue = month.paymentStatus?.toLowerCase() == "pending";
    final overdueDays = _calculateOverdueDays(month.month ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.appPrimaryDarkColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "due_amount_details".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailItem("month".tr, month.month ?? "Unknown"),
              _buildDetailItem(
                "due_amount".tr,
                "₹ ${month.totalAmount ?? "0"}",
              ),
              _buildDetailItem(
                "milk_quantity".tr,
                "${month.totalLitre ?? "0"} liters",
              ),
              _buildDetailItem(
                "delivery_days".tr,
                "${month.deliveryDays ?? "0"} days",
              ),
              _buildDetailItem(
                "extra_milk".tr,
                "${month.extraMilk ?? "0"} liters",
              ),
              _buildDetailItem(
                "price_per_liter".tr,
                "₹ ${month.pricePerLiter ?? "0"}",
              ),
              _buildDetailItem(
                "status".tr,
                isOverdue ? "overdue".tr : "pending".tr,
              ),
              if (isOverdue && overdueDays > 0)
                _buildDetailItem(
                  "overdue_days".tr,
                  "$overdueDays ${"days".tr}",
                ),
            ],
          ),
        ),
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
            "no_due_amounts_found".tr,
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: AppTextStyle.small14.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
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

  int _calculateOverdueDays(String monthName) {
    try {
      final parts = monthName.split(' ');
      if (parts.length < 2) return 0;

      final monthStr = parts[0];
      final yearStr = parts[1];

      final months = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      final month = months[monthStr];
      final year = int.tryParse(yearStr);

      if (month == null || year == null) return 0;

      final dueDate = DateTime(year, month, 15);
      final now = DateTime.now();

      if (now.isBefore(dueDate)) return 0;

      return now.difference(dueDate).inDays;
    } catch (e) {
      return 0;
    }
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/view/components/payment_method_tile.dart';
import 'package:victoria_user/view/components/shimmer_widget.dart';
import 'package:victoria_user/view/payment_page/upi_payment_screen.dart';

import '../../helper/routes_helper.dart';
import '../../model/month_summery_model.dart';
import '../../services/constants.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widget/button/primary_button.dart';
import '../components/summery_item_widget.dart';

class DueAmountTab extends StatefulWidget {
  const DueAmountTab({super.key});

  @override
  State<DueAmountTab> createState() => _DueAmountTabState();
}

class _DueAmountTabState extends State<DueAmountTab> {
  final ApiController _controller = Get.put(ApiController());
  String selectedMonth = "";
  bool _paymentConfirmed = false;
  String? selectedPerson;
  String selectedPayment = "upi".tr;
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

  @override
  void initState() {
    super.initState();
    _controller.monthSummery();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _controller.isMonthSummeryLoading.value
          ? ShimmerWidget()
          : ((_controller.monthDetails.value.pendingMonths?.length ?? 0) <= 0)
          ? _buildEmptyState()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Due Amount Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
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
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "total_due_amount".tr,
                                style: AppTextStyle.medium20.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹ ${_controller.monthDetails.value.summary?.totalAmount?.toString() ?? "0"}",
                                style: AppTextStyle.large28.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Due Amount Details Title
                  Text(
                    "due_amount_details".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "pay_pending_amounts".tr,
                    style: AppTextStyle.small14.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Due Amount List
                  _buildDueAmountList(),
                  const SizedBox(height: 20),
                  _buildSummaryCard(),
                  const SizedBox(height: 20),
                  _buildPaymentStatusSection(),
                ],
              ),
            );
    });
  }

  // NEW: Build different UI sections based on payment status
  Widget _buildPaymentStatusSection() {
    final paymentStatus = _controller.monthDetails.value.summary?.paymentStatus;

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
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
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
    final paymentData = _controller.monthDetails.value.summary;

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
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
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
                _buildPaymentDetailRow("payment_date".tr, _getFormattedDate()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthNameFromNumber(String monthNumber) {
    return months.firstWhere(
      (month) => month["number"] == monthNumber,
      orElse: () => months[0],
    )["name"]!;
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
        _buildPaymentFormSection(),
      ],
    );
  }

  // NEW: Current Status Section
  Widget _buildCurrentStatusSection() {
    return Container();
  }

  // NEW: Helper method for payment detail rows
  Widget _buildPaymentDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
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

  // NEW: Payment Form Section (for "created" status)
  Widget _buildPaymentFormSection() {
    return Column(
      children: [
        _buildPaymentMethodSection(),
        const SizedBox(height: 16),

        // ✅ UPI Payment Confirmation Section
        if (selectedPayment == "upi".tr) _buildUpiPaymentConfirmation(),

        // ✅ Cash Person Selection Section
        if (selectedPayment == "cash_on_delivery".tr)
          _buildCashPersonSelection(),

        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
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

  void _submitPayment() {
    final paymentData = _controller.monthDetails.value.summary;
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
    final paymentData = _controller.monthDetails.value.summary;
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
                          onPressed: _controller.isUpiPaymentLoading.value
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  _processUpiPayment();
                                },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Center(
                            child: _controller.isUpiPaymentLoading.value
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
    final paymentData = _controller.monthDetails.value.summary;
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

  Future<void> _processUpiPayment() async {
    final paymentData = _controller.monthDetails.value.summary;
    final amount = paymentData?.totalAmount ?? "0";

    final body = {
      "userId": Constant.userId.value,
      "month": selectedMonth,
      "year": DateTime.now().year,
      "totalAmount": amount,
    };
    print("body :: $body");

    _controller.processUpiPayment(body);

    setState(() {
      _paymentConfirmed = false;
    });
  }

  void _processCashPayment() async {
    final paymentData = _controller.monthDetails.value.summary;
    final amount = paymentData?.totalAmount ?? "0";

    final body = {
      "userId": Constant.userId.value,
      "month": selectedMonth,
      "year": DateTime.now().year,
      "totalAmount": amount,
      "recieverName": selectedPerson,
    };

    print("body :: $body");
    _controller.processCashPayment(body);

    setState(() {
      selectedPerson = null;
    });
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
          PaymentMethodTile(
            value: "upi".tr,
            groupValue: selectedPayment,
            title: "upi".tr,
            subtitle: "instant_upi_payment".tr,
            icon: Icons.phone_android_rounded,
            color: AppColors.appPrimaryDarkColor,
            onChanged: (val) {
              setState(() {
                selectedPayment = val!;
                if (selectedPayment == "upi".tr) {
                  selectedPerson = null;
                  _paymentConfirmed = false;
                } else {
                  _paymentConfirmed = false;
                }
              });
            },
          ),
          const SizedBox(height: 12),
          PaymentMethodTile(
            value: "cash_on_delivery".tr,
            groupValue: selectedPayment,
            title: "cash_on_delivery".tr,
            subtitle: "pay_when_delivered".tr,
            icon: Icons.local_atm_rounded,
            color: AppColors.appPrimaryDarkColor,
            onChanged: (val) {
              setState(() {
                selectedPayment = val!;
                if (selectedPayment == "upi".tr) {
                  selectedPerson = null;
                  _paymentConfirmed = false;
                } else {
                  _paymentConfirmed = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // NEW: Helper method to get formatted date
  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

  Widget _buildDueAmountList() {
    final pendingMonths = _controller.monthDetails.value.pendingMonths ?? [];

    if (pendingMonths.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: pendingMonths.map((month) {
        final isOverdue = month.paymentStatus?.toLowerCase() == "pending";
        final monthName = month.month ?? "Unknown Month";
        final amount = month.totalAmount ?? 0;
        final overdueDays = _calculateOverdueDays(monthName);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.appWhiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      monthName,
                      style: AppTextStyle.small16.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOverdue
                          ? Colors.red.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isOverdue
                            ? Colors.red.shade200
                            : Colors.orange.shade200,
                      ),
                    ),
                    child: Text(
                      isOverdue ? "overdue".tr : "pending".tr,
                      style: AppTextStyle.small12.copyWith(
                        color: isOverdue ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "amount".tr,
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ ${amount.toString()}",
                        style: AppTextStyle.medium18.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.appPrimaryDarkColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "milk_quantity".tr,
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${month.totalLitre ?? 0} ${"liters".tr}",
                        style: AppTextStyle.small14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isOverdue ? Colors.red : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isOverdue && overdueDays > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "$overdueDays ${"days_overdue".tr}",
                          style: AppTextStyle.small12.copyWith(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _viewDueAmountDetails(month);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPrimaryDarkColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "view_details".tr,
                    style: AppTextStyle.small14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard() {
    final paymentData = _controller.monthDetails.value.summary;

    if (paymentData == null) {
      return Container();
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
          SummaryItemWidget(
            icon: Icons.local_drink_outlined,
            title: "milk_quantity".tr,
            value: "${paymentData.totalMilkQuantity ?? "0"} ${"liters".tr}",
          ),
          _buildDivider(),
          SummaryItemWidget(
            icon: Icons.calendar_today_outlined,
            title: "delivery_days".tr,
            value: "${paymentData.totalDeliveryDays ?? "0"} ${"days".tr}",
          ),
          _buildDivider(),
          SummaryItemWidget(
            icon: Icons.add_circle_outline,
            title: "extra_milk".tr,
            value: "${paymentData.totalExtraMilk ?? "0"} ${"liters".tr}",
          ),
          _buildDivider(),
          SummaryItemWidget(
            icon: Icons.inventory_2_outlined,
            title: "total_liters".tr,
            value: "${paymentData.totalLiters ?? "0"} ${"liters".tr}",
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
  }

  void _viewDueAmountDetails(PendingMonth month) {
    final isOverdue = month.paymentStatus?.toLowerCase() == "pending";
    final overdueDays = _calculateOverdueDays(month.month ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.appPrimaryDarkColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "due_amount_details".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailItem("month".tr, month.month ?? "Unknown"),
              _buildDetailItem(
                "due_amount".tr,
                "₹ ${month.totalAmount ?? "0"}",
              ),
              _buildDetailItem(
                "milk_quantity".tr,
                "${month.totalLitre ?? "0"} liters",
              ),
              _buildDetailItem(
                "delivery_days".tr,
                "${month.deliveryDays ?? "0"} days",
              ),
              _buildDetailItem(
                "extra_milk".tr,
                "${month.extraMilk ?? "0"} liters",
              ),
              _buildDetailItem(
                "price_per_liter".tr,
                "₹ ${month.pricePerLiter ?? "0"}",
              ),
              _buildDetailItem(
                "status".tr,
                isOverdue ? "overdue".tr : "pending".tr,
              ),
              if (isOverdue && overdueDays > 0)
                _buildDetailItem(
                  "overdue_days".tr,
                  "$overdueDays ${"days".tr}",
                ),
            ],
          ),
        ),
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
            "no_due_amounts_found".tr,
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.small14.copyWith(color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: AppTextStyle.small14.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
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

  int _calculateOverdueDays(String monthName) {
    try {
      // Parse month name (assuming format like "January 2024")
      final parts = monthName.split(' ');
      if (parts.length < 2) return 0;

      final monthStr = parts[0];
      final yearStr = parts[1];

      // Convert month name to number
      final months = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      final month = months[monthStr];
      final year = int.tryParse(yearStr);

      if (month == null || year == null) return 0;

      // Calculate due date (assuming 15th of each month)
      final dueDate = DateTime(year, month, 15);
      final now = DateTime.now();

      // If due date is in future, not overdue
      if (now.isBefore(dueDate)) return 0;

      // Calculate difference in days
      return now.difference(dueDate).inDays;
    } catch (e) {
      return 0;
    }
  }
}
*/
