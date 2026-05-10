import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight_hub/constant/labor_list.dart';
import 'package:insight_hub/constant/routes.dart';
import 'package:insight_hub/constant/app_colors.dart';
import 'package:insight_hub/widget/card_container.dart';
import 'package:insight_hub/cuibt/cubit/register_cubit.dart';
import 'package:insight_hub/model/jop_year.dart';

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
      final selectedJobs = [SelectedJob(jobId: selectedJob!, yearsExperience: selectedExperience!)];
      context.read<RegisterCubit>().saveJobs(selectedJobs);
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
        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackButton()
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Labor Information",
                    style: TextStyle(

                      fontSize: 30,
                      
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Tell us about your job interests and experience",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 32),

                  CardContainer(
                    children: [

                      /// JOBS
                      const Text(
                        "Jobs to follow",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        value: selectedJob,
                        decoration: InputDecoration(
                          hintText: "Select job",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: jobs.map((job) {
                          return DropdownMenuItem<int>(
                            value: job["id"],
                            child: Text(job["name"]),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedJob = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      /// EXPERIENCE
                      const Text(
                        "Years of experience",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedExperience,
                        decoration: InputDecoration(
                          hintText: "Select years",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: experienceYears.map((year) {
                          return DropdownMenuItem<int>(
                            value: year["value"],
                            child: Text(year["text"]),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedExperience = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  /// NEXT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (isValid && !isLoading)
                          ? _handleNext
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}