import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/navigation_career.dart';
import 'package:InsightHub/feature/menu_Services/widget/card_services.dart';
import 'package:InsightHub/widget/app_header.dart';
import 'package:InsightHub/widget/app_motion.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/question_cubit.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SurveyMenuScreen extends StatefulWidget {
  const SurveyMenuScreen({super.key});

  @override
  State<SurveyMenuScreen> createState() => _SurveyMenuScreenState();
}

class _SurveyMenuScreenState extends State<SurveyMenuScreen> {
  bool _isFetchingQuestions = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(ApiService()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NavigationCubit, NavigationState>(
            listener: (context, state) {
              if (state is NavigationError) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<QuestionCubit, QuestionState>(
            listener: (context, state) {
              if (state is QuestionError) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.bgLightGray,
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.bgGradient),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(
                    title: 'Services Hub',
                    subtitle: 'Empowering your next professional breakthrough.',
                  ),
                  Expanded(
                    child: AppMotion(
                      child: Builder(
                        builder: (innerContext) => ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          children: [
                          BlocBuilder<NavigationCubit, NavigationState>(
                            builder: (context, navState) {
                              final isLoading = navState is NavigationLoading || _isFetchingQuestions;
                              return buildSurveyCard(
                                innerContext,
                                title: 'Career Assessment',
                                subtitle:
                                    'Let our algorithm suggest the best careers for you.',
                                icon: LucideIcons.briefcase,
                                isActive: true,
                                isLoading: isLoading,
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isFetchingQuestions = true;
                                        });
                                        
                                        final navCubit = innerContext.read<NavigationCubit>();
                                        final navResult = await navCubit.decideAsync();
                                        
                                        if (!innerContext.mounted) return;
                                        
                                        if (navResult != null) {
                                          switch (navResult.target) {
                                            case NavigationTarget.questions:
                                              final success = await innerContext.read<QuestionCubit>().fetchQuestionsAsync(isEmployed: navResult.isEmployed);
                                              if (success && innerContext.mounted) {
                                                Navigator.pushNamed(
                                                  innerContext,
                                                  Routes.questionScreen,
                                                  arguments: navResult.isEmployed,
                                                );
                                              }
                                              break;
                                            case NavigationTarget.result:
                                              Navigator.pushNamed(innerContext, Routes.matchScreen);
                                              break;
                                            case NavigationTarget.thankYou:
                                              Navigator.pushNamed(innerContext, Routes.surveyThankYouScreen);
                                              break;
                                          }
                                        }

                                        if (mounted) {
                                          setState(() {
                                            _isFetchingQuestions = false;
                                          });
                                        }
                                      },
                              );
                            },
                          ),
                            const SizedBox(height: 16),
                            buildSurveyCard(
                              innerContext,
                              title: 'News ',
                              subtitle:
                                  ' Fresh drops and market updates.',
                              icon: LucideIcons.clipboardCheck,
                              isActive: true,
                              onTap: () {
                                Navigator.pushNamed(innerContext, Routes.newsScreen);
                              },
                            ),
                            const SizedBox(height: 16),
                            buildSurveyCard(
                              innerContext,
                              title: 'Job  ',
                              subtitle: 'Discover our real-time job feed.',
                              icon: LucideIcons.home,
                              isActive: true,
                              onTap: () {
                                Navigator.pushNamed(innerContext, Routes.jobScreen);
                              },
                            ),
                            const SizedBox(height: 16),
                            buildSurveyCard(
                              innerContext,
                              title: 'Tech Interview Prep',
                              subtitle:
                                  'Simulate technical rounds with verified engineering,',
                              icon: LucideIcons.users,
                              isActive: true,
                              onTap: () {
                                Navigator.pushNamed(
                                  innerContext,
                                  Routes.menuHrCategoriesScreen,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
