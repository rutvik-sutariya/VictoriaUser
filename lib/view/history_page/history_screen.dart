import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/services/constants.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_dropdown.dart';
import 'package:victoria_user/view/components/custom_svg.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiController _controller = Get.put(ApiController());
  String _selectedFilter = "Weekly";

  @override
  void initState() {
    super.initState();
    _loadHistory("weekly");
  }

  void _loadHistory(String filterType) {
    final body = {
      "userId": Constant.userId.value,
      "filterType": filterType.toLowerCase(),
    };
    _controller.getMilkHistory(body);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: AppColors.appBgColor,
        appBar: AppBar(
          backgroundColor: AppColors.appBgColor,
          title: Text(
            "milk_history".tr,
            style: AppTextStyle.medium24.copyWith(
              fontFamily: FontFamily.semiBold,
              fontWeight: FontWeight.w700,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // Refresh functionality
                _loadHistory(_selectedFilter.toLowerCase());
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: AppColors.appPrimaryDarkColor,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Header Stats
            _buildHeaderStats(),

            // Filter and Content Section
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.appWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildFilterSection(),
                    const SizedBox(height: 8),
                    _buildHistoryList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStats() {
    final totalOrders = _controller.milkHistoryDetails.value.data?.length ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Icons.history_rounded,
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
                  "order_history".tr,
                  style: AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhiteColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${"total_orders".tr}: $totalOrders",
                  style: AppTextStyle.small14.copyWith(
                    color: AppColors.appWhiteColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.appWhiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.appWhiteColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              "$totalOrders",
              style: AppTextStyle.small14.copyWith(
                color: AppColors.appWhiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
                ),
              ),
              child: CustomDropdown(
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value.toString();
                  });
                  _loadHistory(value.toString().toLowerCase());
                },
                hintText: "filter_by".tr,
                array: [
                  "daily".tr,
                  "weekly".tr,
                  "monthly".tr,
                  "3_month".tr,
                  "6_month".tr,
                  "yearly".tr,
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.appPrimaryDarkColor,
                  AppColors.appPrimaryDarkColor,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // Download functionality
                Get.rawSnackbar(
                  message: "downloading_history".tr,
                  backgroundColor: AppColors.appPrimaryDarkColor,
                );
              },
              icon: const Icon(
                Icons.download_rounded,
                color: AppColors.appWhiteColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Expanded(
      child: _controller.isMilkHisLoading.value
          ? _buildShimmerList()
          : _controller.milkHistoryDetails.value.data?.isEmpty ?? true
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.milkHistoryDetails.value.data?.length ?? 0,
        itemBuilder: (context, index) {
          final history = _controller.milkHistoryDetails.value.data?[index];
          return _buildHistoryCard(history, index);
        },
      ),
    );
  }

  Widget _buildHistoryCard(history, int index) {
    final isDelivered = (history?.status?.toLowerCase() == "delivered");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDelivered
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status Indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: isDelivered ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 12),

            // Milk Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: CustomSvg(
                path: SvgPath.milk,
                color: AppColors.appPrimaryDarkColor,
                height: 20,
              ),
            ),

            const SizedBox(width: 12),

            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${history?.date ?? "N/A"}",
                        style: AppTextStyle.small16.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDelivered
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${history?.status ?? "Pending"}",
                          style: AppTextStyle.small12.copyWith(
                            color: isDelivered ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${history?.time ?? "N/A"}",
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${history?.slot ?? "N/A"}",
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${history?.liters ?? "0"} ${"liters".tr}",
                        style: AppTextStyle.small16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.appPrimaryDarkColor,
                        ),
                      ),

                      if (isDelivered)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.appWhiteColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 16, width: 120, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 80, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 16, width: 60, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.history_toggle_off_rounded,
          size: 80,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          "no_history_found".tr,
          style: AppTextStyle.medium18.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "no_orders_in_selected_period".tr,
          style: AppTextStyle.small14.copyWith(
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}