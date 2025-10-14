import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_back.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomBack(),
        ),
        title: Text(
          "Notifications".tr,
          style: AppTextStyle.medium20.copyWith(
            fontFamily: FontFamily.semiBold,
          ),
        ),
        elevation: 0,
        centerTitle: true,

        backgroundColor: AppColors.appBgColor,
      ),
      body:  Column(
        children: [
          Container(
            margin: EdgeInsetsGeometry.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            height: 60,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appPrimaryLightColor,
              border: Border.all(color: AppColors.appBorderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              labelStyle: AppTextStyle.medium20.copyWith(
                fontFamily: FontFamily.medium,
              ),
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.appTextGrayColor,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: AppColors.appWhiteColor,
              unselectedLabelColor: AppColors.appWhiteColor,
              tabs: [
                Tab(text: 'Message'.tr),
                Tab(text: 'Wallet'.tr),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 13,
                  ),
                  children: [
                    Text(
                      'Today'.tr,
                      style: AppTextStyle.medium18.copyWith(
                        fontFamily: FontFamily.medium,
                      ),
                    ),

                  ],
                ),
                ListView(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  children: [
                    Text(
                      'Today'.tr,
                      style: AppTextStyle.medium20.copyWith(
                        color: AppColors.appGrayColor,
                        fontFamily: FontFamily.medium,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.appBgColor,
                        border: Border.all(color: AppColors.appBorderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD237),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/app_images/car.png',
                                  // height: 40,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(
                                          '₹100',
                                          style: AppTextStyle.extraLarge30.copyWith(
                                            fontFamily: FontFamily.bold,
                                            color: AppColors.appBgColor,
                                          )
                                      ),
                                      SizedBox(height: 2),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade900,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Text(
                                            'CASHBACK RECEIVED',
                                            style: AppTextStyle.small16.copyWith(
                                              color: AppColors.appWhiteColor,
                                              fontFamily: FontFamily.bold,
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/app_images/app-logo.png',
                                  height: 30,
                                  width: 60,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                                  '🎉 ₹100 cashback has been added\nto your Wallet!',
                                  style: AppTextStyle.medium20.copyWith(
                                    fontFamily: FontFamily.medium,
                                    color: AppColors.appWhiteColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Top off your wallet & get assured\n₹50 cashback on your next ride.',
                                  style: AppTextStyle.medium20.copyWith(
                                    fontFamily: FontFamily.medium,
                                    color: AppColors.appGrayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget buildMessageItem({
    required String imagePath,
    required String title,
    required String subTitle,
    required String time,
  }) {
    return ListTile(
      leading: SvgPicture.asset(imagePath, ),
      title: Text(
        title,
        style: AppTextStyle.small16.copyWith(
          fontFamily: FontFamily.semiBold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTitle,
            style: AppTextStyle.small14.copyWith(
              color: AppColors.appTextGrayColor,
              fontFamily: FontFamily.medium,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              time,
              style: AppTextStyle.small14.copyWith(
                color: AppColors.appHintTextColor,
                fontFamily: FontFamily.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
