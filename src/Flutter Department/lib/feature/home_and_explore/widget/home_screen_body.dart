import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/dashboard_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/widget/dashboard_state_view.dart';
import 'package:InsightHub/widget/app_header.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardCubit>().fetchHomeDashboard();
      }
    });
  }

  Future<void> _refreshDashboard() async {
    await context.read<DashboardCubit>().fetchHomeDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Your Insight Hub',
              subtitle: 'Your Fresh insights from the last 90 days, Updated live.',
            ),

            Expanded(
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return DashboardStateView(
                    state: state,
                    onRefresh: _refreshDashboard,
                    onRetry: () =>
                        context.read<DashboardCubit>().fetchHomeDashboard(),
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
