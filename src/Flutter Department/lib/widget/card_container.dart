import 'package:flutter/material.dart';
import 'package:insight_hub/constant/app_colors.dart';
class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.children,
  });
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:  AppColors.bgLightGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:  AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
}