import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:meta/meta.dart';

@immutable
sealed class MatchState {
  const MatchState();
}

final class MatchInitial extends MatchState {
  const MatchInitial();
}

final class MatchLoading extends MatchState {
  const MatchLoading();
}

final class MatchLoaded extends MatchState {
  final dynamic result;

  const MatchLoaded(this.result);
}

final class MatchError extends MatchState {
  final String message;

  const MatchError(this.message);
}

class MatchCubit extends Cubit<MatchState> {
  final ApiService _apiService;

  MatchCubit({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const MatchInitial());

  void reset() {
    emit(const MatchInitial());
  }

  /// تستخدم لما تكون النتيجة جاية من submit (زي QuestionScreen)
  void emitResult(dynamic result) {
    emit(MatchLoaded(result));
  }

  /// تستخدم لما تحتاج تجيب النتيجة من السيرفر مباشرة
  Future<void> fetchResult() async {
    emit(const MatchLoading());

    try {
      final result = await _apiService.fetchCareerQuizResult();

      if (result == null) {
        throw Exception('No results found. Please complete the quiz.');
      }

      emit(MatchLoaded(result));
    } catch (error) {
      emit(MatchError(_errorMessage(error)));
    }
  }

  String _errorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}