import 'package:InsightHub/core/constant/app_strings.dart';

class Validators {
  static String? email(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    return null;
  }

  static String? strongPassword(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppStrings.passwordUpper;
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppStrings.passwordLower;
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.passwordNumber;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return AppStrings.passwordSpecial;
    }

    return null;
  }


}