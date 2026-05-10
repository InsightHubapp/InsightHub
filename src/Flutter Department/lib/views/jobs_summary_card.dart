import 'package:flutter/material.dart';

import 'package:InsightHub/core/constant/app_colors.dart';

import 'package:InsightHub/feature/home_and_explore/model/dashboard_item.dart';

class JobsSummaryCard extends StatelessWidget {
  final DashboardItem item;

  const JobsSummaryCard({super.key, required this.item});

  String _extractValue(DashboardItem item) {
    final d = item.data;
    if (d is Map<String, dynamic>) {
      return d['data']?.toString() ?? '0';
    }
    return d?.toString() ?? '0';
  }

  String _extractSuffix(DashboardItem item) {
    final d = item.data;
    if (d is Map<String, dynamic>) {
      return d['suffix']?.toString() ?? 'Jobs';
    }
    return 'Jobs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Posted Lately',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _extractValue(item),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _extractSuffix(item),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}