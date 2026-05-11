import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';

class MetricTile extends StatelessWidget {
  final String label;

  final double value;

  final String description;

  final double scaleMax;

  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.description,
    this.scaleMax = 5,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        scaleMax <= 0 ? 0.0 : ((value / scaleMax) * 100);

    final progress = (percentage / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,

              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}