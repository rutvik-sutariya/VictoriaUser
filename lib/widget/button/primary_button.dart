import 'package:flutter/material.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.textSize,
    this.width,
    this.color,
    this.textColor,
    this.loading,
  });

  final String text;
  final Function()? onPressed;
  final double? height;
  final double? textSize;
  final double? width;
  final Color? color;
  final Color? textColor;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: loading == true
              ? Colors.grey[400]
              : (color ?? AppColors.appPrimaryDarkColor),
          minimumSize: Size.fromHeight(height ?? 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: loading == true
            ? Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: AppColors.appPrimaryDarkColor,
                  ),
                ),
              )
            : Text(
                text,
                style: AppTextStyle.small16.copyWith(
                  color: textColor ?? AppColors.appWhiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
