import 'package:InsightHub/core/services/api_service.dart';

class DashboardApi {
  final ApiService _apiService;

  DashboardApi({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchDashboardData(
    String endpoint, {
    Map<String, dynamic> requestBody = const {},
  }) async {
    try {
      final response = requestBody.isEmpty
          ? await _apiService.get(endpoint)
          : await _apiService.post(endpoint, data: requestBody);

      if (response['success'] != true) {
        _logDashboardError(response);
        return [];
      }

      final body = response['data'];
      if (body is! Map<String, dynamic>) return [];

      final dashboardMap = body['data'];
      if (dashboardMap is! Map<String, dynamic>) return [];

      return dashboardMap.entries
          .map(_entryToDashboardItemJson)
          .where((item) => item.isNotEmpty)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> _entryToDashboardItemJson(
    MapEntry<String, dynamic> entry,
  ) {
    final value = entry.value;
    if (value is! Map<String, dynamic>) return <String, dynamic>{};

    return <String, dynamic>{
      'id': entry.key,
      'title': value['title'] ?? entry.key,
      'type': value['type'] ?? 'unknown',
      'objective': value['objective'] ?? '',
      'description': value['description'] ?? '',
      'data': value,
    };
  }

  void _logDashboardError(Map<String, dynamic> response) {
    final errorData = response['data'];
    if (errorData is Map<String, dynamic>) {
      return;
    }
  }
}
