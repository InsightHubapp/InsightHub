import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:InsightHub/widget/app_header.dart';
import 'package:InsightHub/widget/app_motion.dart';

class SurveyThankYouScreen extends StatelessWidget {
  const SurveyThankYouScreen({super.key});

  static const String routeName = '/surveyThankYouScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.bgGradient, // 👈 هنا
        ),
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(
                title: 'Survey Complete',
                subtitle: 'Thank you for sharing your insights.',
              ),
              // Body
              Expanded(
                child: AppMotion(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(
                                    0.15,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.checkCircle,
                              color: AppColors.primaryBlue,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Title
                          const Text(
                            'Thank You!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Message
                          const Text(
                            'Your survey responses have been recorded successfully. Since you are employed, your answers will help us improve our career matching for others.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF475569),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Retake button
                          const SizedBox(height: 14),

                          // Back to home
                          SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homeScreen,
        (route) => false,
      );
    },
    icon: const Icon(Icons.home_outlined),
    label: const Text('Go to Home'),
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
    ),
  ),
),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
