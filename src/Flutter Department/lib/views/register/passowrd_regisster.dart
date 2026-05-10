import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:insight_hub/constant/routes.dart';
import 'package:insight_hub/cuibt/cubit/register_cubit.dart';
import 'package:insight_hub/widget/card_container.dart';
import 'package:insight_hub/widget/next_button.dart'; 

class RegisterPasswordScreen extends StatefulWidget {
  const RegisterPasswordScreen({super.key});
//make routname
  static const String routeName = '/registerPasswordScreen';
 
  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  // Validation Logic
bool get isPasswordValid {
  final pass = _passwordController.text;
  return pass.length >= 8 &&
         pass.contains(RegExp(r'\d')) &&
         pass.contains(RegExp(r'[A-Z]'));
}
  bool get passwordsMatch {
    final pass = _passwordController.text;
    final confirm = _confirmController.text;
    return pass == confirm && confirm.isNotEmpty;
  }

  void _handleNext() {
    if (isPasswordValid && passwordsMatch) {
      context.read<RegisterCubit>().savePassword(_passwordController.text);
      Navigator.pushNamed(context, Routes.registerNameScreen);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton()
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Set your password',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create a secure password for your account',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      CardContainer(
                        children: [
                          // Password Field
                          _buildLabel("Password"),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            onChanged: (_) => setState(() {}),
                            decoration: _inputDecoration(
                              hint: "Enter password",
                              isVisible: _showPassword,
                              onToggle: () => setState(() => _showPassword = !_showPassword),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
                            child: Text(
                              "Min 8 characters, at least one number, and one uppercase letter",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),

                          // Confirm Password Field
                          _buildLabel("Confirm Password"),
                          TextField(
                            controller: _confirmController,
                            obscureText: !_showConfirmPassword,
                            onChanged: (_) => setState(() {}),
                            decoration: _inputDecoration(
                              hint: "Confirm password",
                              isVisible: _showConfirmPassword,
                              onToggle: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Next Button - Fixed at bottom
              NextButton(
                onPressed: (isPasswordValid && passwordsMatch) ? _handleNext : null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build the Input Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Helper for consistent Input Decoration
  InputDecoration _inputDecoration({required String hint, required bool isVisible, required VoidCallback onToggle}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
      suffixIcon: IconButton(
        icon: Icon(isVisible ?LucideIcons.eye :  LucideIcons.eyeOff, size: 20),
        onPressed: onToggle,
      ),
    );
  }
}