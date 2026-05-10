import 'package:flutter/material.dart';
class AppColors {
  // ===== New System (Clean) =====

  static const primary = Color(0xFF2563EB);//static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const success = Color.fromARGB(255, 56, 90, 91);
//  static const success = Color(0xFF2563EB);
  static const scaffoldBg = Color(0xFFF9FAFB);
  static const cardBg = Color(0xFFFFFFFF);
  static const softBlue = Color(0xFFEFF6FF);
  static const softGreen = Color(0xFFF0FDF4);

  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF4B5563);

  static const border = Color(0xFFE5E7EB);

  static const chipBorder = Color(0xFFD1D5DB);

  static const disabled = Color(0xFFD1D5DB);

  // ===== OLD NAMES (Compatibility Layer) =====
  // 👇 ده اللي هيصلح التطبيق كله بدون ما تكسر أي حاجة

  static const primaryBlue = primary;
  
  static const primaryGreen = success;
  static const shadowblue =  Color(0xFFDBEAFE);

  static const bgLightBlue = softBlue;
  static const bgLightGreen = softGreen;
  static const bgLightGray = scaffoldBg;
  static const bgWhite = cardBg;

  static const textDark = textPrimary;
  static const textGray = textSecondary;
  static const textLightGray = textMuted;
  static const textDarkGray = textPrimary;

  static const borderLight = border;
  static const borderMedium = chipBorder;

  static const accentLightBlue = softBlue;

  static const disabledButton = disabled;

  static const logoBlue = primary;
  static const logoGreen = success;
  
static const LinearGradient bgGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF2563EB), // 🔵 فوق (غامق بس ناعم)
    Color(0xFF60A5FA), // انتقال طبيعي
    Color(0xFF93C5FD), // أفتح
    Color(0xFFE0F2FE), // نفس اللي تحت تقريبًا
  ],
);
static const LinearGradient smartAnswerGradient = LinearGradient(
  begin: Alignment.topRight,
  end: AlignmentGeometry.centerRight,     // 👈 من فوق يمين (أحمر)
 
  colors: [
    Color(0xFFFEE2E2), // 🔴 أحمر فاتح (فوق يمين)
    Colors.white,      // 🤍 مساحة للنص
    Color(0xFFDCFCE7), // 🟢 أخضر فاتح (تحت شمال)
  ],
);
static const LinearGradient cardGradient = LinearGradient(
          colors: [
            Color(0xFF6C63FF), // start color
            Color(0xFF4F46E5), // end color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
static const LinearGradient cardGradient2 = LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255), // start color
            Color(0xFFF9FAFB), // end color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
}
