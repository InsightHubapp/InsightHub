import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/question_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_question_card.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int? answer;
  final ValueChanged<int> onChanged;

  const QuestionCard({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = answer;

    return QuizQuestionCard(
      questionText: question.text,
      typeLabel: _typeLabel,
      selectedValue: selectedValue,
      onSelected: onChanged,
      options: question.type == QuestionType.choice
          ? question.options
                .map(
                  (option) => QuizAnswerOption(
                    text: option.text,
                    value: option.numericValue,
                  ),
                )
                .toList()
          : const [],
      answerContent: switch (question.type) {
        QuestionType.choice => null,
        QuestionType.scale => _ScaleInput(
          value: selectedValue,
          onChanged: onChanged,
        ),
        QuestionType.yesNo => _YesNoInput(
          value: selectedValue,
          onChanged: onChanged,
        ),
      },
    );
  }

  String get _typeLabel {
    switch (question.type) {
      case QuestionType.choice:
        return 'Choice';
      case QuestionType.scale:
        return 'Scale 1-5';
      case QuestionType.yesNo:
        return 'Yes / No';
    }
  }
}

class _YesNoInput extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;

  const _YesNoInput({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _YesNoButton(
            label: 'Yes',
            isSelected: value == 1,
            onTap: () => onChanged(1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _YesNoButton(
            label: 'No',
            isSelected: value == 0,
            onTap: () => onChanged(0),
          ),
        ),
      ],
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _YesNoButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : const Color(0xFFE2E8F0),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScaleInput extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;

  const _ScaleInput({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentValue = (value ?? 3).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          activeTrackColor: AppColors.primaryBlue,
          inactiveTrackColor: const Color(0xFFE2E8F0),
          thumbShape: const _CustomThumb(),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
          showValueIndicator: ShowValueIndicator.onlyForDiscrete,
          valueIndicatorColor: AppColors.primaryBlue,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: currentValue,
          label: currentValue.round().toString(),
          onChanged: (v) => onChanged(v.round()),
        ),
      ),
    );
  }
}

class _CustomThumb extends SliderComponentShape {
  const _CustomThumb();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    canvas.drawCircle(
      center,
      10,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    canvas.drawCircle(center, 10, Paint()..color = Colors.white);
  }
}
