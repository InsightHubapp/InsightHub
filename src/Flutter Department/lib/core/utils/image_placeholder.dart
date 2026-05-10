import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(LucideIcons.image, size: 40),
      ),
    );
  }
}