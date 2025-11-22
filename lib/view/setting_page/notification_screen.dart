import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';
import '../components/custom_back.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiController _controller = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
    _controller.notification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const CustomBack(),
        title: Text(
          "Notifications",
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
        if (_controller.isNotificationLoading.value) {
          return _buildShimmerLoader();
        }
        final notifications = _controller.notificationDetails.value.data;
        if (notifications == null || notifications.isEmpty) {
          return _buildEmptyState();
        }
        return _buildNotificationsList();
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 60,
              color: AppColors.appPrimaryDarkColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Notifications",
            style: AppTextStyle.medium20.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "You don't have any notifications yet.\nWe'll notify you when something arrives.",
            textAlign: TextAlign.center,
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Column(
      children: [
        // Header with count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,
                color: AppColors.appPrimaryDarkColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "${_controller.notificationDetails.value.data?.length} ${_controller.notificationDetails.value.data?.length == 1 ? 'Notification' : 'Notifications'}",
                style: AppTextStyle.small14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.appPrimaryDarkColor,
                ),
              ),
              const Spacer(),
              if (_controller.notificationDetails.value.data!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    // Add mark all as read functionality
                  },
                  child: Text(
                    "Mark all as read",
                    style: AppTextStyle.small12.copyWith(
                      color: AppColors.appPrimaryDarkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Notifications list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _controller.notificationDetails.value.data?.length,
            itemBuilder: (context, index) {
              final item = _controller.notificationDetails.value.data?[index];
              return NotificationCard(
                title: item?.title ?? "",
                message: item?.body ?? "",
                time: item?.sentAt.toString() ?? DateTime.now().toString(), // You can replace with actual time from API
                isRead: index > 0, // Example logic for read/unread
                onTap: () {
                  // Handle notification tap
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Enhanced Shimmer Loader
  Widget _buildShimmerLoader() {
    return Column(
      children: [
        // Shimmer header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Shimmer list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRead
                  ? AppColors.appWhiteColor
                  : AppColors.appPrimaryDarkColor.withOpacity(0.05),
              border: Border.all(
                color: isRead
                    ? AppColors.appPrimaryDarkColor.withOpacity(0.2)
                    : AppColors.appPrimaryDarkColor.withOpacity(0.3),
                width: isRead ? 1 : 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!isRead)
                  BoxShadow(
                    color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isRead
                        ? AppColors.appPrimaryDarkColor.withOpacity(0.1)
                        : AppColors.appPrimaryDarkColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 20,
                    color: isRead
                        ? AppColors.appPrimaryDarkColor
                        : AppColors.appWhiteColor,
                  ),
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.small16.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.medium,
                          color: AppColors.appPrimaryDarkColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: AppTextStyle.small14.copyWith(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        time,
                        style: AppTextStyle.small12.copyWith(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread indicator
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.appPrimaryDarkColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}