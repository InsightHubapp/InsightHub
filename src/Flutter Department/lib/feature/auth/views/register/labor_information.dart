import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/labor_list.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/auth/widget/auth_input_decoration.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';

class LaborInformationScreen extends StatefulWidget {
  const LaborInformationScreen({super.key});
  static const String routeName = '/laborInformationScreen';

  @override
  State<LaborInformationScreen> createState() => _LaborInformationScreenState();
}

class _LaborInformationScreenState extends State<LaborInformationScreen> {
  int? selectedJob;
  int? selectedExperience;

  bool get isValid => selectedJob != null && selectedExperience != null;

  void _handleNext() {
    if (isValid) {
      context.read<RegisterCubit>().saveLaborInfo(
        selectedJob!,
        selectedExperience!,
      );
      context.read<RegisterCubit>().submitRegister();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushNamed(context, Routes.confirmationScreen);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        return AuthLayout(
          title: 'Labor Information',
          subtitle: 'Select your job track and experience.',
          action: BottomActionButton(
            label: 'Next',
            enabled: isValid && !isLoading,
            isLoading: isLoading,
            onPressed: (isValid && !isLoading) ? _handleNext : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardContainer(
                children: [
                  const Text('Jobs to follow'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedJob,
                    decoration: authInputDecoration('Select job'),
                    items: jobs
                        .map(
                          (job) => DropdownMenuItem<int>(
                            value: job['id'] as int,
                            child: Text(job['name'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedJob = value),
                  ),
                  const SizedBox(height: 24),
                  const Text('Years of experience'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedExperience,
                    decoration: authInputDecoration('Select years'),
                    items: experienceYears
                        .map(
                          (year) => DropdownMenuItem<int>(
                            value: year['value'] as int,
                            child: Text(year['text'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedExperience = value),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
