import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/dashboard_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/search_dashboard_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/model/dashboard_filter_selection.dart';
import 'package:InsightHub/feature/home_and_explore/widget/dashboard_state_view.dart';
import 'package:InsightHub/widget/app_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    final selection = context.read<SearchDashboardCubit>().draftSelection;
    _searchController = TextEditingController(text: selection.searchText);
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    context.read<SearchDashboardCubit>().updateSearchText(
      _searchController.text,
    );
    setState(() {});
  }

  Future<void> _applySearch() {
    FocusScope.of(context).unfocus();
    return context.read<SearchDashboardCubit>().applySearch();
  }

  Future<void> _refreshDashboard() {
    return context.read<SearchDashboardCubit>().refreshSearchDashboard();
  }

  Future<void> _openFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _FilterBottomSheet(
          initialSelection: context.read<SearchDashboardCubit>().draftSelection,
        );
      },
    );

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selection = context.read<SearchDashboardCubit>().draftSelection;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Market Explorer',

              extra: _SearchToolbar(
                controller: _searchController,
                activeFilterCount: selection.activeFilterCount,
                onApplySearch: _applySearch,
                onOpenFilters: _openFilters,
                onClearSearch: _searchController.text.trim().isEmpty
                    ? null
                    : _searchController.clear,
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchDashboardCubit, DashboardState>(
                builder: (context, state) {
                  return DashboardStateView(
                    state: state,
                    onRefresh: _refreshDashboard,
                    onRetry: _refreshDashboard,
                    initial: const _SearchInitialView(),
                    emptyMessage:
                        'No analytics matched the current search filters.',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchToolbar extends StatelessWidget {
  const _SearchToolbar({
    required this.controller,
    required this.activeFilterCount,
    required this.onApplySearch,
    required this.onOpenFilters,
    required this.onClearSearch,
  });

  final TextEditingController controller;
  final int activeFilterCount;
  final Future<void> Function() onApplySearch;
  final VoidCallback onOpenFilters;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => onApplySearch(),
                  decoration: InputDecoration(
                    hintText: 'Search by title',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: onClearSearch == null
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close),
                            onPressed: onClearSearch,
                          ),
                    filled: true,
                    fillColor: AppColors.scaffoldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width:4),
              _FilterButton(
                activeFilterCount: activeFilterCount,
                onPressed: onOpenFilters,
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onApplySearch,
              icon: const Icon(Icons.manage_search),
              label: const Text('Apply Search'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.activeFilterCount,
    required this.onPressed,
  });

  final int activeFilterCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton.filled(
          tooltip: 'Filters',
          onPressed: onPressed,
          icon: const Icon(Icons.tune),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.softBlue,
            foregroundColor: AppColors.primary,
            fixedSize: const Size(50, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (activeFilterCount > 0)
          Positioned(
            right: -4,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                activeFilterCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet({required this.initialSelection});

  final DashboardFilterSelection initialSelection;

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late Set<String> _selectedCategories;
  late RangeValues _salaryRange;

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.initialSelection.selectedCategories.toSet();
    _salaryRange = RangeValues(
      widget.initialSelection.salaryMin,
      widget.initialSelection.salaryMax,
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });

    context.read<SearchDashboardCubit>().updateCategories(
      _selectedCategories.toList(),
    );
  }

  void _updateSalaryRange(RangeValues values) {
    setState(() {
      _salaryRange = values;
    });

    context.read<SearchDashboardCubit>().updateSalaryRange(
      values.start,
      values.end,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _salaryRange = const RangeValues(
        DashboardFilterSelection.defaultSalaryMin,
        DashboardFilterSelection.defaultSalaryMax,
      );
    });

    context.read<SearchDashboardCubit>().clearAdvancedFilters();
  }

  Future<void> _applyFilters() async {
    final cubit = context.read<SearchDashboardCubit>();
    Navigator.of(context).pop();
    await cubit.applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.48,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.disabled,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Advanced Filters',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DashboardFilterSelection.categories.map((
                        category,
                      ) {
                        final selected = _selectedCategories.contains(category);
                        return FilterChip(
                          label: Text(category),
                          selected: selected,
                          showCheckmark: false,
                          selectedColor: AppColors.softBlue,
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.textMuted,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          onSelected: (_) => _toggleCategory(category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Average Salary',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${_formatSalary(_salaryRange.start)} - ${_formatSalary(_salaryRange.end)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: _salaryRange,
                      min: DashboardFilterSelection.defaultSalaryMin,
                      max: DashboardFilterSelection.defaultSalaryMax,
                      divisions: 40,
                      labels: RangeLabels(
                        _formatSalary(_salaryRange.start),
                        _formatSalary(_salaryRange.end),
                      ),
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.softBlue,
                      onChanged: _updateSalaryRange,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _applyFilters,
                    icon: const Icon(Icons.check),
                    label: const Text('Apply Filters'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatSalary(double value) {
    if (value >= 1000) return '${(value / 1000).round()}K';
    return value.round().toString();
  }
}

class _SearchInitialView extends StatelessWidget {
  const _SearchInitialView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: const Column(
            children: [
              Icon(Icons.query_stats, color: AppColors.primary, size: 38),
              SizedBox(height: 14),
              Text(
                'The dashboard is yours!\n\nType a keyword or apply filters to Start Exploring',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
