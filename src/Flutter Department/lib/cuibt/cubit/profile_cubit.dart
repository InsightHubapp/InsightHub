import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/endpoints.dart';
import 'package:InsightHub/model/profile_model.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final ApiService _apiService = ApiService();

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && state is ProfileSuccess) return;
    if (state is ProfileLoading) return;

    emit(ProfileLoading());

    try {
      final result = await _loadProfile();

      if (result['success'] == true &&
          result['data'] is Map<String, dynamic>) {
        final profile = ProfileModel.fromJson(
          result['data'] as Map<String, dynamic>,
        );

        emit(ProfileSuccess(profile));
        return;
      }

      emit(
        ProfileFailure(
          result['error']?.toString() ?? 'Failed to load profile.',
        ),
      );
    } catch (_) {
      emit(const ProfileFailure('Failed to load profile.'));
    }
  }

  Future<void> updateProfile({
    required Map<String, dynamic> profileJson,
  }) async {
    if (state is ProfileUpdateLoading) return;

    final currentProfile = _currentProfile();
    if (currentProfile == null) return;

    emit(ProfileUpdateLoading(currentProfile));

    final result = await _apiService.put(
      Endpoints.updateProfile,
      data: profileJson,
    );

    if (result['success'] != true) {
      emit(
        ProfileUpdateFailure(
          profile: currentProfile,
          message: result['error']?.toString() ?? 'Failed to update profile.',
        ),
      );
      return;
    }

    final refreshed = await _loadProfile();

    if (refreshed['success'] == true &&
        refreshed['data'] is Map<String, dynamic>) {
      final profile = ProfileModel.fromJson(
        refreshed['data'] as Map<String, dynamic>,
      );
      emit(ProfileUpdateSuccess(profile));
      emit(ProfileSuccess(profile));
      return;
    }

    emit(
      ProfileUpdateFailure(
        profile: currentProfile,
        message: refreshed['error']?.toString() ?? 'Failed to refresh profile.',
      ),
    );
  }

  Future<Map<String, dynamic>> _loadProfile() async {
    return await _apiService.get(Endpoints.profile);
  }

  ProfileModel? _currentProfile() {
    final currentState = state;
    if (currentState is ProfileSuccess) return currentState.profile;
    if (currentState is ProfileUpdateFailure) return currentState.profile;
    if (currentState is ProfileUpdateSuccess) return currentState.profile;
    return null;
  }

  void reset() {
    emit(ProfileInitial());
  }
}
