/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_back.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

class MilkOrderScreen extends StatefulWidget {
  const MilkOrderScreen({super.key});

  @override
  State<MilkOrderScreen> createState() => _MilkOrderScreenState();
}

class _MilkOrderScreenState extends State<MilkOrderScreen> {
  final String selectedDate = '29/07/2025';

  String selectedValue = "0 Liter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFFFEF), // light green background
      appBar: AppBar(
        backgroundColor: Color(0xFFEFFFEF),
        elevation: 0,
        leading: CustomBack(),
        title: Text(
          "Today's Orders",
          style: TextStyle(
            color: AppColors.appPrimaryDarkColor,
            fontFamily: FontFamily.bold,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.appPrimaryDarkColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.refresh, color: AppColors.appWhiteColor),
              ),
              SizedBox(width: 8),
              Text(
                "Morning",
                style: AppTextStyle.medium24.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.semiBold,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 39,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      border: Border.all(
                        color: AppColors.appBlackColor,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedDate, style: AppTextStyle.medium20),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 39,

                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      border: Border.all(
                        color: AppColors.appBlackColor,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text("Saturday", style: AppTextStyle.medium20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Milk + Name
            Container(
              height: 39,

              decoration: BoxDecoration(
                color: AppColors.appWhiteColor,
                border: Border.all(color: AppColors.appBlackColor, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Milk , Miteshbhai",
                  style: AppTextStyle.medium20,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Customer Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  selectedValue == "Extra"
                    ? Color(0xFFAFE4EF)
                    :  Color(0xFFD9FFDE),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appBlackColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/300",
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 32,
                          width: 90,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color:  selectedValue == "Extra"
                                ? Color(0xFF009DC8)
                                : AppColors.appPrimaryDarkColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "No : 123",
                            style: AppTextStyle.medium18.copyWith(
                              color: AppColors.appWhiteColor,
                              fontFamily: FontFamily.semiBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Name
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Miteshbhai Patel",
                      style: AppTextStyle.medium18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Address
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Address : 101 sahaj residency , Nikol Ahmedabad",
                      style: AppTextStyle.medium18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Milk Quantity
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Milk Quantity : 2 Liter (Morning)",
                      style: AppTextStyle.medium18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Extra Milk
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset(
                            SvgPath.edit,
                            color: Colors.transparent,
                          ),
                        ),
                        Text(
                          "Extra Milk : $selectedValue",
                          style: AppTextStyle.medium18.copyWith(
                            fontFamily: FontFamily.medium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: _showMilkDialog,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SvgPicture.asset(SvgPath.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  SizedBox(
                    height: 45,
                    child: Row(
                      children: [
                        // Reason Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            items: [
                              DropdownMenuItem(
                                value: "Milk stock is low today",
                                child: Text(
                                  "Milk stock is low today",
                                  style: AppTextStyle.medium18,
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Milk stock is out today",
                                child: Text(
                                  "Milk stock is out today",
                                  style: AppTextStyle.medium18,
                                ),
                              ),
                            ],
                            onChanged: (value) {},
                            hint: Text(
                              "Reason",
                              style: AppTextStyle.medium18.copyWith(
                                fontFamily: FontFamily.medium,
                              ),
                            ),
                            style: AppTextStyle.medium18.copyWith(
                              fontFamily: FontFamily.medium,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              fillColor: AppColors.appWhiteColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        if(selectedValue == "Extra")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset(SvgPath.trues),
                        ),
                        if(selectedValue == "Extra")
                        SvgPicture.asset(SvgPath.clear),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),

                  PrimaryButton(
                    height: 45,
                    color: selectedValue == "Extra"
                        ? Color(0xFF009DC8)
                        : AppColors.appPrimaryDarkColor,
                    text: "Submit",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMilkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.appBgColor,
          title: Text(
            "Select Option",
            style: AppTextStyle.large28.copyWith(
              fontFamily: FontFamily.bold,
              fontWeight: FontWeight.bold,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _optionTile("0 Liter"),
              _optionTile("Extra"),
              _optionTile("Out of Stock"),
            ],
          ),
        );
      },
    );
  }

  Widget _optionTile(String value) {
    return ListTile(
      title: Text(value, style: AppTextStyle.medium18),
      onTap: () {
        setState(() {
          selectedValue = value;
        });
        Navigator.pop(context);
      },
    );
  }
}
*/
