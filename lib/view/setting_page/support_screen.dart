import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';

import '../../model/contact_model.dart';
import '../components/custom_back.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ApiController _controller = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
    _controller.contactUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const CustomBack(),
        title: Text(
          "support".tr,
          style: AppTextStyle.medium24.copyWith(
            fontFamily: FontFamily.semiBold,
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        final isLoading = _controller.isContactLoading.value;

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                if (isLoading) ...[
                  _buildLoadingShimmer(),
                ] else if (_controller.contactDetails.value.data?.first.name?.isNotEmpty ?? false) ...[
                  // Main Call Card
                  _buildCallCard(),

                  const SizedBox(height: 30),

                  // Contact Information
                  _buildContactInfo(),

                  const SizedBox(height: 30),

                  // Company Address
                  _buildCompanyAddress(),

                  const SizedBox(height: 30),

                  // Support Hours
                  _buildSupportHours(),
                ] else ...[
                  _buildNoDataAvailable(),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  Widget _buildCallCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.appPrimaryDarkColor.withOpacity(0.9),
            AppColors.appPrimaryDarkColor,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Company Logo/Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.appWhiteColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.appWhiteColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.business_rounded,
              size: 50,
              color: AppColors.appWhiteColor,
            ),
          ),

          const SizedBox(height: 20),

          // Company Name
          Text(
            _controller.contactDetails.value.data?.first.name ?? "Victoria Farm",
            style: AppTextStyle.medium24.copyWith(
              fontFamily: FontFamily.bold,
              fontWeight: FontWeight.w800,
              color: AppColors.appWhiteColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          Text(
            "we_are_here_to_help_you".tr,
            style: AppTextStyle.small16.copyWith(
              color: AppColors.appWhiteColor.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

          // Call Button
          GestureDetector(
            onTap: () => _makePhoneCall(_controller.contactDetails.value.data?.first.number ?? "8866708866"),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.appWhiteColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_rounded,
                    color: AppColors.appPrimaryDarkColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "call_now".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.contact_support_rounded,
                  color: AppColors.appPrimaryDarkColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'contact_information'.tr,
                style: AppTextStyle.medium18.copyWith(
                  fontFamily: FontFamily.semiBold,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Phone Number
          _buildContactItem(
            icon: Icons.phone_rounded,
            iconColor: Colors.green,
            iconBgColor: Colors.green.withOpacity(0.1),
            title: 'customer_care'.tr,
            value: '+91 ${_controller.contactDetails.value.data?.first.number ?? "8866708866"}',
            onTap: () => _makePhoneCall(_controller.contactDetails.value.data?.first.number ?? "8866708866"),
            showActionIcon: true,
          ),

          const SizedBox(height: 15),

          // Email
          _buildContactItem(
            icon: Icons.email_rounded,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.withOpacity(0.1),
            title: 'email'.tr,
            value: _controller.contactDetails.value.data?.first.email ?? '',
            onTap: () => _sendEmail(_controller.contactDetails.value.data?.first.email ?? ''),
            showActionIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyAddress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Colors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'company_address'.tr,
                style: AppTextStyle.medium18.copyWith(
                  fontFamily: FontFamily.semiBold,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Address Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.appBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.contactDetails.value.data?.first.name ?? "Victoria Farm",
                        style: AppTextStyle.small16.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _controller.contactDetails.value.data?.first.address ?? "Servey no 289 Medra Village Gandhinagar",
                        style: AppTextStyle.small14.copyWith(
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _openMaps(_controller.contactDetails.value.data?.first.address ?? "Servey no 289 Medra Village Gandhinagar"),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_rounded,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'get_directions'.tr,
                              style: AppTextStyle.small14.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool showActionIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.appBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.small12.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyle.small16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (showActionIcon)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: iconColor,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHours() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_filled_rounded,
              color: Colors.purple,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'support_hours'.tr,
                  style: AppTextStyle.small14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '24_hours_7_days'.tr,
                  style: AppTextStyle.small12.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.info_outline_rounded,
            color: Colors.purple,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataAvailable() {
    return Column(
      children: [
        const SizedBox(height: 100),
        Icon(
          Icons.support_agent_rounded,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 20),
        Text(
          'no_contact_info_available'.tr,
          style: AppTextStyle.medium18.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'please_try_again_later'.tr,
          style: AppTextStyle.small14.copyWith(
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _controller.contactUs(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appPrimaryDarkColor,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'retry'.tr,
            style: AppTextStyle.small14.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) {
    final formattedNumber = phoneNumber.startsWith('+91')
        ? phoneNumber
        : '+91$phoneNumber';

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_rounded,
                color: Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'call_customer_care'.tr,
              style: AppTextStyle.medium18.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'call_confirmation_message'.tr,
              style: AppTextStyle.small14.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              formattedNumber,
              style: AppTextStyle.small16.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.appPrimaryDarkColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: AppTextStyle.small14.copyWith(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              launchUrl(Uri.parse('tel:$formattedNumber'));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'call'.tr,
                style: AppTextStyle.small14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'error'.tr,
        'cannot_send_email'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _openMaps(String address) async {
    final encodedAddress = Uri.encodeFull(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'error'.tr,
        'cannot_open_maps'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:victoria_farm/controller/api_controller.dart';
import 'package:victoria_farm/utils/app_colors.dart';
import 'package:victoria_farm/utils/text_styles.dart';

import '../components/custom_back.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ApiController _controller = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
    _controller.contactUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const CustomBack(),
        title: Text(
          "support".tr,
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Main Call Card
              _buildCallCard(),

              const SizedBox(height: 40),

              // Contact Information
              _buildContactInfo(),

              const SizedBox(height: 30),

              // Support Hours
              _buildSupportHours(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.appPrimaryDarkColor.withOpacity(0.9),
            AppColors.appPrimaryDarkColor,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Call Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.appWhiteColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.appWhiteColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.call_rounded,
              size: 50,
              color: AppColors.appWhiteColor,
            ),
          ),

          const SizedBox(height: 25),

          Text(
            "call_us".tr,
            style: AppTextStyle.medium24.copyWith(
              fontFamily: FontFamily.semiBold,
              fontWeight: FontWeight.w700,
              color: AppColors.appWhiteColor,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "we_are_here_to_help_you".tr,
            style: AppTextStyle.small16.copyWith(
              color: AppColors.appWhiteColor.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Call Button
          GestureDetector(
            onTap: _makePhoneCall,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.appWhiteColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_rounded,
                    color: AppColors.appPrimaryDarkColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "call_now".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.contact_phone_rounded,
                  color: AppColors.appPrimaryDarkColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'contact_information'.tr,
                style: AppTextStyle.medium18.copyWith(
                  fontFamily: FontFamily.semiBold,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Phone Number
          GestureDetector(
            onTap: _makePhoneCall,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.appBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'customer_care'.tr,
                          style: AppTextStyle.small12.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+91 8866708866',
                          style: AppTextStyle.small16.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.call_made_rounded,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportHours() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'support_hours'.tr,
                  style: AppTextStyle.small14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '24_hours_7_days'.tr,
                  style: AppTextStyle.small12.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall() {
    final phoneNumber = '+918866708866';

    // Show confirmation dialog
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone_rounded, color: Colors.green, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'call_customer_care'.tr,
              style: AppTextStyle.medium18.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'call_confirmation_message'.tr,
          style: AppTextStyle.small14.copyWith(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: AppTextStyle.small14.copyWith(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Launch phone call
              // You can use url_launcher package for this
              launchUrl(Uri.parse('tel:$phoneNumber'));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'call'.tr,
                style: AppTextStyle.small14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
