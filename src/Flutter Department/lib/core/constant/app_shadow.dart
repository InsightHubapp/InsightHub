import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> level1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> level2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> level3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> focus = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}