import 'package:flutter/material.dart';
import 'package:insight_hub/widget/logo.dart';
import 'package:insight_hub/constant/routes.dart';
import 'package:insight_hub/constant/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgLightBlue,
              AppColors.bgWhite,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // Icon Circle
                CustomLogo(),
      
                // Title
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
      
                const SizedBox(height: 12),
      
                // Subtitle
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textGray,
                  ),
                  textAlign: TextAlign.center,
                ),
      
                const SizedBox(height: 60),
      
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.registerEmailScreen);
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
      
                const SizedBox(height: 16),
      
                // Login Text Button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.signInScreen);
                  },
                  child: const Text(
                    "Already have an account? Log in",
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
