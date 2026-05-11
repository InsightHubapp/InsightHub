import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/widget/card_news.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/widget/category_selector.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/news_cubit.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/news_state.dart';
import 'package:InsightHub/widget/app_header.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/news_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  static const String routeName = '/newsScreen';

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<NewsCubit>().loadMore();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsCubit>().loadNews(reset: true);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.bgGradient, 
        ),
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(
                title: 'News',
                subtitle: 'Updated every 12 hours',
                showBackButton: true,
              ),

              BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  final cubit = context.read<NewsCubit>();

                  return CategorySelector(
                    categories: NewsCubit.categories,
                    selected: cubit.selectedCategories,
                    onChanged: (updated) {
                      cubit.setCategories(updated);
                    },
                  );
                },
              ),

              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return NewsCard(
                              news: NewsModel.dummy(),
                            );
                          },
                        ),
                      );
                    }

                    if (state is NewsError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is NewsLoaded) {
                      if (state.newsList.isEmpty) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await context
                                .read<NewsCubit>()
                                .loadNews(reset: true);
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              Center(child: Text('No news available')),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<NewsCubit>()
                              .loadNews(reset: true);
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount:
                              state.newsList.length +
                              (state.hasMorePages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.newsList.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                                child: Skeletonizer(
                                  enabled: true,
                                  child: NewsCard(
                                    news: NewsModel.dummy(),
                                  ),
                                ),
                              );
                            }

                            return NewsCard(
                              news: state.newsList[index],
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
}
