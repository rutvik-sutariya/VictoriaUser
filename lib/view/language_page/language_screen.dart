import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/main.dart';
import 'package:victoria_user/services/local_storage/local_storage.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_back.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final RxInt selectedIndex = 0.obs;

  final RxList<Map<String, String>> languages = <Map<String, String>>[
    {
      "name": "English",
      "code": "en",
      "nativeName": "English"
    },
    {
      "name": "ગુજરાતી",
      "code": "gu",
      "nativeName": "Gujarati"
    },
  ].obs;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  void _loadCurrentLanguage() {
    final currentLang = prefs.getString(LocalStorage.language.value) ?? "gujarati";
    if (currentLang == "gujarati") {
      selectedIndex.value = 1;
    } else {
      selectedIndex.value = 0;
    }
  }

  void _changeLanguage(int index) {
    selectedIndex.value = index;

    if (selectedIndex.value == 0) {
      Get.updateLocale(const Locale('en', 'US'));
      prefs.setString(LocalStorage.language.value, "english");
    } else if (selectedIndex.value == 1) {
      Get.updateLocale(const Locale('gu', 'IN'));
      prefs.setString(LocalStorage.language.value, "gujarati");
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const CustomBack(),
        title: Text(
          "language".tr,
          style: AppTextStyle.medium24.copyWith(
            fontFamily: FontFamily.semiBold,
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),

            const SizedBox(height: 32),

            // Language List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: languages.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildLanguageCard(
                      language: languages[index],
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.appPrimaryDarkColor.withOpacity(0.8),
            AppColors.appPrimaryDarkColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhiteColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.language_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "select_language".tr,
                  style: AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhiteColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "choose_your_preferred_language".tr,
                  style: AppTextStyle.small14.copyWith(
                    color: AppColors.appWhiteColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required Map<String, String> language,
    required int index,
  }) {
    final isSelected = selectedIndex.value == index;

    return GestureDetector(
      onTap: () => _changeLanguage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.appPrimaryDarkColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? AppColors.appPrimaryDarkColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Language Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      language["name"]!,
                      style: AppTextStyle.medium18.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.appPrimaryDarkColor
                            : AppColors.appBlackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      language["nativeName"]!,
                      style: AppTextStyle.small14.copyWith(
                        color: isSelected
                            ? AppColors.appPrimaryDarkColor.withOpacity(0.7)
                            : AppColors.appTextGrayColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Radio Button with Animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.appPrimaryDarkColor
                        : AppColors.appTextGrayColor,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.appPrimaryDarkColor
                        : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}