import 'package:equatable/equatable.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> newsList;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool isLoadingMore;
  final bool hasMorePages;
  final List<String> selectedCategories;
  final String searchQuery;
  final String sortBy;
  final DateTime? startDate;
  final DateTime? endDate;

  const NewsLoaded({
    required this.newsList,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    this.isLoadingMore = false,
    this.hasMorePages = true,
    this.selectedCategories = const [],
    this.searchQuery = '',
    this.sortBy = 'latest',
    this.startDate,
    this.endDate,
  });

  NewsLoaded copyWith({
    List<NewsModel>? newsList,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    bool? isLoadingMore,
    bool? hasMorePages,
    List<String>? selectedCategories,
    String? searchQuery,
    String? sortBy,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return NewsLoaded(
      newsList: newsList ?? this.newsList,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  @override
  List<Object?> get props => [
        newsList,
        currentPage,
        totalPages,
        totalCount,
        isLoadingMore,
        hasMorePages,
        selectedCategories,
        searchQuery,
        sortBy,
        startDate,
        endDate,
      ];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}