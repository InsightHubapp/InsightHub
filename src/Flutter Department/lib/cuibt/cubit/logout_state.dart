part of 'logout_cubit.dart';

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutLoading extends LogoutState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutFailure extends LogoutState {
  final String errorMessage;

  LogoutFailure(this.errorMessage);
}

final class DeleteAccountLoading extends LogoutState {}

final class DeleteAccountSuccess extends LogoutState {}

final class DeleteAccountFailure extends LogoutState {
  final String errorMessage;

  DeleteAccountFailure(this.errorMessage);
}
