import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/section_card.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  final TrackInfo track;

  const SkillsSection({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final skills = track.requiredSkillsList;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Core skills required',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'These are the core skills commonly required for this career path.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.35),
          ),
          const SizedBox(height: 12),
          if (skills.isEmpty)
            const Text(
              'No skills provided by backend.',
              style: TextStyle(color: Color(0xFF94A3B8)),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((s) => SkillChip(label: s)).toList(growable: false),
            ),
        ],
      ),
    );
  }
}

