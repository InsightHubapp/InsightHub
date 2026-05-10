import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/auth/widget/auth_input_decoration.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';

class RegisterNameScreen extends StatefulWidget {
  const RegisterNameScreen({super.key});

  static const String routeName = '/registerNameScreen';

  @override
  State<RegisterNameScreen> createState() => _RegisterNameScreenState();
}

class _RegisterNameScreenState extends State<RegisterNameScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _selectedGender;

  bool get _isValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _selectedGender != null;

  void _handleNext() {
    if (!_isValid) return;

    context.read<RegisterCubit>().saveName(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        );
    final genderInt = _selectedGender == 'Male' ? 1 : 2;
    context.read<RegisterCubit>().saveGender(genderInt);
    Navigator.pushNamed(context, Routes.registerEducationScreen);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Personal Information',
      subtitle: 'Tell us about yourself.',
      action: BottomActionButton(
        label: 'Next',
        enabled: _isValid,
        onPressed: _isValid ? _handleNext : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardContainer(
            children: [
              const Text('First Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: authInputDecoration('John'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              const Text('Last Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: authInputDecoration('Doe'),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CardContainer(
            children: [
              const Text('Gender'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: authInputDecoration('Select gender'),
                items: ['Male', 'Female']
                    .map(
                      (gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

