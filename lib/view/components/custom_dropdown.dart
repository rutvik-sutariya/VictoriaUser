import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.onChanged,
    required this.hintText,
    required this.array,
    this.value,
    this.validator,
    this.color, this.icon,
  });

  final void Function(T?) onChanged;
  final T? value;
  final String hintText;
  final Color? color;
  final List<T> array;
  final Widget? icon;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      value: value,
      items: array.toSet().toList().map((T val) {
        return DropdownMenuItem<T>(
          value: val,
          child: Text(
            val.toString(),
            style: AppTextStyle.small16.copyWith(
              fontFamily: FontFamily.semiBold,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,

      icon: icon ?? const Icon(
        Icons.arrow_drop_down_sharp,
        color: AppColors.appBlackColor,
      ),
      validator: validator,
      hint: Text(
        hintText,
        style: AppTextStyle.small16.copyWith(
          fontFamily: FontFamily.semiBold,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.appPrimaryLightColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.appBorderColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.appPrimaryDarkColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: AppTextStyle.small16,
      dropdownColor: AppColors.appPrimaryLightColor,
      iconEnabledColor: AppColors.appWhiteColor,
    );
  }
}
