import 'package:flutter/material.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/setting_page/components/custom_header.dart';

import '../components/custom_back.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      "title": "No Extra Milk",
      "message": "No Extra Milk Because Stock is out Today.",
    },
    {"title": "Payment", "message": "Your last payment Was not Successfull."},
    {
      "title": "Regular Milk Order",
      "message":
          "Today Your Regular milk Order will Reduce 1 liter of Milk Due to Less Stock.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const CustomBack(),
        title: Text(
          "Notifications",
          style: AppTextStyle.medium24.copyWith(
            fontFamily: FontFamily.semiBold,
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical:18,
          ),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return NotificationCard(
              title: item["title"]!,
              message: item["message"]!,
            );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        border: Border.all(
          color: AppColors.appPrimaryDarkColor,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.medium20.copyWith(fontWeight: FontWeight.w500,fontFamily: FontFamily.medium),
          ),
          Text(message, style: AppTextStyle.small14.copyWith(fontSize: 15)),
        ],
      ),
    );
  }
}
