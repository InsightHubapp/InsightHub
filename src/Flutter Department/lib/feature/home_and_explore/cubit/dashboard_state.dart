part of 'dashboard_cubit.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final List<DashboardItem> items;
  DashboardSuccess(this.items);
}

class DashboardFailure extends DashboardState {
  final String errorMessage;
  DashboardFailure(this.errorMessage);
}
