import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/metric_tile.dart';


class SatisfactionMetricsSection extends StatelessWidget {
  final MarketInsights insights;

  const SatisfactionMetricsSection({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return _CategoryCard(
      title: 'Career satisfaction',
      subtitle: 'How professionals feel about salary and balance (100%).',
      child: Column(
        children: [
          MetricTile(
            label: 'Salary Satisfaction',
            value: insights.avgSalarySatisfaction,
            description:
                'Higher means professionals are generally satisfied with compensation.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Work-Life Balance',
            value: insights.avgWorkLifeBalance,
            description:
                'Higher means better perceived balance between work and life.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Resilience',
            value: insights.avgResilience,
            description:
                'How much resilience is typically needed to handle pressure.',
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
