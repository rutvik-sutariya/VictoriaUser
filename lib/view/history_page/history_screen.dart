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
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiController _controller = Get.put(ApiController());

  // Define filter options with display keys and API values
  final List<Map<String, String>> _filterOptions = [
    {'displayKey': 'daily', 'apiValue': 'daily'},
    {'displayKey': 'weekly', 'apiValue': 'weekly'},
    {'displayKey': 'monthly', 'apiValue': 'monthly'},
    {'displayKey': '3_month', 'apiValue': '3 month'},
    {'displayKey': '6_month', 'apiValue': '6 month'},
    {'displayKey': 'yearly', 'apiValue': 'yearly'},
    {'displayKey': 'custom', 'apiValue': 'custom'}, // Added custom option
  ];

  String _selectedFilter = "weekly";
  String _selectedDisplayValue = "weekly";
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showCustomDatePicker = false;

  @override
  void initState() {
    super.initState();
    _loadHistory(_selectedFilter);
  }

  void _loadHistory(String filterType) {
    final body = {
      "userId": Constant.userId.value,
      "filterType": filterType,
    };

    // For custom filter, add start and end dates
    if (filterType == 'custom' && _startDate != null && _endDate != null) {
      body['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
      body['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    _controller.getMilkHistory(body);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appPrimaryDarkColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, reset end date
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appPrimaryDarkColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyCustomFilter() {
    if (_startDate != null && _endDate != null) {
      _loadHistory('custom');
    } else {
      Get.snackbar(
        'warning'.tr,
        'please_select_both_dates'.tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: SafeArea(
          child: Column(
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
    return Column(
      children: [
        Padding(
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
                      if (value != null) {
                        // Find the index of the selected value in the translated array
                        final translatedArray = _filterOptions.map((option) => option['displayKey']!.tr).toList();
                        final selectedIndex = translatedArray.indexOf(value.toString());

                        if (selectedIndex != -1) {
                          final selectedOption = _filterOptions[selectedIndex];
                          setState(() {
                            _selectedDisplayValue = selectedOption['displayKey']!;
                            _selectedFilter = selectedOption['apiValue']!;
                            _showCustomDatePicker = (_selectedFilter == 'custom');
                          });

                          if (_selectedFilter != 'custom') {
                            _loadHistory(_selectedFilter);
                          }
                        }
                      }
                    },
                    hintText: "filter_by".tr,
                    // Use translation keys and apply .tr when building the dropdown items
                    array: _filterOptions.map((option) => option['displayKey']!.tr).toList(),
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
                    final body = {"filterType": _selectedFilter};
                    if (_selectedFilter == 'custom' && _startDate != null && _endDate != null) {
                      body['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
                      body['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
                    }
                    print("body :: $body");
                    _controller.milkPdfExport(body);
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
        ),

        // Custom Date Picker Section
        if (_showCustomDatePicker)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.appBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _startDate != null
                                      ? DateFormat('dd/MM/yyyy').format(_startDate!)
                                      : 'select_start_date'.tr,
                                  maxLines: 1,
                                  style: AppTextStyle.small14.copyWith(
                                    color: _startDate != null ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.appPrimaryDarkColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.appBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _endDate != null
                                      ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                      : 'select_end_date'.tr,
                                  maxLines: 1,
                                  style: AppTextStyle.small14.copyWith(
                                    color: _endDate != null ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.appPrimaryDarkColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyCustomFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appPrimaryDarkColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 3,
                    ),
                    child: Text(
                      'apply_filter'.tr,
                      style: AppTextStyle.small16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
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
                          "${history?.status ?? "pending"}".tr,
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
                        "${history?.slot ?? "N/A"}".tr,
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
          _selectedFilter == 'custom' && _showCustomDatePicker
              ? "no_orders_in_selected_date_range".tr
              : "no_orders_in_selected_period".tr,
          style: AppTextStyle.small14.copyWith(
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/*
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

  // Define filter options with display keys and API values
  final List<Map<String, String>> _filterOptions = [
    {'displayKey': 'daily', 'apiValue': 'daily'},
    {'displayKey': 'weekly', 'apiValue': 'weekly'},
    {'displayKey': 'monthly', 'apiValue': 'monthly'},
    {'displayKey': '3_month', 'apiValue': '3 month'},
    {'displayKey': '6_month', 'apiValue': '6 month'},
    {'displayKey': 'yearly', 'apiValue': 'yearly'},
  ];

  String _selectedFilter = "weekly";
  String _selectedDisplayValue = "weekly";

  @override
  void initState() {
    super.initState();
    _loadHistory(_selectedFilter);
  }

  void _loadHistory(String filterType) {
    final body = {
      "userId": Constant.userId.value,
      "filterType": filterType,
    };
    _controller.getMilkHistory(body);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: SafeArea(
          child: Column(
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
                  if (value != null) {
                    // Find the index of the selected value in the translated array
                    final translatedArray = _filterOptions.map((option) => option['displayKey']!.tr).toList();
                    final selectedIndex = translatedArray.indexOf(value.toString());

                    if (selectedIndex != -1) {
                      final selectedOption = _filterOptions[selectedIndex];
                      setState(() {
                        _selectedDisplayValue = selectedOption['displayKey']!;
                        _selectedFilter = selectedOption['apiValue']!;
                      });
                      _loadHistory(_selectedFilter);
                    }
                  }
                },
                hintText: "filter_by".tr,
                // Use translation keys and apply .tr when building the dropdown items
                array: _filterOptions.map((option) => option['displayKey']!.tr).toList(),
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
                final body = {"filterType": _selectedFilter};
                print("body :: $body");
                _controller.milkPdfExport(body);
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
                          "${history?.status ?? "pending"}".tr,
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
                        "${history?.slot ?? "N/A"}".tr,
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
*/
