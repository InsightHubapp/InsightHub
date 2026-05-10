import 'package:flutter/material.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_code_block.dart';

class QuizQuestionContent extends StatelessWidget {
  final String text;

  const QuizQuestionContent({super.key, required this.text});

  static final RegExp _codeBlockPattern = RegExp(
    r'```([a-zA-Z0-9_+-]*)\s*([\s\S]*?)```',
    multiLine: true,
  );

  @override
  Widget build(BuildContext context) {
    final matches = _codeBlockPattern.allMatches(text).toList();

    if (matches.isEmpty) {
      return _QuestionText(text.trim());
    }

    final widgets = <Widget>[];
    var cursor = 0;

    for (final match in matches) {
      final leadingText = text.substring(cursor, match.start).trim();
      if (leadingText.isNotEmpty) {
        widgets.add(_QuestionText(leadingText));
      }

      final language = match.group(1);
      final code = match.group(2) ?? '';
      if (code.trim().isNotEmpty) {
        widgets.add(QuizCodeBlock(code: code, language: language));
      }

      cursor = match.end;
    }

    final trailingText = text.substring(cursor).trim();
    if (trailingText.isNotEmpty) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: widgets.isEmpty ? 0 : 14),
          child: _QuestionText(trailingText),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

class _QuestionText extends StatelessWidget {
  final String text;

  const _QuestionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
        height: 1.42,
        letterSpacing: 0,
      ),
    );
  }
}
