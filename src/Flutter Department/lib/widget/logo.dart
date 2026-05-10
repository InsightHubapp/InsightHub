
import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xff2563EB), // blue-600
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.trending_up,
        size: 75,
        color: Colors.white,
      ),
    );
  }
}