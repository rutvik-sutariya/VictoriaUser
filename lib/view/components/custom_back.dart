import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/view/components/custom_svg.dart';

class CustomBack extends StatelessWidget {
  const CustomBack({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: AppColors.appPrimaryDarkColor,
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 13),
          child: CustomSvg(path: SvgPath.back),
        )
    );
  }
}
