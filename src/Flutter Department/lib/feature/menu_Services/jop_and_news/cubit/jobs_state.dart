import 'package:equatable/equatable.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/job_model.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object?> get props => [];
}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final List<JobModel> jobList;
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

  const JobsLoaded({
    required this.jobList,
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

  JobsLoaded copyWith({
    List<JobModel>? jobList,
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
    return JobsLoaded(
      jobList: jobList ?? this.jobList,
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
        jobList,
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

class JobsError extends JobsState {
  final String message;

  const JobsError(this.message);

  @override
  List<Object?> get props => [message];
}