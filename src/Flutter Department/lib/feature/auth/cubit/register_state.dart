part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}
final class RegisterLoading extends RegisterState {}
final class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> data;
  RegisterSuccess(this.data);
}
final class RegisterFailure extends RegisterState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}

// OTP States
final class OtpSending extends RegisterState {}
final class OtpSent extends RegisterState {}
final class OtpSendFailure extends RegisterState {
  final String errorMessage;
  OtpSendFailure(this.errorMessage);
}
final class OtpVerifying extends RegisterState {}
final class OtpVerified extends RegisterState {}
final class OtpVerifyFailure extends RegisterState {
  final String errorMessage;
  OtpVerifyFailure(this.errorMessage);
}

// Email Existence Check States
final class CheckingEmailExistence extends RegisterState {}
final class EmailExists extends RegisterState {
  final String email;
  EmailExists(this.email);
}
final class EmailDoesNotExist extends RegisterState {
  final String email;
  EmailDoesNotExist(this.email);
}




















