import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/metric_tile.dart';

class ProfessionalMetricsSection extends StatelessWidget {
  final MarketInsights insights;

  const ProfessionalMetricsSection({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return _CategoryCard(
      title: 'Professional metrics',
      subtitle: 'How professionals in this track typically perform (100%).',
      child: Column(
        children: [
          MetricTile(
            label: 'Technical Level',
            value: insights.avgTechnicalLevel,
            description:
                'Average technical depth required to thrive in this track.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Soft Skills',
            value: insights.avgSoftSkills,
            description:
                'How important soft skills are for success in this track.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Communication',
            value: insights.avgCommunication,
            description: 'How much clear communication is typically needed.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Problem Solving',
            value: insights.avgProblemSolving,
            description:
                'How strongly problem-solving skills are used day-to-day.',
          ),
          const SizedBox(height: 10),

          MetricTile(
            label: 'Teamwork',
            value: insights.avgTeamwork,
            description:
                'How often collaboration and teamwork matter in this track.',
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
