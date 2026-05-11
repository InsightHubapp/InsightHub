import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:meta/meta.dart';


@immutable
sealed class CareerResultState {
  const CareerResultState();
}

final class CareerResultInitial extends CareerResultState {
  const CareerResultInitial();
}

final class CareerResultLoading extends CareerResultState {
  const CareerResultLoading();
}

final class CareerResultLoaded extends CareerResultState {
  final CareerQuizResultModel result;

  const CareerResultLoaded(this.result);
}

final class CareerResultError extends CareerResultState {
  final String message;
  const CareerResultError(this.message);
}

class CareerResultCubit extends Cubit<CareerResultState> {
  final ApiService _apiService;

  CareerResultCubit({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const CareerResultInitial());

  void setResult(CareerQuizResultModel result) {
    emit(CareerResultLoaded(result));
  }

  Future<void> fetchLatest() async {
    emit(const CareerResultLoading());
    try {
      final result = await _apiService.fetchCareerQuizResult();
      if (result == null) {
        throw Exception('No career quiz result found. Please complete the quiz.');
      }
      emit(CareerResultLoaded(result));
    } catch (e) {
      emit(CareerResultError(_errorMessage(e)));
    }
  }

  void reset() => emit(const CareerResultInitial());

  String _errorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}

