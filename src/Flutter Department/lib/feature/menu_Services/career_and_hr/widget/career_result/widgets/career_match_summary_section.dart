import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/section_card.dart';

class CareerMatchSummarySection extends StatelessWidget {
  final CareerQuizResultModel result;

  const CareerMatchSummarySection({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final top = result.topTracks.isNotEmpty ? result.topTracks.first : null;
    final top3 = result.topTracks.take(3).toList();

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Career Match Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          
          
          const SizedBox(height: 10),
          if (top != null)
            Text(
              top.similarityMessage,
              style: const TextStyle(
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
          const SizedBox(height: 5),
          const Divider(height: 10),
       
          const SizedBox(height: 10),
          Column(
            children: top3.map((t) {
              final progress = (t.combinedScore / 100).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        t.track.trackName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 8,
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
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 48,
                      child: Text(
                        t.combinedScore.toStringAsFixed(1),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

