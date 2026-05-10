import 'package:flutter/material.dart';
import 'package:insight_hub/constant/app_colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const NextButton({
    super.key,
    required this.onPressed,
    this.label = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          disabledBackgroundColor: AppColors.disabledButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
