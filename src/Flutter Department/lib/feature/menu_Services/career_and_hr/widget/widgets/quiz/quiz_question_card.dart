import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_answer_tile.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_question_content.dart';

class QuizAnswerOption {
  final String text;
  final int value;

  const QuizAnswerOption({required this.text, required this.value});
}

class QuizQuestionCard extends StatelessWidget {
  final String questionText;
  final String typeLabel;
  final List<QuizAnswerOption> options;
  final int? selectedValue;
  final ValueChanged<int>? onSelected;
  final Widget? answerContent;

  const QuizQuestionCard({
    super.key,
    required this.questionText,
    required this.typeLabel,
    this.options = const [],
    this.selectedValue,
    this.onSelected,
    this.answerContent,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 380
        ? 18.0
        : 22.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEAF0F8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              typeLabel,
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 18),
          QuizQuestionContent(text: questionText),
          const SizedBox(height: 24),
          if (answerContent != null)
            answerContent!
          else
            ...options.map(
              (option) => QuizAnswerTile(
                text: option.text,
                value: option.value,
                groupValue: selectedValue,
                onSelected: onSelected ?? (_) {},
              ),
            ),
        ],
      ),
    );
  }
}
