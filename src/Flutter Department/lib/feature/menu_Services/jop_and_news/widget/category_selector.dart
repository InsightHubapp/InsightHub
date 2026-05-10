import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selected.contains(category);

          return Material(
            color: Colors.transparent,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.09 : 1.0,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  final updated = List<String>.from(selected);
              
                  if (isSelected) {
                    updated.remove(category);
                  } else {
                    updated.add(category);
                  }
              
                  onChanged(updated);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.chipBorder,
                    ),
                   
                          
                        
                  ),
                  child: Row(
                    children: [
                      /// ICON
                      Icon(
                        _getCategoryIcon(category),
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
              
                      const SizedBox(width: 2),
                      /// TEXT
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
              
                      /// CHECK ICON
                     
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

IconData _getCategoryIcon(String category) {
  final value = category.toLowerCase();

  if (value.contains('back')) return Icons.storage;
  if (value.contains('front')) return Icons.web;
  if (value.contains('full')) return Icons.layers;
  if (value.contains('mobile')) return Icons.phone_android;
  if (value.contains('data')) return Icons.bar_chart;
  if (value.contains('ai')) return Icons.smart_toy;
  if (value.contains('qa')) return Icons.bug_report;
  if (value.contains('game')) return Icons.sports_esports;
  if (value.contains('cyber')) return Icons.security;
  if (value.contains('embedded')) return Icons.memory;
  if (value.contains('general')) return Icons.public;

  return Icons.work;
}