import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/helper/routes_helper.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_svg.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and Title
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppPath.milk, height: 99.13),
                      SizedBox(width: 8),
                      CustomSvg(path: SvgPath.victoriaFarm),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "fresh_tagline".tr,
                  style: AppTextStyle.medium20.copyWith(
                    color: AppColors.appPrimaryDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "premium_tagline".tr,
                  style: AppTextStyle.small14.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Main Login Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appPrimaryDarkColor.withOpacity(0.20),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "get_started".tr,
                        style: AppTextStyle.medium20.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "join_text".tr,
                        style: AppTextStyle.small14.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        text: "login".tr,
                        onPressed: () {
                          Get.toNamed(Routes.loginPage);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Daily Delivery Card
                InfoCard(
                  icon: Icons.access_time,
                  title: "daily_delivery_title".tr,
                  description: "daily_delivery_desc".tr,
                ),

                const SizedBox(height: 16),

                // Premium Quality Card
                InfoCard(
                  icon: Icons.star_border,
                  title: "premium_quality_title".tr,
                  description: "premium_quality_desc".tr,
                ),

                const SizedBox(height: 24),

                // Bottom Tags
                Text(
                  "bottom_tag_1".tr,
                  style: AppTextStyle.small12.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "bottom_tag_2".tr,
                  style: AppTextStyle.small14.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.20),
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.appPrimaryDarkColor, size: 30),
          const SizedBox(height: 18),
          Text(
            title,
            style: AppTextStyle.medium18.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyle.small14.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
