import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/constant/labor_list.dart';
import 'package:InsightHub/core/services/endpoints.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/secure_storege.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiService _apiService = ApiService();

  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final result = await _apiService.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );

      if (result['success'] == true) {
        final data = result['data'];
        final token = data is Map<String, dynamic> ? data['token'] : null;
        if (token != null) {
          await SecureStorage.writeData(key: tokenKey, value: token.toString());
        }

        emit(LoginSuccess(result));
      } else {
        emit(LoginFailure(result['error']?.toString() ?? 'Login failed'));
      }
    } catch (e) {
      emit(LoginFailure('Unexpected error'));
    }
  }

  void reset() {
    emit(LoginInitial());
  }
}
