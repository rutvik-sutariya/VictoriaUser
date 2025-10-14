import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/text_styles.dart';

import '../components/custom_back.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  // Terms data as a structured list
  final List<Map<String, dynamic>> termsList = const [
    {
      "title": "service_title",
      "points": ["service_point1"],
    },
    {
      "title": "quality_title",
      "points": ["quality_point1", "quality_point2"],
    },
    {
      "title": "delivery_title",
      "points": [
        "delivery_point1",
        "delivery_point2",
        "delivery_point3",
        "delivery_point4",
      ],
    },
    {
      "title": "payment_title",
      "points": ["payment_point1", "payment_point2"],
    },
    {
      "title": "cancel_title",
      "points": ["cancel_point1", "cancel_point2", "cancel_point3"],
    },
    {
      "title": "duties_title",
      "points": ["duties_point1", "duties_point2", "duties_point3"],
    },
    {
      "title": "privacy_title",
      "points": ["privacy_point1"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        leading: const CustomBack(),
        title: Text(
          "terms_title".tr,
          style: AppTextStyle.medium24.copyWith(
            fontFamily: FontFamily.semiBold,
            fontWeight: FontWeight.w700,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.description_outlined,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),

            // Terms Content
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.appWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Last Updated
                      // _buildLastUpdated(),
                      //
                      // const SizedBox(height: 24),

                      // Terms List
                      ..._buildTermsContent(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
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
            child: Icon(
              Icons.gavel_rounded,
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
                  "terms_and_conditions".tr,
                  style: AppTextStyle.medium18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appWhiteColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "please_read_carefully".tr,
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


  List<Widget> _buildTermsContent() {
    List<Widget> widgets = [];

    for (int index = 0; index < termsList.length; index++) {
      final term = termsList[index];

      widgets.add(
        _buildTermSection(
          title: term["title"].toString().tr,
          points: List<String>.from(term["points"].map((point) => point.toString().tr)),
          index: index,
        ),
      );

      if (index < termsList.length - 1) {
        widgets.add(const SizedBox(height: 20));
      }
    }

    return widgets;
  }

  Widget _buildTermSection({
    required String title,
    required List<String> points,
    required int index,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getSectionColor(index).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getSectionColor(index).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSectionColor(index),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: AppTextStyle.small12.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyle.small16.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getSectionColor(index),
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Points
          ...List<Widget>.generate(
            points.length,
                (pointIndex) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildBulletPoint(
                text: points[pointIndex],
                color: _getSectionColor(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint({required String text, required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.small14.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.regular,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSectionColor(int index) {
    final colors = [
      AppColors.appPrimaryDarkColor,
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.orange.shade700,
      Colors.purple.shade700,
      Colors.red.shade700,
      Colors.teal.shade700,
    ];
    return colors[index % colors.length];
  }
}