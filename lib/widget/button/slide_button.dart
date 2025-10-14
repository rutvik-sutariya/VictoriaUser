import 'package:flutter/material.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideButton extends StatelessWidget {

  const SlideButton({super.key, required this.text, required this.onSubmit, this.submittedIcon});
  final String text;
  final Future<dynamic>? Function() onSubmit;
  final Widget? submittedIcon;
  @override
  Widget build(BuildContext context) {
    return SlideAction(
      key: key,
      height: 48,
      borderRadius: 10,
      elevation: 0,
      submittedIcon: submittedIcon,
      sliderButtonIconSize: 10,
      innerColor: AppColors.appWhiteColor,
      outerColor: AppColors.appPrimaryDarkColor,
      sliderButtonIconPadding: 8,
      sliderButtonIcon: Icon(
        Icons.arrow_forward,
        color: AppColors.appPrimaryDarkColor,
      ),
      text: text,
      textStyle: AppTextStyle.small16.copyWith(
        fontFamily: FontFamily.semiBold,
      ),
      onSubmit: onSubmit,
    );
  }
}
