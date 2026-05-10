part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final ProfileModel profile;

  const ProfileSuccess(this.profile);
}

final class ProfileUpdateLoading extends ProfileState {
  final ProfileModel profile;

  const ProfileUpdateLoading(this.profile);
}

final class ProfileUpdateSuccess extends ProfileState {
  final ProfileModel profile;

  const ProfileUpdateSuccess(this.profile);
}

final class ProfileUpdateFailure extends ProfileState {
  final ProfileModel profile;
  final String message;

  const ProfileUpdateFailure({
    required this.profile,
    required this.message,
  });
}

final class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
