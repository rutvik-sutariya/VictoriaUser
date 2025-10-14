import 'package:flutter/material.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key, required this.text, required this.onTap});

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Color(0xFFEA1A1A),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.small16.copyWith(
              
              color: AppColors.appWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
