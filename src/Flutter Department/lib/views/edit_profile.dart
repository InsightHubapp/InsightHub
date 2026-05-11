import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/labor_list.dart';
import 'package:InsightHub/cuibt/cubit/profile_cubit.dart';
import 'package:InsightHub/feature/auth/widget/auth_input_decoration.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/birth_date_picker_field.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';
import 'package:InsightHub/model/profile_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _collegeController = TextEditingController();

  int? selectedGender;
  DateTime? selectedBirthDate;
  bool isEmployed = false;
  int? selectedJob;
  int? selectedExperience;
  int? _lastSelectedJob;
  int? _lastSelectedExperience;
  bool _didPrefill = false;
  
  late bool _previouslyEmployed;
  bool _shouldPreserveExperience = false;

  bool get isValid {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _collegeController.text.trim().isNotEmpty &&
        selectedGender != null &&
        selectedBirthDate != null &&
        (!(isEmployed || _shouldPreserveExperience) || (selectedJob != null && selectedExperience != null));
  }

  void _prefill(ProfileModel profile) {
    if (_didPrefill) return;

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _collegeController.text = profile.collage;
    selectedGender = profile.gender == 1 || profile.gender == 2
        ? profile.gender
        : null;
    selectedBirthDate = profile.birthDate;
    isEmployed = profile.isEmployed;
    _previouslyEmployed = profile.isEmployed;
    
    if (isEmployed) {
      selectedJob = _jobIdForTrackName(profile.trackName);
      selectedExperience = experienceYears.any(
        (year) => year['value'] == profile.yearsExperience,
      )
          ? profile.yearsExperience
          : null;
      _lastSelectedJob = selectedJob;
      _lastSelectedExperience = selectedExperience;
      _shouldPreserveExperience = false;
    } else {
      selectedJob = null;
      selectedExperience = null;
      _shouldPreserveExperience = false;
    }
    _didPrefill = true;
  }

  int? _jobIdForTrackName(String trackName) {
    final normalizedTrack = _normalizeTrackName(trackName);
    if (normalizedTrack.isEmpty) return null;

    for (final job in jobs) {
      final name = _normalizeTrackName(job['name']?.toString() ?? '');
      if (name == normalizedTrack) {
        return job['id'] as int;
      }
    }

    return null;
  }

  String _normalizeTrackName(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  String _selectedTrackName() {
    return jobs
        .firstWhere((job) => job['id'] == selectedJob)['name']
        .toString();
  }

  Future<void> _handleEmployeeToNonEmployee() async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Employment Status Change'),
          content: const Text(
            'Did you previously work in this field but leave your job?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (shouldContinue == true) {
      setState(() {
        isEmployed = false;
        _shouldPreserveExperience = true;
        _previouslyEmployed = false;
      });
    } else if (shouldContinue == false) {
      _handleEmployeeToNonEmployeeSecondDialog();
    }
  }

  Future<void> _handleEmployeeToNonEmployeeSecondDialog() async {
    final wasAccidental = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Status Change'),
          content: const Text(
            'Did you accidentally choose employee from the beginning?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (wasAccidental == true) {
      setState(() {
        isEmployed = false;
        _shouldPreserveExperience = false;
        selectedJob = null;
        selectedExperience = null;
        _lastSelectedJob = null;
        _lastSelectedExperience = null;
        _previouslyEmployed = false;
      });
    } else if (wasAccidental == false) {
      setState(() {
        isEmployed = true;
        _previouslyEmployed = true;
      });
    }
  }

  Future<void> _handleNonEmployeeToEmployee() async {
    final wasAccidental = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Employment Status Change'),
          content: const Text(
            'Did you previously want to become an employee but selected '
            'non-employee by mistake?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (wasAccidental == true) {
      _handleNonEmployeeToEmployeeSecondDialog();
    } else if (wasAccidental == false) {
      setState(() {
        isEmployed = false;
        _previouslyEmployed = false;
      });
    }
  }

  Future<void> _handleNonEmployeeToEmployeeSecondDialog() async {
    final hasExperience = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Work Experience Required'),
          content: const Text(
            'Do you actually have work experience in this field?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (hasExperience == true) {
      setState(() {
        isEmployed = true;
        _shouldPreserveExperience = false;
        _previouslyEmployed = false;
      });
    } else if (hasExperience == false) {
      setState(() {
        isEmployed = false;
        _previouslyEmployed = false;
        selectedJob = null;
        selectedExperience = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Employee status requires work experience. Please select '
              'non-employee.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleEmploymentStatusChange(bool newValue) async {
    if (newValue == isEmployed) return; 

    if (_previouslyEmployed && !newValue) {
      _handleEmployeeToNonEmployee();
    } else if (!_previouslyEmployed && newValue) {
      _handleNonEmployeeToEmployee();
    } else {
      setState(() {
        isEmployed = newValue;
        if (!isEmployed) {
          _lastSelectedJob = selectedJob;
          _lastSelectedExperience = selectedExperience;
          selectedJob = null;
          selectedExperience = null;
        }
      });
    }
  }

  void _handleSave() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate() || !isValid) return;

    if (!(isEmployed || _shouldPreserveExperience)) {
      selectedExperience = 0;
      selectedJob = null;
    }

    final trackNameToSend = (isEmployed || _shouldPreserveExperience) 
        ? _selectedTrackName() 
        : '';
    
    final yearsExperienceToSend = (isEmployed || _shouldPreserveExperience) 
        ? selectedExperience 
        : 0;

    context.read<ProfileCubit>().updateProfile(
          profileJson: {
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'gender': selectedGender!,
            'birthDate': selectedBirthDate!.toUtc().toIso8601String(),
            'collage': _collegeController.text.trim(),
            'isEmployed': isEmployed,
            'yearsExperience': yearsExperienceToSend,
            'trackName': trackNameToSend,
          },
        );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _collegeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully.')),
          );
          Navigator.pop(context);
        } else if (state is ProfileUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final profile = switch (state) {
          ProfileSuccess(:final profile) => profile,
          ProfileUpdateLoading(:final profile) => profile,
          ProfileUpdateFailure(:final profile) => profile,
          ProfileUpdateSuccess(:final profile) => profile,
          _ => null,
        };

        if (profile == null) {
          return AuthLayout(
            title: 'Edit Profile',
            subtitle: 'Update your profile information.',
            action: BottomActionButton(
              label: 'Save',
              enabled: false,
              onPressed: null,
            ),
            child: Skeletonizer(
              enabled: true,
              child: CardContainer(
                children: [
                  const Text('First Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: 'Loading',
                    decoration: authInputDecoration('First name'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Last Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: 'Loading',
                    decoration: authInputDecoration('Last name'),
                  ),
                  const SizedBox(height: 16),
                  const Text('College'),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: 'Loading',
                    decoration: authInputDecoration('College name'),
                  ),
                ],
              ),
            ),
          );
        }

        _prefill(profile);

        final isLoading = state is ProfileUpdateLoading;

        return AuthLayout(
          title: 'Edit Profile',
          subtitle: 'Update your profile information.',
          action: BottomActionButton(
            label: 'Save',
            enabled: isValid && !isLoading,
            isLoading: isLoading,
            onPressed: (isValid && !isLoading) ? _handleSave : null,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardContainer(
                  children: [
                    const Text('First Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _firstNameController,
                      enabled: !isLoading,
                      decoration: authInputDecoration('First name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required.';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    const Text('Last Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameController,
                      enabled: !isLoading,
                      decoration: authInputDecoration('Last name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required.';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CardContainer(
                  children: [
                    const Text('Gender'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: selectedGender,
                      decoration: authInputDecoration('Select gender'),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Male')),
                        DropdownMenuItem(value: 2, child: Text('Female')),
                      ],
                      validator: (value) {
                        if (value == null) return 'Gender is required.';
                        return null;
                      },
                      onChanged: isLoading
                          ? null
                          : (value) => setState(() => selectedGender = value),
                    ),
                    const SizedBox(height: 24),
                    const Text('Birthdate'),
                    const SizedBox(height: 8),
                    BirthDatePickerField(
                      value: selectedBirthDate,
                      enabled: !isLoading,
                      onChanged: (newDate) =>
                          setState(() => selectedBirthDate = newDate),
                    ),
                    const SizedBox(height: 24),
                    const Text('College'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _collegeController,
                      enabled: !isLoading,
                      decoration: authInputDecoration('College name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'College is required.';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CardContainer(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'I am employed',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      value: isEmployed,
                      activeColor: AppColors.primaryBlue,
                      contentPadding: EdgeInsets.zero,
                      onChanged: isLoading
                          ? null
                          : (value) => _handleEmploymentStatusChange(value),
                    ),
                    if (isEmployed || _shouldPreserveExperience) ...[
                      const SizedBox(height: 12),
                      const Text('Jobs to follow'),
                      const SizedBox(height: 6),
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
                        validator: (value) {
                          if ((isEmployed || _shouldPreserveExperience) && value == null) {
                            return 'Job track is required.';
                          }
                          return null;
                        },
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  selectedJob = value;
                                  _lastSelectedJob = value;
                                });
                              },
                      ),
                      const SizedBox(height: 12),
                      const Text('Years of experience'),
                      const SizedBox(height: 6),
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
                        validator: (value) {
                          if ((isEmployed || _shouldPreserveExperience) && value == null) {
                            return 'Years of experience is required.';
                          }
                          return null;
                        },
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  selectedExperience = value;
                                  _lastSelectedExperience = value;
                                });
                              },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
