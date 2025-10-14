import 'package:flutter/material.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.enabled,
    this.onTap,
    this.readOnly,
  });

  final TextEditingController controller;
  final String hintText;
  final String title;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool? enabled;
  final bool? readOnly;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // Use a GlobalKey to access FormFieldState for checking validation errors
    // final fieldKey = GlobalKey<FormFieldState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.small16,
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          return TextFormField(
            // key: fieldKey,
            enabled: enabled ?? true,
            readOnly: readOnly ?? false,
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            cursorColor: AppColors.appPrimaryDarkColor,
            style: AppTextStyle.small16.copyWith(fontWeight: FontWeight.w500),
            onChanged: onChanged,
            onTap: onTap,

            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              hintStyle: AppTextStyle.small14.copyWith(
                color: AppColors.appTextGrayColor,
              ),
              filled: true,
              fillColor: AppColors.appWhiteColor,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.appBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.appPrimaryDarkColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.appBorderColor,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.appPrimaryDarkColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.appPrimaryDarkColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ],
    );
  }
}
