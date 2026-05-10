import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/services/dashboard_api.dart';
import 'package:InsightHub/core/services/endpoints.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/dashboard_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/model/dashboard_filter_selection.dart';
import 'package:InsightHub/feature/home_and_explore/model/dashboard_item.dart';

class SearchDashboardCubit extends Cubit<DashboardState> {
  SearchDashboardCubit({DashboardApi? api})
    : _api = api ?? DashboardApi(),
      super(DashboardInitial());

  final DashboardApi _api;

  DashboardFilterSelection _draftSelection = const DashboardFilterSelection();
  DashboardFilterSelection _appliedSelection = const DashboardFilterSelection();

  DashboardFilterSelection get draftSelection => _draftSelection;
  DashboardFilterSelection get appliedSelection => _appliedSelection;

  bool get hasAppliedFilters => _appliedSelection.hasActiveFilters;

  void updateSearchText(String value) {
    _draftSelection = _draftSelection.copyWith(searchText: value);
  }

  void updateCategories(List<String> categories) {
    _draftSelection = _draftSelection.copyWith(
      selectedCategories: List<String>.from(categories),
    );
  }

  void updateSalaryRange(double min, double max) {
    _draftSelection = _draftSelection.copyWith(salaryMin: min, salaryMax: max);
  }

  Future<void> applySearch() {
    return _fetchExploreDashboard(_draftSelection);
  }

  Future<void> applyFilters() {
    return _fetchExploreDashboard(_draftSelection);
  }

  Future<void> refreshSearchDashboard() {
    return _fetchExploreDashboard(_appliedSelection);
  }

  Future<void> clearFilters({bool fetch = false}) async {
    _draftSelection = const DashboardFilterSelection();
    _appliedSelection = const DashboardFilterSelection();

    if (fetch) {
      await _fetchExploreDashboard(_draftSelection);
      return;
    }

    emit(DashboardInitial());
  }

  void clearAdvancedFilters() {
    _draftSelection = _draftSelection.clearFilters();
  }

  void reset() {
    _draftSelection = const DashboardFilterSelection();
    _appliedSelection = const DashboardFilterSelection();
    emit(DashboardInitial());
  }

  Future<void> _fetchExploreDashboard(
    DashboardFilterSelection selection,
  ) async {
    emit(DashboardLoading());

    try {
      final rawData = await _api.fetchDashboardData(
        Endpoints.analysisExplore,
        requestBody: selection.toRequestBody(),
      );

      final items = rawData
          .map((item) => DashboardItem.fromJson(item))
          .where((item) => item.isValid)
          .toList();

      _appliedSelection = selection;
      _draftSelection = selection;

      emit(DashboardSuccess(items));
    } catch (_) {
      emit(DashboardFailure('Failed to load search analytics.'));
    }
  }
}
