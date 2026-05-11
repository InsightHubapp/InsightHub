import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/constant/labor_list.dart';
import 'package:InsightHub/core/services/endpoints.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/secure_storege.dart';
import 'package:meta/meta.dart';
import 'package:InsightHub/feature/auth/models/register_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiService _apiService = ApiService();

  RegisterCubit() : super(RegisterInitial());

  String? firstName;
  String? lastName;
  int? gender;
  DateTime? birthDate;
  String? collage;
  bool? isEmployed;
  String? email;
  String? password;
  String? confirmPassword;
  int? trackId;
  int? yearsExperience;

  void saveEmail(String value) {
    email = value;
  }

  void savePassword(String value) {
    password = value;
    confirmPassword = value;
  }

  void saveName(String first, String last) {
    firstName = first;
    lastName = last;
  }

  void saveGender(int value) {
    gender = value;
  }

  void saveBirthDate(DateTime value) {
    birthDate = value;
  }

  void saveCollage(String value) {
    collage = value;
  }

  void saveEmployment(bool value) {
    isEmployed = value;
  }

  void saveLaborInfo(int track, int exp) {
    trackId = track;
    yearsExperience = exp;
  }

  void resetState() {
    emit(RegisterInitial());
  }

  Future<void> submitRegister() async {
    emit(RegisterLoading());

    final model = buildModel();

    try {
      final result = await _apiService.post(
        Endpoints.register,
        data: model.toJson(),
      );

      if (result['success'] == true) {
        final data = result['data'];

        final token =
            data is Map<String, dynamic>
                ? data['token']
                : null;

        if (token != null) {
          await SecureStorage.writeData(
            key: tokenKey,
            value: token.toString(),
          );
        }

        emit(RegisterSuccess(result));
      } else {
        emit(
          RegisterFailure(
            result['error']?.toString() ??
                'Registration failed',
          ),
        );
      }
    } catch (e) {
      emit(RegisterFailure('Unexpected error: $e'));
    }
  }

  Future<void> checkEmailExistence(
    String emailAddress,
  ) async {
    emit(CheckingEmailExistence());

    try {
      final result = await _apiService.post(
        Endpoints.checkEmailExistence,
        data: {
          'email': emailAddress,
        },
      );

      if (result['success'] == true) {
        emit(EmailExists(emailAddress));
      } else {
        emit(EmailDoesNotExist(emailAddress));
      }
    } catch (e) {
      emit(
        RegisterFailure(
          'Error checking email: $e',
        ),
      );
    }
  }

  Future<void> sendOtp(
    String emailAddress,
  ) async {
    emit(OtpSending());

    try {
      final result = await _apiService.post(
        Endpoints.sendOtp,
        data: {
          'email': emailAddress,
        },
      );

      if (result['success'] == true) {
        email = emailAddress;

        emit(OtpSent());
      } else {
        emit(
          OtpSendFailure(
            result['error']?.toString() ??
                'Failed to send OTP',
          ),
        );
      }
    } catch (e) {
      emit(
        OtpSendFailure(
          'Error sending OTP: $e',
        ),
      );
    }
  }

  Future<void> verifyOtp(
    String emailAddress,
    String otpCode,
  ) async {
    emit(OtpVerifying());

    try {
      final result = await _apiService.post(
        Endpoints.verifyOtp,
        data: {
          'email': emailAddress,
          'otp': otpCode,
        },
      );

      if (result['success'] == true) {
        emit(OtpVerified());
      } else {
        emit(
          OtpVerifyFailure(
            result['error']?.toString() ??
                'Invalid OTP code',
          ),
        );
      }
    } catch (e) {
      emit(
        OtpVerifyFailure(
          'Error verifying OTP: $e',
        ),
      );
    }
  }

  RegisterModel buildModel() {
    return RegisterModel(
      firstName: firstName!,
      lastName: lastName!,
      gender: gender!,
      birthDate: birthDate!,
      collage: collage!,
      isEmployed: isEmployed!,
      email: email!,
      password: password!,
      confirmPassword: confirmPassword!,
      trackId: trackId,
      yearsExperience: yearsExperience,
    );
  }

  void reset() {
    firstName = null;
    lastName = null;
    gender = null;
    birthDate = null;
    collage = null;
    isEmployed = null;
    email = null;
    password = null;
    confirmPassword = null;
    trackId = null;
    yearsExperience = null;

    emit(RegisterInitial());
  }
}