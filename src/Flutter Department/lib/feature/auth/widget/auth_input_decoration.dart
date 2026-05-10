import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';

InputDecoration authInputDecoration(
  String hintText, {
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: AppColors.textGray.withOpacity(0.65),
    ),
    filled: true,
    fillColor: AppColors.bgWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    suffixIcon: suffixIcon,
  );
}
