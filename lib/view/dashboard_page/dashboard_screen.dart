import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/history_page/history_screen.dart';
import 'package:victoria_user/view/home_page/home_screen.dart';
import 'package:victoria_user/view/payment_page/payment_screen.dart';
import 'package:victoria_user/view/setting_page/setting_screen.dart';

class DashboardScreen extends StatefulWidget {
  final RxInt currentIndex;

  const DashboardScreen({super.key, required this.currentIndex});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiController _controller = Get.put(ApiController());
  final RxList _children = [
    HomeScreen(),
    PaymentScreen(),
    HistoryScreen(),
    SettingScreen(),
  ].obs;

  @override
  void initState() {
    _controller.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        color: AppColors.appBgColor,
        child: SafeArea(
          child: Scaffold(
            body: _children[(widget.currentIndex.value)],
            bottomNavigationBar: _buildCustomBottomNavigationBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.appWhiteColor,
          selectedItemColor: AppColors.appPrimaryDarkColor,
          unselectedItemColor: AppColors.appTextGrayColor,
          iconSize: 24,
          selectedLabelStyle: AppTextStyle.small12.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          unselectedLabelStyle: AppTextStyle.small12.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: [
            _buildBottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'home'.tr,
              index: 0,
            ),
            _buildBottomNavItem(
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet_rounded,
              label: 'payment'.tr,
              index: 1,
            ),
            _buildBottomNavItem(
              icon: Icons.history_outlined,
              activeIcon: Icons.history_rounded,
              label: 'history'.tr,
              index: 2,
            ),
            _buildBottomNavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings_rounded,
              label: 'settings'.tr,
              index: 3,
            ),
          ],
          currentIndex: widget.currentIndex.value,
          onTap: (index) {
            widget.currentIndex.value = index;
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = widget.currentIndex.value == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: isSelected
            ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.appPrimaryDarkColor.withOpacity(0.8),
              AppColors.appPrimaryDarkColor,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        )
            : null,
        child: Icon(
          isSelected ? activeIcon : icon,
          size: 22,
          color: isSelected ? AppColors.appWhiteColor : AppColors.appTextGrayColor,
        ),
      ),
      label: label,
    );
  }

  // Alternative Design with Floating Action Button Style
  Widget _buildAlternativeBottomNavigationBar() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'home'.tr,
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet_rounded,
            label: 'payment'.tr,
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.history_outlined,
            activeIcon: Icons.history_rounded,
            label: 'history'.tr,
            index: 2,
          ),
          _buildNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'settings'.tr,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = widget.currentIndex.value == index;

    return GestureDetector(
      onTap: () {
        widget.currentIndex.value = index;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: isSelected
                ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.appPrimaryDarkColor,
                  AppColors.appPrimaryDarkColor,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            )
                : null,
            child: Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? AppColors.appWhiteColor : AppColors.appTextGrayColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.small12.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.appPrimaryDarkColor : AppColors.appTextGrayColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}