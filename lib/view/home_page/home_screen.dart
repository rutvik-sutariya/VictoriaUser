import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/services/constants.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/widget/button/primary_button.dart';
import '../components/custom_svg.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ApiController _controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: Obx(() {
          if (_controller.userDetails.value.data == null) {
            return _buildShimmerUI();
          }
          return _buildRealUI();
        }),
      ),
    );
  }

  /// =============================
  /// Shimmer Loading UI
  /// =============================
  Widget _buildShimmerUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(height: 70, width: 150, radius: 16),
              Row(
                children: [
                  _circleShimmer(size: 40),
                  const SizedBox(width: 12),
                  _circleShimmer(size: 40),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Greeting Shimmer
          _shimmerBox(height: 32, width: 180, radius: 8),
          const SizedBox(height: 8),
          _shimmerBox(height: 32, width: 200, radius: 8),
          const SizedBox(height: 24),

          // Cards Shimmer
          _shimmerCard(height: 160),
          const SizedBox(height: 16),
          _shimmerCard(height: 160),
          const SizedBox(height: 16),
          _shimmerCard(height: 220),
          const SizedBox(height: 16),
          _shimmerCard(height: 200),
          const SizedBox(height: 16),
          _shimmerCard(height: 140),
        ],
      ),
    );
  }

  /// =============================
  /// Real Data UI
  /// =============================
  Widget _buildRealUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Logo and Icons
          _buildHeader(),
          const SizedBox(height: 24),

          // Welcome Section
          _buildWelcomeSection(),
          const SizedBox(height: 24),

          // Delivery Cards
          _buildDeliveryCards(),
          const SizedBox(height: 16),

          // Order Extra Milk Card
          _buildOrderExtraMilkCard(),
          const SizedBox(height: 16),

          // No Order Milk Card
          _buildNoOrderMilkCard(),
          const SizedBox(height: 16),

          // Notes Section
          _buildNotesSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomSvg(
                  path: SvgPath.victoriaFarm,
                  height: 40,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "victoria_farm".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.appPrimaryDarkColor,
                    ),
                  ),
                  Text(
                    "fresh_milk_delivery".tr,
                    style: AppTextStyle.small12.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
      /*    Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: AppColors.appPrimaryDarkColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.appPrimaryDarkColor,
                  size: 20,
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
            blurRadius: 15,
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
            child: Icon(
              Icons.waving_hand_rounded,
              color: AppColors.appWhiteColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhiteColor,
                  ),
                ),
                Text(
                  "${_controller.userDetails.value.data?.name ?? 'Customer'}!",
                  style: AppTextStyle.medium20.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.appWhiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCards() {
    return Row(
      children: [
        Expanded(
          child: DeliveryCard(
            title: "morning".tr,
            liter: '${_controller.userDetails.value.data?.morningLiters ?? '0'}',
            icon: Icons.wb_twilight_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DeliveryCard(
            title: "evening".tr,
            liter: '${_controller.userDetails.value.data?.eveningLiters ?? '0'}',
            icon: Icons.nightlight_round_rounded,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderExtraMilkCard() {
    return OrderExtraMilkCard();
  }

  Widget _buildNoOrderMilkCard() {
    return NoOrderMilkCard();
  }

  Widget _buildNotesSection() {
    return NotesSection();
  }

  // Shimmer Helpers
  Widget _shimmerBox({
    double height = 16,
    double width = double.infinity,
    double radius = 4,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _circleShimmer({double size = 40}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _shimmerCard({double height = 120}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "good_morning".tr;
    } else if (hour < 17) {
      return "good_afternoon".tr;
    } else {
      return "good_evening".tr;
    }
  }
}

/// =============================
/// Enhanced Delivery Card
/// =============================
class DeliveryCard extends StatelessWidget {
  final String title;
  final String liter;
  final IconData icon;
  final Color color;

  const DeliveryCard({
    super.key,
    required this.title,
    required this.liter,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String dayName = _getDayName(now.weekday);
    final String formattedDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyle.small16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem(Icons.local_drink_rounded, "$liter ${"liters".tr}"),
            const SizedBox(height: 8),
            _buildInfoItem(Icons.calendar_today_rounded, dayName),
            const SizedBox(height: 8),
            _buildInfoItem(Icons.date_range_rounded, formattedDate),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.appBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.small14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return "monday".tr;
      case 2: return "tuesday".tr;
      case 3: return "wednesday".tr;
      case 4: return "thursday".tr;
      case 5: return "friday".tr;
      case 6: return "saturday".tr;
      case 7: return "sunday".tr;
      default: return "";
    }
  }
}

/// =============================
/// Enhanced Order Extra Milk Card
/// =============================
class OrderExtraMilkCard extends StatelessWidget {
  OrderExtraMilkCard({super.key});

  final RxString extraOrder = "Morning".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxInt selectedLiters = 1.obs;
  final ApiController _controller = Get.put(ApiController());

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectedDate.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "order_extra_milk".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Liters Selection
              _buildLitersSelector(),
              const SizedBox(height: 12),

              // Date Picker
              _buildDatePicker(context),
              const SizedBox(height: 12),

              // Slot Selection
              _buildSlotSelector(),
              const SizedBox(height: 16),

              // Order Button
              _buildOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLitersSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_quantity".tr,
          style: AppTextStyle.small14.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.appBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<int>(
            value: selectedLiters.value,
            underline: const SizedBox(),
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            items: List.generate(10, (index) => DropdownMenuItem(
              value: index + 1,
              child: Text("${index + 1} ${"liter".tr}"),
            )),
            onChanged: (val) => selectedLiters.value = val ?? 1,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_date".tr,
          style: AppTextStyle.small14.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.appBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedDate.value == null
                      ? "choose_date".tr
                      : "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}",
                  style: AppTextStyle.small14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_slot".tr,
          style: AppTextStyle.small14.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSlotButton("Morning", Icons.wb_twilight_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSlotButton("Evening", Icons.nightlight_round_rounded),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlotButton(String slot, IconData icon) {
    final isSelected = extraOrder.value == slot;
    return GestureDetector(
      onTap: () => extraOrder.value = slot,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appPrimaryDarkColor : AppColors.appBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.appPrimaryDarkColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              slot.tr,
              style: AppTextStyle.small14.copyWith(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderButton() {
    final isEnabled = selectedDate.value != null;
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: "order_milk".tr,
        height: 50,
        color: isEnabled ? AppColors.appPrimaryDarkColor : Colors.grey.shade300,
        textColor: isEnabled ? Colors.white : Colors.grey.shade600,
        loading: _controller.isExtraMilkLoading.value,
        onPressed: isEnabled ? () {
          final body = {
            "slot": extraOrder.value.toLowerCase(),
            "liters": selectedLiters.value,
            "requestedForDate": "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}",
          };
          _controller.extraMilk(body).then((_) {
            selectedDate.value = null;
          });
        } : null,
      ),
    );
  }
}

/// =============================
/// Enhanced No Order Milk Card
/// =============================
class NoOrderMilkCard extends StatelessWidget {
  NoOrderMilkCard({super.key});

  final RxString noOrder = "Morning".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final ApiController _controller = Get.put(ApiController());

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectedDate.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "cancel_order".tr,
                    style: AppTextStyle.medium18.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Picker
              _buildDatePicker(context),
              const SizedBox(height: 12),

              // Slot Selection
              _buildSlotSelector(),
              const SizedBox(height: 16),

              // Cancel Button
              _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_date".tr,
          style: AppTextStyle.small14.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.appBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedDate.value == null
                      ? "choose_date".tr
                      : "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}",
                  style: AppTextStyle.small14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "select_slot".tr,
          style: AppTextStyle.small14.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildCancelSlotButton("Morning", Icons.wb_twilight_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCancelSlotButton("Evening", Icons.nightlight_round_rounded),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelSlotButton(String slot, IconData icon) {
    final isSelected = noOrder.value == slot;
    return GestureDetector(
      onTap: () => noOrder.value = slot,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : AppColors.appBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              slot.tr,
              style: AppTextStyle.small14.copyWith(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    final isEnabled = selectedDate.value != null;
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: "cancel_order".tr,
        height: 50,
        color: isEnabled ? Colors.red : Colors.grey.shade300,
        textColor: isEnabled ? Colors.white : Colors.grey.shade600,
        loading: _controller.isCancelLoading.value,
        onPressed: isEnabled ? () {
          final body = {
            "userId": Constant.userId.value,
            "date": "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}",
            "slot": noOrder.value.toLowerCase(),
          };
          _controller.cancelOrder(body);
        } : null,
      ),
    );
  }
}

/// =============================
/// Enhanced Notes Section
/// =============================
class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  "important_notes".tr,
                  style: AppTextStyle.small16.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildNoteItem("extra_order_note".tr),
            const SizedBox(height: 8),
            _buildNoteItem("cancel_order_note".tr),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4, right: 8),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
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
import 'package:victoria_user/widget/button/primary_button.dart';
import '../components/custom_svg.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ApiController _controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: Obx(() {
          if (_controller.userDetails.value.data == null) {
            // ✅ Show shimmer placeholders
            return _buildShimmerUI();
          }

          // ✅ Show real data UI
          return _buildRealUI();
        }),
      ),
    );
  }

  /// =============================
  /// Shimmer Loading UI
  /// =============================
  Widget _buildShimmerUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(height: 70, width: 150, radius: 8),
              Row(
                children: [
                  _circleShimmer(size: 30),
                  const SizedBox(width: 12),
                  _circleShimmer(size: 30),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Greeting
          _shimmerBox(height: 28, width: 150, radius: 6),
          const SizedBox(height: 8),
          _shimmerBox(height: 28, width: 180, radius: 6),
          const SizedBox(height: 18),

          // Cards
          _shimmerCard(height: 140),
          const SizedBox(height: 16),
          _shimmerCard(height: 140),
          const SizedBox(height: 16),
          _shimmerCard(height: 180),
          const SizedBox(height: 16),
          _shimmerCard(height: 160),
          const SizedBox(height: 16),
          _shimmerCard(height: 100),
        ],
      ),
    );
  }

  /// =============================
  /// Real Data UI
  /// =============================
  Widget _buildRealUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(AppPath.milk, height: 71),
                  const SizedBox(width: 8),
                  CustomSvg(path: SvgPath.victoriaFarm, height: 83),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.language, color: AppColors.appPrimaryDarkColor),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.notifications,
                    color: AppColors.appPrimaryDarkColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            "Good Morning",
            style: AppTextStyle.large28.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          Text(
            "${_controller.userDetails.value.data?.name}!",
            style: AppTextStyle.large28.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.semiBold,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 18),

          // Morning Card
          DeliveryCard(
            title: "Morning",
            liter: '${_controller.userDetails.value.data?.morningLiters}',
          ),
          const SizedBox(height: 16),

          // Evening Card
          DeliveryCard(
            title: "Evening",
            liter: '${_controller.userDetails.value.data?.eveningLiters}',
          ),
          const SizedBox(height: 16),

          // Order Extra Milk Card
          OrderExtraMilkCard(),
          const SizedBox(height: 16),

          // No Order Milk Card
          NoOrderMilkCard(),
          const SizedBox(height: 16),

          // Notes Section
          const NotesSection(),
        ],
      ),
    );
  }

  /// =============================
  /// Shimmer Helpers
  /// =============================
  Widget _shimmerBox({
    double height = 16,
    double width = double.infinity,
    double radius = 4,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _circleShimmer({double size = 40}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _shimmerCard({double height = 120}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// =============================
/// Your existing widgets (DeliveryCard, InfoField, etc.)
/// =============================
class DeliveryCard extends StatelessWidget {
  final String title;
  final String liter;

  DeliveryCard({super.key, required this.title, required this.liter});

  final ApiController _controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    // ✅ Get today's date
    final DateTime now = DateTime.now();
    final String dayName = _getDayName(now.weekday);
    final String formattedDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.20),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, color: AppColors.appPrimaryDarkColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: AppTextStyle.medium20.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            InfoField(text: '$liter Liter'),
            const SizedBox(height: 8),
            InfoField(text: dayName), // ✅ Live Day
            const SizedBox(height: 8),
            InfoField(text: formattedDate), // ✅ Live Date
          ],
        ),
      ),
    );
  }

  /// ✅ Helper method for weekday name
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "friday".tr;
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }
}

class InfoField extends StatelessWidget {
  final String text;

  const InfoField({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBlackColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyle.small14.copyWith(
          fontFamily: FontFamily.medium,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class OrderExtraMilkCard extends StatelessWidget {
  OrderExtraMilkCard({super.key});

  final RxString extraOrder = "Morning".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // ✅ Dropdown liters
  final RxInt selectedLiters = 1.obs;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectedDate.value = picked;
  }

  final ApiController _controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        color: AppColors.appWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_circle_outline),
                    const SizedBox(width: 8),
                    Text("Order Extra Milk", style: AppTextStyle.medium20),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ✅ Dropdown for liters
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.appBlackColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: selectedLiters.value,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: List.generate(
                    10,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1} Liter"),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) selectedLiters.value = val;
                  },
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Date Picker
              GestureDetector(
                onTap: () => _pickDate(context),
                child: InfoField(
                  text: selectedDate.value == null
                      ? "Select Date"
                      : "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}",
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: extraOrder.value == "Morning"
                            ? AppColors.appPrimaryDarkColor
                            : AppColors.appWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: extraOrder.value == "Morning"
                                ? AppColors.appPrimaryDarkColor
                                : AppColors.appBlackColor,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () => extraOrder.value = "Morning",
                      child: Text(
                        "Morning",
                        style: AppTextStyle.small14.copyWith(
                          color: extraOrder.value == "Morning"
                              ? AppColors.appWhiteColor
                              : AppColors.appBlackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: extraOrder.value == "Evening"
                            ? AppColors.appPrimaryDarkColor
                            : AppColors.appWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: extraOrder.value == "Evening"
                                ? AppColors.appPrimaryDarkColor
                                : AppColors.appBlackColor,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () => extraOrder.value = "Evening",
                      child: Text(
                        "Evening",
                        style: AppTextStyle.small14.copyWith(
                          color: extraOrder.value == "Evening"
                              ? AppColors.appWhiteColor
                              : AppColors.appBlackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Center(
                child: PrimaryButton(
                  text:  "Order Milk",
                  width: 150,
                  height: 40,
                  color: selectedDate.value != null ? AppColors.appPrimaryDarkColor : Colors.grey[300],
                  textColor: selectedDate.value != null ? AppColors.appWhiteColor : AppColors.appBlackColor,
                  loading: _controller.isExtraMilkLoading.value,
                  onPressed: () {
                    final body = {
                      "slot": extraOrder.value.toLowerCase(),
                      "liters": selectedLiters.value,
                      "requestedForDate": selectedDate.value != null
                          ? "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}"
                          : "",
                    };
                    print("Body :: $body");
                    _controller.extraMilk(body).then((onValue){
                      selectedDate.value = null;
                    });
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class NoOrderMilkCard extends StatelessWidget {
  NoOrderMilkCard({super.key});

  final RxString noOrder = "Morning".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final ApiController _controller = Get.put(ApiController());

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectedDate.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        color: AppColors.appWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel_outlined),
                    const SizedBox(width: 8),
                    Text("No Order Milk", style: AppTextStyle.medium20),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ✅ Date Picker
              GestureDetector(
                onTap: () => _pickDate(context),
                child: InfoField(
                  text: selectedDate.value == null
                      ? "Select Date"
                      : "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}",
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: noOrder.value == "Morning"
                            ? AppColors.appPrimaryDarkColor
                            : AppColors.appWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: noOrder.value == "Morning"
                                ? AppColors.appPrimaryDarkColor
                                : AppColors.appBlackColor,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () => noOrder.value = "Morning",
                      child: Text(
                        "Morning",
                        style: AppTextStyle.small14.copyWith(
                          color: noOrder.value == "Morning"
                              ? AppColors.appWhiteColor
                              : AppColors.appBlackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: noOrder.value == "Evening"
                            ? AppColors.appPrimaryDarkColor
                            : AppColors.appWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: noOrder.value == "Evening"
                                ? AppColors.appPrimaryDarkColor
                                : AppColors.appBlackColor,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () => noOrder.value = "Evening",
                      child: Text(
                        "Evening",
                        style: AppTextStyle.small14.copyWith(
                          color: noOrder.value == "Evening"
                              ? AppColors.appWhiteColor
                              : AppColors.appBlackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: PrimaryButton(
                  text: "Done",
                  width: 100,
                  height: 40,
                  color: selectedDate.value != null ? AppColors.appPrimaryDarkColor : Colors.grey[300],
                  textColor: selectedDate.value != null ? AppColors.appWhiteColor : AppColors.appBlackColor,
                  loading: _controller.isCancelLoading.value,
                  onPressed: () {
                    final body = {
                      "userId": Constant.userId.value,
                      "date": selectedDate.value != null
                          ? "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}"
                          : "",
                      "slot": noOrder.value.toLowerCase(),
                    };
                    print("Body :: $body");
                    _controller.cancelOrder(body).then((onValue){

                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.appWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Notes :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            BulletText(
              "For Order Extra Milk, You must Order 3 hours before Delivery Time",
            ),
            BulletText(
              "To Cancel your order, You Must Have to Inform 3 hours before Delivery Time",
            ),
          ],
        ),
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;

  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• "),
        Expanded(child: Text(text)),
      ],
    );
  }
}
*/
