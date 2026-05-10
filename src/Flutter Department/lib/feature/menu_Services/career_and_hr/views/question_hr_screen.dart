import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/hr_question_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/hr_question_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/views/answer_hr_screen.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_error_view.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_loading_view.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_navigation_bar.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_progress_header.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_question_card.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/widget/widgets/quiz/quiz_transition_switcher.dart';
import 'package:InsightHub/widget/app_header.dart';

class QuestionHrScreen extends StatefulWidget {

  final String categoryName;
  
  final String apiCategory;

  const QuestionHrScreen({
    super.key,
    required this.categoryName,
    required this.apiCategory,
  });

  @override
  State<QuestionHrScreen> createState() => _QuestionHrScreenState();
}

class _QuestionHrScreenState extends State<QuestionHrScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _retry() {
    setState(() {
      _currentIndex = 0;
    });

    context.read<HrQuestionCubit>().fetchQuestions(
      category: widget.apiCategory,
    );
  }

  void _goToPrevious() {
    if (_currentIndex == 0) {
      return;
    }

    setState(() {
      _currentIndex -= 1;
    });
  }

  void _goToNext(int lastIndex) {
    if (_currentIndex >= lastIndex) {
      return;
    }

    setState(() {
      _currentIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: BlocConsumer<HrQuestionCubit, HrQuestionState>(
            listener: (context, state) {
              if (state is HrQuestionLoaded &&
                  state.didSubmit &&
                  state.result != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => AnswerHrScreen(
                      categoryName: widget.categoryName,
                      totalQuestions: state.questions.length,
                      result: state.result!,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is HrQuestionLoading || state is HrQuestionInitial) {
                return const QuizLoadingView();
              }

              if (state is HrQuestionError) {
                return QuizErrorView(message: state.message, onRetry: _retry);
              }

              if (state is! HrQuestionLoaded) {
                return const SizedBox.shrink();
              }

              final questions = state.questions;
              final question = questions[_currentIndex];
              final selectedAnswerId = state.selectedAnswers[question.id];
              final isLastQuestion = _currentIndex == questions.length - 1;
              final isAnswered = state.isAnswered(question.id);

              return Column(
                children: [
                  AppHeader(
                    title: '${widget.categoryName} Quiz',
                    showBackButton: true,
                    extra: QuizProgressHeader(
                      sectionTitle: widget.categoryName,
                      currentQuestion: _currentIndex + 1,
                      totalQuestions: questions.length,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        children: [
                          QuizTransitionSwitcher(
                            child: _HrQuestionCard(
                              key: ValueKey(question.id),
                              question: question,
                              selectedAnswerId: selectedAnswerId,
                              onSelect: (answerId) {
                                context.read<HrQuestionCubit>().selectAnswer(
                                  questionId: question.id,
                                  answerId: answerId,
                                );
                              },
                            ),
                          ),
                          if ((state.message ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFFED7AA),
                                  ),
                                ),
                                child: Text(
                                  state.message!,
                                  style: const TextStyle(
                                    color: Color(0xFF9A3412),
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  QuizNavigationBar(
                    isFirstQuestion: _currentIndex == 0,
                    isLastQuestion: isLastQuestion,
                    canContinue: isAnswered,
                    isLoading: state.isSubmitting,
                    onPrevious: _goToPrevious,
                    onNext: isLastQuestion
                        ? () => context.read<HrQuestionCubit>().submitQuiz()
                        : () => _goToNext(questions.length - 1),
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

class _HrQuestionCard extends StatelessWidget {
  final HrQuestionModel question;
  final int? selectedAnswerId;
  final ValueChanged<int> onSelect;

  const _HrQuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswerId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = question.type == HrQuestionType.trueFalse
        ? 'True / False'
        : 'Multiple Choice';

    return QuizQuestionCard(
      questionText: question.question,
      typeLabel: typeLabel,
      selectedValue: selectedAnswerId,
      onSelected: onSelect,
      options: question.answers
          .map(
            (answer) => QuizAnswerOption(text: answer.option, value: answer.id),
          )
          .toList(),
    );
  }
}
