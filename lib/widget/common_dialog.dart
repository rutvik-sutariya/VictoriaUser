import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/widget/button/cancel_button.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

void commonDialog({
  required String title,
  required String text,
  Function()? onPressed,
  String confirmText = "Yes",
  String cancelText = "No",
  bool showCancelButton = true,
}) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: AppColors.appPrimaryLightColor,
      title: Text(title, style: AppTextStyle.medium24.copyWith(
        fontFamily: FontFamily.bold,
        color: AppColors.appPrimaryDarkColor
      )),
      content: Text(text, style: AppTextStyle.small16.copyWith(
        
      )),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              if (showCancelButton) Expanded(
                child: PrimaryButton(
                  text: cancelText,
                 color: AppColors.appErrorColor,
                 onPressed: () => Get.back(),
                ),
              ),
              if (showCancelButton) const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  onPressed: onPressed ?? () => Get.back(),
                  text: confirmText,

                ),
              ),
            ],
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}