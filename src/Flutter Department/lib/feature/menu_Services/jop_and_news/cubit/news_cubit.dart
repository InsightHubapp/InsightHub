import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/news_state.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/news_model.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/endpoints.dart';

class NewsCubit extends Cubit<NewsState> {
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

  NewsCubit() : super(NewsInitial());

  List<String> get selectedCategories => _selectedCategories;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get sortBy => _sortBy;


  void setCategories(List<String> categories) {
    _selectedCategories = categories;
    loadNews(reset: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadNews(reset: true);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    loadNews(reset: true);
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    loadNews(reset: true);
  }

  void clearFilters() {
    _selectedCategories = [];
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _sortBy = 'latest';
    loadNews(reset: true);
  }

  bool get hasActiveFilters {
    return _selectedCategories.isNotEmpty ||
        _searchQuery.isNotEmpty ||
        _startDate != null ||
        _endDate != null ||
        _sortBy != 'latest';
  }


  Future<void> loadNews({bool reset = false}) async {
    if (reset) {
      emit(NewsLoading());
    } else if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;

      if (currentState.isLoadingMore || !currentState.hasMorePages) return;

      emit(currentState.copyWith(isLoadingMore: true));
    } else {
      emit(NewsLoading());
    }

    final page = reset
        ? 1
        : (state is NewsLoaded
            ? (state as NewsLoaded).currentPage + 1
            : 1);

    final queryParams = _buildQueryParams(page);
    final body = _buildBody();

    final response = await _apiService.post(
      Endpoints.relatedJobs,
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

      final newNews =
          list.map((e) => NewsModel.fromJson(e)).toList();

      List<NewsModel> allNews;

      if (reset || state is! NewsLoaded) {
        allNews = newNews;
      } else {
        allNews = [
          ...(state as NewsLoaded).newsList,
          ...newNews
        ];
      }

      emit(NewsLoaded(
        newsList: allNews,
        currentPage: page,
        totalPages: page + 1, 
        totalCount: allNews.length,
        isLoadingMore: false,
        hasMorePages: newNews.length == _pageSize,
        selectedCategories: _selectedCategories,
        searchQuery: _searchQuery,
        sortBy: _sortBy,
        startDate: _startDate,
        endDate: _endDate,
      ));
    } else {
      emit(NewsError(response['error'] ?? 'Failed to load news'));
    }
  }

  Future<void> loadMore() async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;

      if (!currentState.isLoadingMore && currentState.hasMorePages) {
        await loadNews(reset: false);
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
    emit(NewsInitial());
  }
}
