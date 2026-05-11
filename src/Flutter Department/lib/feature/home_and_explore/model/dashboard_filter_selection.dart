class DashboardFilterSelection {
  const DashboardFilterSelection({
    this.searchText = '',
    this.selectedCategories = const [],
    this.salaryMin = defaultSalaryMin,
    this.salaryMax = defaultSalaryMax,
  });

  static const double defaultSalaryMin = 0;
  static const double defaultSalaryMax = 200000;

  static const List<String> categories = [
    'Backend Dev',
    'Frontend Dev',
    'Q/A Testing',
    'Data Analysis',
    'AI/ML',
    'Mobile Dev',
    'Embedded',
    'Game Dev',
    'Cybersecurity',
  ];

  final String searchText;
  final List<String> selectedCategories;
  final double salaryMin;
  final double salaryMax;

  bool get hasSalaryFilter {
    return salaryMin > defaultSalaryMin || salaryMax < defaultSalaryMax;
  }

  bool get hasActiveFilters {
    return searchText.trim().isNotEmpty ||
        selectedCategories.isNotEmpty ||
        hasSalaryFilter;
  }

  int get activeFilterCount {
    var count = 0;
    if (searchText.trim().isNotEmpty) count++;
    if (selectedCategories.isNotEmpty) count++;
    if (hasSalaryFilter) count++;
    return count;
  }

  DashboardFilterSelection copyWith({
    String? searchText,
    List<String>? selectedCategories,
    double? salaryMin,
    double? salaryMax,
  }) {
    return DashboardFilterSelection(
      searchText: searchText ?? this.searchText,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
    );
  }

  DashboardFilterSelection clearFilters() {
    return DashboardFilterSelection(searchText: searchText);
  }

  DashboardFilterSelection clearAll() {
    return const DashboardFilterSelection();
  }

  Map<String, dynamic> toRequestBody() {
    final filters = <String, dynamic>{};
    final trimmedSearch = searchText.trim();

    if (trimmedSearch.isNotEmpty) {
      filters['title'] = {'contains': trimmedSearch};
    }

    if (selectedCategories.isNotEmpty) {
      filters['field_label'] = List<String>.from(selectedCategories);
    }

    final salaryFilter = <String, double>{};
    if (salaryMin > defaultSalaryMin) {
      salaryFilter['>='] = salaryMin;
    }
    if (salaryMax < defaultSalaryMax) {
      salaryFilter['<='] = salaryMax;
    }
    if (salaryFilter.isNotEmpty) {
      filters['salary_avg'] = salaryFilter;
    }

    if (filters.isEmpty) return const {};
    return {'filters': filters};
  }
}
