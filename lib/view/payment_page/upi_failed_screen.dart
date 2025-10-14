import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/helper/routes_helper.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

import '../setting_page/components/custom_header.dart';

class UpiPaymentFailedScreen extends StatelessWidget {
  const UpiPaymentFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeader(path: "", title: "UPI Payment "),

              // ❌ Failed icon
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red,
                child: const Icon(Icons.close, size: 40, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // ❌ Failed message
              Text(
                "Payment Failed",
                style: AppTextStyle.medium20.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // ❌ Transaction could not be completed message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
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
                child: Text(
                  "Transaction could not be completed.",
                  style: AppTextStyle.medium22.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // ❌ Go to Payment button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryButton(
                  height: 56,
                  text: "Go to Payment",
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PrimaryButton(
                  height: 56,
                  text: "Go to Dashboard",
                  onPressed: () {
                    Get.toNamed(Routes.dashboardPage);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
