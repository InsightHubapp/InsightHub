import 'package:bloc/bloc.dart';
import 'package:InsightHub/core/services/dashboard_api.dart';
import 'package:InsightHub/core/services/endpoints.dart';
import 'package:InsightHub/feature/home_and_explore/model/dashboard_item.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {

  final DashboardApi _api;
  
  DashboardCubit({DashboardApi? api}) 
      : _api = api ?? DashboardApi(),
        super(DashboardInitial());

  Future<void> fetchHomeDashboard() async {
    emit(DashboardLoading());
    try {
      final rawData = await _api.fetchDashboardData(Endpoints.analysisHome);
      
      final items = rawData
          .map((e) => DashboardItem.fromJson(e))
          .where((item) => item.isValid)
          .toList();

      emit(DashboardSuccess(items));
    } catch (e) {
      emit(DashboardFailure('Failed to load dashboard data.'));
    }
  }

  void reset() {
    emit(DashboardInitial());
  }
}
