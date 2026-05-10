import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/hr_question_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/cuibt/cubit/logout_cubit.dart';
import 'package:InsightHub/cuibt/cubit/profile_cubit.dart';
import 'package:InsightHub/feature/auth/cubit/login_cubit.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/dashboard_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/search_dashboard_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/match_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/question_cubit.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/jobs_cubit.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/news_cubit.dart';
import 'package:InsightHub/model/profile_model.dart';
import 'package:InsightHub/widget/app_header.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();

    if (cubit.state is! ProfileSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        cubit.fetchProfile();
      });
    }
  }

  String _initialFrom(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }

  String _fullName(ProfileModel profile) {
    final name = '${profile.firstName} ${profile.lastName}'.trim();
    return name.isEmpty ? 'Guest User' : name;
  }

  String _email(ProfileModel profile) {
    return profile.email.trim().isEmpty ? 'No email available' : profile.email;
  }

  void _clearSessionState() {
    context.read<ProfileCubit>().reset();
    context.read<MatchCubit>().reset();
    context.read<QuestionCubit>().reset();
    context.read<HrQuestionCubit>().reset();
    context.read<LoginCubit>().reset();
    context.read<RegisterCubit>().reset();
    context.read<DashboardCubit>().reset();
    context.read<SearchDashboardCubit>().reset();
    context.read<NewsCubit>().reset();
    context.read<JobsCubit>().reset();
  }

  void _goToSignIn() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.signInScreen,
      (route) => false,
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This permanently deletes your account and signs you out of this device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      context.read<LogoutCubit>().deleteAccount();
    }
  }

  List<Map<String, String>> _profileItems(ProfileModel profile) {
    String jobText = profile.trackName.trim();
    if (jobText.isNotEmpty && profile.yearsExperience != null) {
      final suffix = profile.yearsExperience == 1 ? 'year' : 'years';
      jobText = '$jobText (${profile.yearsExperience} $suffix)';
    }

    return [
      {
        'label': 'College',
        'value': profile.collage.trim().isEmpty ? 'Not set' : profile.collage,
      },
      {
        'label': 'Birthdate',
        'value': profile.birthDate == null
            ? 'Not set'
            : DateFormat('MMMM dd, yyyy').format(profile.birthDate!),
      },
      {
        'label': 'Employment Status',
        'value': profile.isEmployed ? 'Employed' : 'Not Employed',
      },
      {'label': 'Job', 'value': jobText.isEmpty ? 'Not set' : jobText},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final logoutCubit = context.read<LogoutCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess || state is DeleteAccountSuccess) {
              _clearSessionState();
              _goToSignIn();
            } else if (state is LogoutFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is DeleteAccountFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.bgGradient, // 👈 هنا
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: "Profile",
                  subtitle: "Manage your account information",
                ),
                Expanded(
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final bool isLoading = state is ProfileLoading || state is ProfileInitial;

                      if (!isLoading && state is! ProfileSuccess) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Unable to load profile right now.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<ProfileCubit>().fetchProfile();
                                  },
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final profile = isLoading ? ProfileModel.dummy() : (state as ProfileSuccess).profile;
                      final fullName = _fullName(profile);
                      final email = _email(profile);
                      final avatarInitials =
                          '${_initialFrom(profile.firstName)}${_initialFrom(profile.lastName)}';
                      final profileItems = _profileItems(profile);

                      return Skeletonizer(
                        enabled: isLoading,
                        child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        avatarInitials,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...profileItems.map(
                                    (item) => _buildInfoRow(
                                      icon: _iconForLabel(item['label']!),
                                      label: item['label']!,
                                      value: item['value']!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<LogoutCubit, LogoutState>(
                              builder: (context, logoutState) {
                                final isDeleting =
                                    logoutState is DeleteAccountLoading;
                                final isLoggingOut =
                                    logoutState is LogoutLoading;

                                final settingsItems = [
                                  _SettingsItem(
                                    icon: LucideIcons.refreshCw,
                                    label: 'Refresh Profile',
                                    action: isDeleting || isLoggingOut
                                        ? null
                                        : () => context
                                              .read<ProfileCubit>()
                                              .fetchProfile(forceRefresh: true),
                                  ),
                                  _SettingsItem(
                                    icon: LucideIcons.edit3,
                                    label: 'Edit Profile',
                                    action: isDeleting || isLoggingOut
                                        ? null
                                        : () => Navigator.pushNamed(
                                            context,
                                            Routes.editProfileScreen,
                                          ),
                                  ),
                                  _SettingsItem(
                                    icon: LucideIcons.trash2,
                                    label: isDeleting
                                        ? 'Deleting Account...'
                                        : 'Delete Account',
                                    action: isDeleting
                                        ? null
                                        : _confirmDeleteAccount,
                                    isDestructive: true,
                                    isLoading: isDeleting,
                                  ),
                                  _SettingsItem(
                                    icon: LucideIcons.logOut,
                                    label: isLoggingOut
                                        ? 'Logging Out...'
                                        : 'Log Out',
                                    action: isDeleting || isLoggingOut
                                        ? null
                                        : () => logoutCubit.logout(),
                                    isDestructive: true,
                                    isLoading: isLoggingOut,
                                  ),
                                ];

                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Column(
                                    children: settingsItems
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => _buildSettingsRow(
                                            item: entry.value,
                                            showDivider:
                                                entry.key !=
                                                settingsItems.length - 1,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                children: [
                                  Text(
                                    'InsightHub v1.0.0',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Copyright 2026 InsightHub. All rights reserved.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required _SettingsItem item,
    required bool showDivider,
  }) {
    final itemColor = item.isDestructive ? Colors.red : const Color(0xFF111827);
    final disabled = item.action == null;

    return InkWell(
      onTap: item.action,
      child: Opacity(
        opacity: disabled && !item.isLoading ? 0.55 : 1,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))
                : null,
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: itemColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 16,
                    color: itemColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (item.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: itemColor,
                  ),
                )
              else
                const Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: Color(0xFF9CA3AF),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    switch (label) {
      case 'Username':
        return LucideIcons.atSign;
      case 'College':
        return LucideIcons.graduationCap;
      case 'Birthdate':
        return LucideIcons.calendar;
      case 'Employment Status':
        return LucideIcons.award;
      case 'Job':
        return LucideIcons.briefcase;
      default:
        return LucideIcons.user;
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final VoidCallback? action;
  final bool isDestructive;
  final bool isLoading;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.action,
    this.isDestructive = false,
    this.isLoading = false,
  });
}
