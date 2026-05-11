import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';

class WorkEnvironmentSection extends StatelessWidget {
  final MarketInsights insights;

  const WorkEnvironmentSection({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return _CategoryCard(
      title: 'Work environment',
      subtitle: 'Where and how people typically work in this track.',
      child: Column(
        children: [
          _StatRow(
            label: 'Work Environment',
            value: insights.mostCommonEnvironment,
          ),

          const SizedBox(height: 12),

          _StatRow(
            label: 'Typical Company Size',
            value: insights.mostCommonCompanySize,
          ),

          const SizedBox(height: 12),

          _StatRow(
            label: 'Average Experience',
            value: '${insights.avgYearsExperience.toStringAsFixed(1)} Years',
          ),

          const SizedBox(height: 12),

          _StatRow(
            label: 'Professionals Analyzed',
            value: insights.totalEmployeesInTrack.toString(),
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
      padding: const EdgeInsets.all(14),
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

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final display = value.isEmpty ? 'Not specified' : value;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          display,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
