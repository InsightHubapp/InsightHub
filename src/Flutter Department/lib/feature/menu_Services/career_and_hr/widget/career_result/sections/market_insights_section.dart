import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/sections/market_insights/work_environment_section.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/sections/market_insights/professional_metrics_section.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/sections/market_insights/satisfaction_metrics_section.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/sections/market_insights/personality_metrics_section.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/section_card.dart';

class MarketInsightsSection extends StatelessWidget {
  final MarketInsights insights;

  const MarketInsightsSection({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Market insights ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
'Based on real professionals working in this career path.'        
,    style: TextStyle(color: Color(0xFF64748B), height: 1.35),
          ),
          const SizedBox(height: 14),
          WorkEnvironmentSection(insights: insights),
          const SizedBox(height: 12),
          ProfessionalMetricsSection(insights: insights),
          const SizedBox(height: 12),
          SatisfactionMetricsSection(insights: insights),
          const SizedBox(height: 12),
          PersonalityMetricsSection(insights: insights),
        ],
      ),
    );
  }
}

