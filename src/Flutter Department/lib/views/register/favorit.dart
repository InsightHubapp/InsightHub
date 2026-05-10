import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:insight_hub/constant/routes.dart';
import 'package:insight_hub/constant/app_colors.dart';
import 'package:insight_hub/widget/next_button.dart';
import 'package:insight_hub/cuibt/cubit/register_cubit.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});
 //make routname
  static const String routeName = '/interestSelectionScreen';
  @override
  State<InterestSelectionScreen> createState() => _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  // Track selected IDs
  final Set<String> _selectedInterests = {};

  final List<Map<String, dynamic>> _categories = [
    {'id': 'technology', 'label': 'Technology', 'icon': LucideIcons.code},
    {'id': 'health', 'label': 'Health', 'icon': LucideIcons.heart},
    {'id': 'business', 'label': 'Business', 'icon': LucideIcons.briefcase},
    {'id': 'design', 'label': 'Design', 'icon': LucideIcons.palette},
    {'id': 'energy', 'label': 'Energy', 'icon': LucideIcons.zap},
    {'id': 'engineering', 'label': 'Engineering', 'icon': LucideIcons.cpu}, 
    {'id': 'marketing', 'label': 'Marketing', 'icon': LucideIcons.trendingUp},
    {'id': 'hr', 'label': 'Human Resources', 'icon': LucideIcons.users},
  ];

  void _toggleInterest(String id) {
    setState(() {
      if (_selectedInterests.contains(id)) {
        _selectedInterests.remove(id);
      } else {
        if (_selectedInterests.length < 3) {
          _selectedInterests.add(id);
        }
      }
    });
  }

  void _handleNext() {
   
    Navigator.pushNamed(context, Routes.confirmationScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton()
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "What interests you?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_selectedInterests.length}/3',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Select 1 to 3 interests to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // GRID OF INTERESTS
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final item = _categories[index];
                  final isSelected = _selectedInterests.contains(item['id']);
                  final canSelect = isSelected || _selectedInterests.length < 3;

                  return GestureDetector(
                    onTap: canSelect ? () => _toggleInterest(item['id']) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFDBEAFE) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            color: isSelected ?  AppColors.primaryBlue : (canSelect ? Colors.black54 : Colors.grey[300]),
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ?  AppColors.primaryBlue : (canSelect ? Colors.black87 : Colors.grey[400]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // NEXT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: NextButton(
                label: 'Next',
                onPressed: _selectedInterests.isEmpty
                    ? null
                    : _handleNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

