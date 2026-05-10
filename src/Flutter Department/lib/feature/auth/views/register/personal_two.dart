import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/auth/widget/auth_input_decoration.dart';
import 'package:InsightHub/feature/auth/widget/birth_date_picker_field.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';

class RegisterEducationScreen extends StatefulWidget {
  const RegisterEducationScreen({super.key});

  static const String routeName = '/registerEducationScreen';

  @override
  State<RegisterEducationScreen> createState() => _RegisterEducationScreenState();
}

class _RegisterEducationScreenState extends State<RegisterEducationScreen> {
  DateTime? _birthdate;
  final _collegeController = TextEditingController();
  bool _isEmployed = false;

  bool get _isValid => _birthdate != null && _collegeController.text.isNotEmpty;

  void _handleNext() {
    if (!_isValid) return;

    context.read<RegisterCubit>().saveBirthDate(_birthdate!);
    context.read<RegisterCubit>().saveCollage(_collegeController.text);
    context.read<RegisterCubit>().saveEmployment(_isEmployed);

    if (_isEmployed) {
      Navigator.pushNamed(context, Routes.laborInformationScreen);
    } else {
      context.read<RegisterCubit>().saveLaborInfo(0, 0);
      context.read<RegisterCubit>().submitRegister();
      Navigator.pushNamed(context, Routes.confirmationScreen);
    }
  }

  @override
  void dispose() {
    _collegeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Education',
      subtitle: 'Share your academic background.',
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
              const Text('Birthdate'),
              const SizedBox(height: 8),
              BirthDatePickerField(
                value: _birthdate,
                onChanged: (newDate) => setState(() => _birthdate = newDate),
              ),
              const SizedBox(height: 24),
              const Text('College'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _collegeController,
                decoration: authInputDecoration('College name'),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('I am employed', style: TextStyle(fontWeight: FontWeight.w500)),
            value: _isEmployed,
            activeColor: AppColors.primaryBlue,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => setState(() => _isEmployed = val),
          ),
        ],
      ),
    );
  }
}
