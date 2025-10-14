import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/helper/routes_helper.dart';
import 'package:victoria_user/main.dart';
import 'package:victoria_user/services/api_service/config.dart';
import 'package:victoria_user/services/local_storage/local_storage.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final ApiController _controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ App Bar
            _buildAppBar(),

            // ✅ Profile Section with enhanced design
            _buildProfileSection(),

            // ✅ Settings List with better spacing and visual hierarchy
            Expanded(
              child: _buildSettingsList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Text(
            'settings'.tr,
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings,
              color: AppColors.appPrimaryDarkColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Profile Avatar with border
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.appWhiteColor,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.appWhiteColor,
              backgroundImage: NetworkImage(
                "${Config.baseUrl}${_controller.userDetails.value.data?.profileImage}",
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_controller.userDetails.value.data?.name}",
                  style: AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhiteColor,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "+91 ${_controller.userDetails.value.data?.mobile}",
                  style: AppTextStyle.small14.copyWith(
                    color: AppColors.appWhiteColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section Header
            _buildSectionHeader('general'.tr),
            const SizedBox(height: 12),

            // General Settings
            _buildSettingCard(
              icon: Icons.location_on_outlined,
              title: 'your_delivery_address'.tr,
              subtitle: "${_controller.userDetails.value.data?.address}",
              hasNotification: false,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.language_outlined,
              title: 'language'.tr,
              subtitle: prefs.getString(LocalStorage.language.value)?.capitalizeFirst ?? "Gujarati",
              hasNotification: false,
              onTap: () {
                Get.toNamed(Routes.languagePage);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.notifications_outlined,
              title: 'notifications'.tr,
              subtitle: 'On',
              hasNotification: true,
              onTap: () {
                Get.toNamed(Routes.notificationsPage);
              },
            ),

            const SizedBox(height: 24),

            // Section Header
            _buildSectionHeader('more'.tr),
            const SizedBox(height: 12),

            // More Settings
            _buildSettingCard(
              icon: Icons.history_outlined,
              title: 'history'.tr,
              hasNotification: false,
              onTap: () {
                // Get.toNamed(Routes.historyPage);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.description_outlined,
              title: 'terms'.tr,
              hasNotification: false,
              onTap: () {
                Get.toNamed(Routes.termsPage);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.support_agent_outlined,
              title: 'support'.tr,
              hasNotification: false,
              onTap: () {
                Get.toNamed(Routes.supportPage);
              },
            ),


            const SizedBox(height: 24),

            // Logout Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.red.withOpacity(0.2),
                ),
              ),
              child: _buildSettingCard(
                icon: Icons.logout_outlined,
                title: 'logout'.tr,
                titleColor: Colors.red,
                iconColor: Colors.red,
                hasNotification: false,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle.small14.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor.withOpacity(0.7),
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? iconColor,
    required bool hasNotification,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.appPrimaryDarkColor.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppColors.appBgColor.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.appPrimaryDarkColor).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: iconColor ?? AppColors.appPrimaryDarkColor,
              ),
            ),

            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.small16.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: titleColor ?? Colors.black87,
                          ),
                        ),
                      ),
                      if (hasNotification)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyle.small14.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Arrow Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.appPrimaryDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'logout'.tr,
                style: AppTextStyle.medium18.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            'are_you_sure_you_want_to_logout'.tr,
            style: AppTextStyle.small14,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'cancel'.tr,
                style: AppTextStyle.small14.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                _performLogout();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'logout'.tr,
                  style: AppTextStyle.small14.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Clear local storage
    prefs.clear();

    // Navigate to login screen
    Get.offAllNamed(Routes.loginPage);

    // Show logout success message
    Get.rawSnackbar(
      message: "logged_out_successfully".tr,
      backgroundColor: AppColors.appPrimaryDarkColor,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
    );
  }
}