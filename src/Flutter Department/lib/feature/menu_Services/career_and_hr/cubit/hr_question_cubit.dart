import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/hr_question_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/hr_quiz_result_model.dart';
import 'package:meta/meta.dart';

@immutable
sealed class HrQuestionState {
  const HrQuestionState();
}

final class HrQuestionInitial extends HrQuestionState {
  const HrQuestionInitial();
}

final class HrQuestionLoading extends HrQuestionState {
  const HrQuestionLoading();
}

final class HrQuestionError extends HrQuestionState {
  final String message;

  const HrQuestionError(this.message);
}

final class HrQuestionLoaded extends HrQuestionState {
  final String category;
  final List<HrQuestionModel> questions;
  final Map<int, int> selectedAnswers;
  final bool isSubmitting;
  final bool didSubmit;
  final String? message;
  final HrQuizResultModel? result;

  const HrQuestionLoaded({
    required this.category,
    required this.questions,
    this.selectedAnswers = const {},
    this.isSubmitting = false,
    this.didSubmit = false,
    this.message,
    this.result,
  });

  bool isAnswered(int questionId) => selectedAnswers.containsKey(questionId);

  bool get canSubmit =>
      questions.isNotEmpty &&
      questions.every((question) => isAnswered(question.id));

  HrQuestionLoaded copyWith({
    String? category,
    List<HrQuestionModel>? questions,
    Map<int, int>? selectedAnswers,
    bool? isSubmitting,
    bool? didSubmit,
    String? message,
    HrQuizResultModel? result,
    bool clearMessage = false,
  }) {
    return HrQuestionLoaded(
      category: category ?? this.category,
      questions: questions ?? this.questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      didSubmit: didSubmit ?? this.didSubmit,
      message: clearMessage ? null : message ?? this.message,
      result: result ?? this.result,
    );
  }
}

class HrQuestionCubit extends Cubit<HrQuestionState> {
  final ApiService _apiService;

  HrQuestionCubit({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const HrQuestionInitial());

  Future<void> fetchQuestions({required String category}) async {
    await fetchQuestionsAsync(category: category);
  }

  Future<bool> fetchQuestionsAsync({required String category}) async {
    if (state is HrQuestionLoading) {
      return false;
    }

    emit(const HrQuestionLoading());

    try {
      final questions = await _apiService.fetchHrQuestions(category: category);
      final supportedQuestions = questions
          .where((question) => question.isSupported && question.answers.isNotEmpty)
          .toList();

      if (supportedQuestions.isEmpty) {
        emit(
          const HrQuestionError(
            'No supported quiz questions are available for this category right now.',
          ),
        );
        return false;
      }

      emit(
        HrQuestionLoaded(
          category: category,
          questions: supportedQuestions,
        ),
      );
      return true;
    } catch (error) {
      emit(HrQuestionError(_messageFrom(error)));
      return false;
    }
  }

  void selectAnswer({
    required int questionId,
    required int answerId,
  }) {
    final currentState = state;
    if (currentState is! HrQuestionLoaded) {
      return;
    }

    final updatedAnswers = Map<int, int>.from(currentState.selectedAnswers)
      ..[questionId] = answerId;

    emit(
      currentState.copyWith(
        selectedAnswers: updatedAnswers,
        didSubmit: false,
        clearMessage: true,
      ),
    );
  }

  Future<void> submitQuiz() async {
    final currentState = state;
    if (currentState is! HrQuestionLoaded) {
      return;
    }

    if (!currentState.canSubmit) {
      emit(
        currentState.copyWith(
          didSubmit: false,
          message: 'Please answer every question before submitting.',
        ),
      );
      return;
    }

    emit(
      currentState.copyWith(
        isSubmitting: true,
        didSubmit: false,
        clearMessage: true,
      ),
    );

    try {
      final result = await _apiService.submitHrAnswers(
        answers: currentState.selectedAnswers,
      );

      emit(
        currentState.copyWith(
          isSubmitting: false,
          didSubmit: true,
          message: 'Quiz submitted successfully.',
          result: result,
        ),
      );
    } catch (error) {
      emit(
        currentState.copyWith(
          isSubmitting: false,
          didSubmit: false,
          message: _messageFrom(error),
        ),
      );
    }
  }

  void reset() {
    emit(const HrQuestionInitial());
  }

  String _messageFrom(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }
}
