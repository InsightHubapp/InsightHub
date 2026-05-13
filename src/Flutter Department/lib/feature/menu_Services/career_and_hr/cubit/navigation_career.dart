import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/navigation_career_model.dart';
import 'package:InsightHub/model/app_error.dart';
import 'package:meta/meta.dart';

enum NavigationTarget { questions, result, thankYou }

@immutable
sealed class NavigationState {
  const NavigationState();
}

final class NavigationInitial extends NavigationState {
  const NavigationInitial();
}
final class NavigationLoading extends NavigationState {
  const NavigationLoading();
}

final class NavigationSuccess extends NavigationState {
  final NavigationTarget target;
  final bool isEmployed;
  
  const NavigationSuccess(
    this.target,
    this.isEmployed,
  );
}

final class NavigationError extends NavigationState {
  final String message;
  const NavigationError(this.message);
}

class NavigationCubit extends Cubit<NavigationState> {
  final ApiService api;

  NavigationCubit(this.api) : super(const NavigationInitial());

  Future<void> decide() async {
    await decideAsync();
  }

  Future<NavigationSuccess?> decideAsync() async {
    emit(const NavigationLoading());

    try {
      final status = await api.fetchNavigationStatus();

      final target = _computeTarget(status);
      
      final successState = NavigationSuccess(target, status.isEmployed);
      emit(successState);
      return successState;
    } catch (error) {
      emit(NavigationError(_errorMessage(error)));
      return null;
    }
  }

  NavigationTarget _computeTarget(NavigationStatus status) {
    if (!status.hasCompletedAssessment) {
      return NavigationTarget.questions;
    }

    if (status.isEmployed) {
      return NavigationTarget.thankYou;
    }

    return NavigationTarget.result;
  }

  String _errorMessage(Object error) {
    if (error is AppError) {
      return error.getErrorMessage();
    }

    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }
}
