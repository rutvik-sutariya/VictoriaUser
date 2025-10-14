import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:victoria_user/helper/routes_helper.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/payment_page/payment_screen.dart';
import 'package:victoria_user/view/payment_page/upi_failed_screen.dart';
import 'package:victoria_user/view/setting_page/components/custom_header.dart';

class UpiPaymentSuccessScreen extends StatelessWidget {
  const UpiPaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeader(path: "", title: "UPI Payment "),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.appPrimaryDarkColor,
                      child: const Icon(Icons.check, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text("Payment Successful", style: AppTextStyle.medium20.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // ✅ Payment details card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.appWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: const Offset(0, 1),
                          ),
                        ],

                      ),
                      child: Column(
                        children: [
                          PaymentDetailRow(
                            title: "Amount Paid",
                            value: "₹ 18,750",
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            color: Color(0xFFD7E2E4),
                          ),
                          PaymentDetailRow(
                            title: "Milk Quantity",
                            value: "125 Litre",
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            color: Color(0xFFD7E2E4),
                          ),
                          PaymentDetailRow(
                            title: "Month",
                            value: "January 2025",
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            color: Color(0xFFD7E2E4),
                          ),
                          PaymentDetailRow(
                            title: "Transaction",
                            value: "TND646545",
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            color: Color(0xFFD7E2E4),
                          ),
                          PaymentDetailRow(
                            title: "Date & Time",
                            value: "29 July 2025 - 9:00AM",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ✅ Go to Dashboard button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appPrimaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Get.to(UpiPaymentFailedScreen());
                        },
                        child: Text("Go to Dashboard", style: AppTextStyle.medium22.copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ✅ Payment detail row widget
class PaymentDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const PaymentDetailRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: AppTextStyle.small16.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Text(
            value,
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.medium,
            ),
          ),
        ],
      ),
    );
  }
}
