import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class SummaryItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isTotal;

  const SummaryItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.appPrimaryDarkColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.small16.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.appPrimaryDarkColor,
            )
                : AppTextStyle.small16.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
