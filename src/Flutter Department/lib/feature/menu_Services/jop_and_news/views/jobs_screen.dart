import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/utils/url_launcher_helper.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/widget/card_linkedin.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/jobs_cubit.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/jobs_state.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/widget/category_selector.dart';
import 'package:InsightHub/widget/app_header.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/job_model.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});
  static const String routeName = '/jobScreen';

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore) {
          isLoadingMore = true;
          context.read<JobsCubit>().loadMore().then((_) {
            isLoadingMore = false;
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobsCubit>().loadJobs(reset: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.bgGradient, 
        ),
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(
                title: 'Jobs',
                subtitle: 'Updated Daily',
                showBackButton: true,
              ),
              BlocBuilder<JobsCubit, JobsState>(
                builder: (context, state) {
                  final cubit = context.read<JobsCubit>();

                  return CategorySelector(
                    categories: JobsCubit.categories,
                    selected: cubit.selectedCategories,
                    onChanged: (updated) {
                      cubit.setCategories(updated);
                      cubit.loadJobs(reset: true);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<JobsCubit, JobsState>(
                  builder: (context, state) {
                    if (state is JobsLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return JobCard(
                              job: JobModel.dummy(),
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    }

                    if (state is JobsError) {
                      return _errorView(state.message);
                    }

                    if (state is JobsLoaded) {
                      if (state.jobList.isEmpty) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await context
                                .read<JobsCubit>()
                                .loadJobs(reset: true);
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              Center(child: Text('No jobs available')),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<JobsCubit>()
                              .loadJobs(reset: true);
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              state.jobList.length + (state.hasMorePages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.jobList.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                                child: Skeletonizer(
                                  enabled: true,
                                  child: JobCard(
                                    job: JobModel.dummy(),
                                    onTap: () {},
                                  ),
                                ),
                              );
                            }

                            return JobCard(
                              job: state.jobList[index],
                              onTap: () => UrlLauncherHelper.openUrl(
                                state.jobList[index].redirectUrl,
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorView(String message) {
    return Center(child: Text(message));
  }
}
