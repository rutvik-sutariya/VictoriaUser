import 'package:flutter/material.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_back.dart';
import 'package:victoria_user/view/components/custom_svg.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.path, required this.title});

  final String path;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomBack(),
        Column(
          children: [
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    title,
                    style: AppTextStyle.medium24.copyWith(
                      fontFamily: FontFamily.semiBold,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
