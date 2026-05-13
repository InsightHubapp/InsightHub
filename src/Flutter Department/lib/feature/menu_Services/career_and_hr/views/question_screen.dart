import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/question_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/card_question_carrer.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_error_view.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_loading_view.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_navigation_bar.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_progress_header.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_transition_switcher.dart';
import 'package:InsightHub/widget/app_header.dart';
import 'package:InsightHub/widget/app_motion.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  static const String routeName = '/questionScreen';

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;

  late bool isEmployed;
  bool _didLoadQuestions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoadQuestions) {
      isEmployed =
          ModalRoute.of(context)?.settings.arguments as bool? ?? false;

  

      _didLoadQuestions = true;


      final cubit = context.read<QuestionCubit>();
      final current = cubit.state;
      final shouldFetch =
          current is! QuestionLoaded || current.isEmployed != isEmployed;

      if (shouldFetch) {
        _currentIndex = 0;
        cubit.fetchQuestions(isEmployed: isEmployed);
      }
    }
  }

  void _retry() {
    setState(() {
      _currentIndex = 0;
    });

    context.read<QuestionCubit>().fetchQuestions(
      isEmployed: isEmployed,
    );
  }

  void _goToNext(int lastIndex) {
    if (_currentIndex >= lastIndex) {
      return;
    }

    setState(() {
      _currentIndex += 1;
    });
  }

  void _goToPrevious() {
    if (_currentIndex == 0) {
      return;
    }

    setState(() {
      _currentIndex -= 1;
    });
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Survey?'),
            content: const Text(
              'Your progress will be lost. Are you sure you want to leave?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionCubit, QuestionState>(
      listener: (context, state) {
        if (state is QuestionLoaded && state.didSubmitSucceed) {
          if (state.isEmployed) {
            Navigator.pushReplacementNamed(
              context,
              Routes.surveyThankYouScreen,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              Routes.careerResultScreen,
              arguments: state.careerResult,
            );
          }
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _showExitConfirmation(context);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.bgGradient),
            child: SafeArea(
              child: BlocBuilder<QuestionCubit, QuestionState>(
                builder: (context, questionState) {
                  if (questionState is QuestionLoading) {
                    return const QuizLoadingView();
                  }

                  if (questionState is QuestionError) {
                    return QuizErrorView(
                      message: questionState.message,
                      onRetry: _retry,
                    );
                  }

                  if (questionState is! QuestionLoaded) {
                    return const SizedBox.shrink();
                  }

                  final questions = questionState.questions;
                  final currentQuestion = questions[_currentIndex];
                  final isCurrentAnswered = questionState.isAnswered(
                    currentQuestion.id,
                  );
                  final isLastQuestion =
                      _currentIndex == questions.length - 1;

                  return Column(
                    children: [
                      AppHeader(
                        title: 'Question Flow',
                        showBackButton: true,
                        leadingIcon: Icons.close,
                        onBackPress: () async {
                          final shouldPop = await _showExitConfirmation(
                            context,
                          );
                          if (shouldPop && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        extra: QuizProgressHeader(
                          sectionTitle: 'Career Assessment',
                          currentQuestion: _currentIndex + 1,
                          totalQuestions: questions.length,
                        ),
                      ),
                      Expanded(
                        child: AppMotion(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              20,
                              20,
                              16,
                            ),
                            child: Column(
                              children: [
                                QuizTransitionSwitcher(
                                  child: QuestionCard(
                                    key: ValueKey(currentQuestion.id),
                                    question: currentQuestion,
                                    answer: questionState
                                        .answers[currentQuestion.id],
                                    onChanged: (value) {
                                      context
                                          .read<QuestionCubit>()
                                          .answerQuestion(
                                            currentQuestion.id,
                                            value,
                                          );
                                    },
                                  ),
                                ),
                                if ((questionState.validationMessage ?? '')
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: const Color(0xFFFECACA),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              LucideIcons.alertCircle,
                                              color: Color(0xFFDC2626),
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              questionState.validationMessage!,
                                              style: const TextStyle(
                                                color: Color(0xFFB91C1C),
                                                fontWeight: FontWeight.w500,
                                                height: 1.35,
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
                        ),
                      ),
                      QuizNavigationBar(
                        isFirstQuestion: _currentIndex == 0,
                        isLastQuestion: isLastQuestion,
                        canContinue: isCurrentAnswered,
                        isLoading: questionState.isSubmitting,
                        onPrevious: _goToPrevious,
                        onNext: isLastQuestion
                            ? () => context
                                  .read<QuestionCubit>()
                                  .submitAnswers()
                            : () => _goToNext(questions.length - 1),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}