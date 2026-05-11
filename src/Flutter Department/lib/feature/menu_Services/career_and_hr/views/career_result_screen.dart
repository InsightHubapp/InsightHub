import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/career_result_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/views/question_screen.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/track_recommendation_card.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/career_result/widgets/career_match_summary_section.dart';
import 'package:InsightHub/widget/app_header.dart';

class CareerResultScreen extends StatefulWidget {
  const CareerResultScreen({super.key});

  static const String routeName = Routes.careerResultScreen;

  @override
  State<CareerResultScreen> createState() => _CareerResultScreenState();
}

class _CareerResultScreenState extends State<CareerResultScreen> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final arg = ModalRoute.of(context)?.settings.arguments;
    final cubit = context.read<CareerResultCubit>();

    if (arg is CareerQuizResultModel) {
      cubit.setResult(arg);
    } else {
      cubit.fetchLatest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: BlocBuilder<CareerResultCubit, CareerResultState>(
            builder: (context, state) {
              if (state is CareerResultLoading || state is CareerResultInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CareerResultError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Could not load career result.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF475569)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              QuestionScreen.routeName,
                              arguments: false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retake quiz'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final result = (state as CareerResultLoaded).result;

              return Column(
                children: [
                  AppHeader(
                    title: 'Career Insights',
                    subtitle: result.message.isEmpty
                        ? 'Your best career matches based on your answers.'
                        : result.message,
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.homeScreen,
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                          sliver: SliverToBoxAdapter(
                            child: CareerMatchSummarySection(result: result),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                          sliver: SliverList.separated(
                            itemBuilder: (context, index) {
                              final track = result.topTracks[index];
                              return TrackRecommendationCard(
                                rank: index + 1,
                                trackMatch: track,
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemCount: result.topTracks.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        QuestionScreen.routeName,
                                        arguments: false,
                                      );
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retake'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.homeScreen,
                                        (route) => false,
                                      );
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text('Finish'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryBlue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

