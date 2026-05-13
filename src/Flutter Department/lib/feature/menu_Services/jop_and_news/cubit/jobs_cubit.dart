import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/jobs_state.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/job_model.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/endpoints.dart';

class JobsCubit extends Cubit<JobsState> {
  final ApiService _apiService = ApiService();

  List<String> _selectedCategories = [];
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'latest';

 final int _pageSize = 15;

  static const List<String> categories = [
    'Backend Dev',
    'Frontend Dev',
    'Full Stack',
    'Q/A Testing',
    'Data Analysis',
    'AI/ML',
    'Mobile Dev',
    'Embedded',
    'Game Dev',
    'Cybersecurity',
  ];

  JobsCubit() : super(JobsInitial());

  List<String> get selectedCategories => _selectedCategories;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get sortBy => _sortBy;


  void setCategories(List<String> categories) {
    _selectedCategories = categories;
    loadJobs(reset: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadJobs(reset: true);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    loadJobs(reset: true);
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    loadJobs(reset: true);
  }

  void clearFilters() {
    _selectedCategories = [];
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _sortBy = 'latest';
    loadJobs(reset: true);
  }

  bool get hasActiveFilters {
    return _selectedCategories.isNotEmpty ||
        _searchQuery.isNotEmpty ||
        _startDate != null ||
        _endDate != null ||
        _sortBy != 'latest';
  }


  Future<void> loadJobs({bool reset = false}) async {
    if (reset) {
      emit(JobsLoading());
    } else if (state is JobsLoaded) {
      final currentState = state as JobsLoaded;

      if (currentState.isLoadingMore || !currentState.hasMorePages) return;

      emit(currentState.copyWith(isLoadingMore: true));
    } else {
      emit(JobsLoading());
    }

    final page = reset
        ? 1
        : (state is JobsLoaded
            ? (state as JobsLoaded).currentPage + 1
            : 1);

    final queryParams = _buildQueryParams(page);
    final body = _buildBody();

    final response = await _apiService.post(
      Endpoints.jobs,
      queryParameters: queryParams,
      data: body,
    );

    if (response['success'] == true && response['data'] != null) {
      dynamic rawData = response['data'];

      List list;

      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map<String, dynamic>) {
        list = rawData['data'] ?? [];
      } else {
        list = [];
      }

      final newJobs =
          list.map((e) => JobModel.fromJson(e)).toList();

      List<JobModel> allJobs;

      if (reset || state is! JobsLoaded) {
        allJobs = newJobs;
      } else {
        allJobs = [
          ...(state as JobsLoaded).jobList,
          ...newJobs
        ];
      }

      int totalPages = 1;
      int totalCount = allJobs.length;
      if (rawData is Map<String, dynamic>) {
        totalPages = rawData['totalPages'] ?? 1;
        totalCount = rawData['totalCount'] ?? allJobs.length;
      }

      emit(JobsLoaded(
        jobList: allJobs,
        currentPage: page,
        totalPages: totalPages,
        totalCount: totalCount,
        isLoadingMore: false,
        hasMorePages: newJobs.length == _pageSize,
        selectedCategories: _selectedCategories,
        searchQuery: _searchQuery,
        sortBy: _sortBy,
        startDate: _startDate,
        endDate: _endDate,
      ));
    } else {
      emit(JobsError(response['error'] ?? 'Failed to load jobs'));
    }
  }

  Future<void> loadMore() async {
    if (state is JobsLoaded) {
      final currentState = state as JobsLoaded;

      if (!currentState.isLoadingMore && currentState.hasMorePages) {
        await loadJobs(reset: false);
      }
    }
  }


  Map<String, dynamic> _buildQueryParams(int page) {
    return {
      'page': page,
      'pageSize': _pageSize,
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
      if (_startDate != null)
        'fromDate': _startDate!.toIso8601String().split('T')[0],
      if (_endDate != null)
        'toDate': _endDate!.toIso8601String().split('T')[0],
      'sortBy': _sortBy,
    };
  }

  List<Map<String, dynamic>> _buildBody() {
    return _selectedCategories.isNotEmpty
        ? _selectedCategories
            .map((e) => {"categoryName": e})
            .toList()
        : [
            {"categoryName": "general"}
          ];
  }

  void reset() {
    _selectedCategories = [];
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _sortBy = 'latest';
    emit(JobsInitial());
  }
}
