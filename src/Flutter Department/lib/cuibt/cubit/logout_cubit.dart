import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/constant/labor_list.dart';
import 'package:InsightHub/core/services/endpoints.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/secure_storege.dart';
import 'package:meta/meta.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final ApiService _apiService = ApiService();

  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await _apiService.post(Endpoints.logout);

      await SecureStorage.deleteData(key: tokenKey);

      emit(LogoutSuccess());
    } catch (e) {
      await SecureStorage.deleteData(key: tokenKey);
      emit(LogoutSuccess());
    }
  }

  Future<void> deleteAccount() async {
    if (state is DeleteAccountLoading) {
      return;
    }

    emit(DeleteAccountLoading());

    try {
      final result = await _apiService.delete(Endpoints.deleteAccount);

      if (result['success'] == true) {
        await SecureStorage.deleteAllData();
        emit(DeleteAccountSuccess());
        return;
      }

      emit(
        DeleteAccountFailure(
          result['error']?.toString() ??
              'Could not delete your account. Please try again.',
        ),
      );
    } catch (_) {
      emit(
        DeleteAccountFailure(
          'Could not delete your account. Please try again.',
        ),
      );
    }
  }
}
