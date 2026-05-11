import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/metric_tile.dart';

class PersonalityMetricsSection extends StatelessWidget {
  final MarketInsights insights;

  const PersonalityMetricsSection({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return _CategoryCard(
      title: 'Personality & behavior',
      subtitle: 'Behavior patterns common in this track .',
      child: Column(
        children: [
          MetricTile(
            label: 'Adaptability',
            value: insights.avgAdaptability,
            description: 'How well professionals typically adapt to change.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Ownership',
            value: insights.avgOwnership,
            description: 'How often people take responsibility and ownership.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Collaboration',
            value: insights.avgCollaboration,
            description: 'How strongly collaboration is part of daily work.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Consistency',
            value: insights.avgConsistency,
            description:
                'How consistently professionals execute tasks over time.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Learning Initiative',
            value: insights.avgLearningProactivity,
            description:
                'How proactive people are about learning and improving.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Prioritization',
            value: insights.avgPrioritization,
            description: 'How well professionals prioritize tasks and time.',
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
