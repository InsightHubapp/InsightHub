import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_styles.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/widgets/arrow_painter.dart';

class CustomBadgeWidget extends StatelessWidget {
  const CustomBadgeWidget({
    super.key,
    required this.value,
    required this.color,
  });

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          constraints: const BoxConstraints(minWidth: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(ChartStyles.badgeRadius),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 6),
        CustomPaint(
          size: const Size(6, 3),
          painter: ArrowPainter(color: color),
        ),
      ],
    );
  }
}
