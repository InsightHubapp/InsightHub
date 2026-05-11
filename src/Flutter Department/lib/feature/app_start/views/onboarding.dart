import 'package:InsightHub/feature/auth/widget/logo.dart';
import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/core/constant/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final PageController _pageController =
      PageController();

  int _currentPage = 0;

  final List<_OnboardingPageData> _pages =
      const [
    _OnboardingPageData(
      headerTitle:
          'FrontEnd Analytics',
      headerSubtitle:
          'React • Flutter • UI/UX',
      title:
          'Track Front-End Technology Trends',
      description:
          'Analyze salaries, hiring growth, frameworks, and demanded skills across Flutter, React, Angular, and modern front-end technologies.',
      accentColor:
          AppColors.primaryBlue,
      surfaceColor:
          Color(0xFFDCEBFF),
    ),

    _OnboardingPageData(
      headerTitle:
          'BackEnd Intelligence',
      headerSubtitle:
          'Node.js • Laravel • APIs',
      title:
          'Understand Server-Side Market Demand',
      description:
          'Monitor backend technologies including Node.js, Laravel, .NET, databases, scalable APIs, cloud systems, and DevOps engineering.',
      accentColor:
          Color(0xFF0F766E),
      surfaceColor:
          Color(0xFFD9F7F2),
    ),

    _OnboardingPageData(
      headerTitle:
          'AI & Data Analytics',
      headerSubtitle:
          'Machine Learning • Data Science',
      title:
          'Discover AI and Data Career Insights',
      description:
          'Explore machine learning, cybersecurity, data analysis, and game development careers powered by intelligent market analytics.',
      accentColor:
          Color(0xFF4F46E5),
      surfaceColor:
          Color(0xFFE7E5FF),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      onboardingSeenKey,
      true,
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      Routes.welcomeScreen,
    );
  }

  Future<void> _handlePrimaryAction() async {
    if (_currentPage ==
        _pages.length - 1) {
      await _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration:
          const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    final isLastPage =
        _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        999,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withAlpha(10),
                          blurRadius: 12,
                          offset:
                              const Offset(
                            0,
                            6,
                          ),
                        ),
                      ],
                    ),
                    child: Text(
                      '${_currentPage + 1}/${_pages.length}',
                      style:
                          const TextStyle(
                        color: AppColors
                            .textDark,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed:
                        _finishOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors
                            .textGray,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child:
                    PageView.builder(
                  controller:
                      _pageController,
                  itemCount:
                      _pages.length,
                  onPageChanged:
                      (index) {
                    setState(() {
                      _currentPage =
                          index;
                    });
                  },
                  itemBuilder:
                      (context, index) {
                    final item =
                        _pages[index];

                    return _OnboardingPage(
                      data: item,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) =>
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 220,
                    ),
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    width:
                        index == _currentPage
                            ? 30
                            : 10,
                    height: 10,
                    decoration:
                        BoxDecoration(
                      color:
                          index ==
                                  _currentPage
                              ? page
                                  .accentColor
                              : Colors
                                  .grey
                                  .shade300,
                      borderRadius:
                          BorderRadius.circular(
                        999,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        page.accentColor,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  onPressed:
                      _handlePrimaryAction,
                  child: Text(
                    isLastPage
                        ? 'Start Exploring'
                        : 'Continue',
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage
    extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
  });

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              24,
            ),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: [
                  data.surfaceColor,
                  Colors.white,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                34,
              ),
              boxShadow: [
                BoxShadow(
                  color: data
                      .accentColor
                      .withAlpha(20),
                  blurRadius: 24,
                  offset:
                      const Offset(
                    0,
                    14,
                  ),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Row(
                  children: [
                    AnalyticsLogo(
                      size: 62,
                      color: data
                          .accentColor,
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            data
                                .headerTitle,
                            style:
                                const TextStyle(
                              fontSize:
                                  22,
                              fontWeight:
                                  FontWeight
                                      .w800,
                              color:
                                  AppColors
                                      .textDark,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            data
                                .headerSubtitle,
                            style:
                                const TextStyle(
                              fontSize:
                                  14,
                              color:
                                  AppColors
                                      .textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 28,
                ),

                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withAlpha(
                      235,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                    border: Border.all(
                      color: data
                          .accentColor
                          .withAlpha(
                        20,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AnalyticsLogo(
                            size: 42,
                            color: data
                                .accentColor,
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Technology Insights',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                    color: data
                                        .accentColor,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      2,
                                ),

                                const Text(
                                  'Live market analytics',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        12,
                                    color:
                                        AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  10,
                              vertical:
                                  6,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFDCFCE7,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                999,
                              ),
                            ),
                            child:
                                const Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min,
                              children: [
                                Icon(
                                  Icons
                                      .trending_up,
                                  size:
                                      14,
                                  color:
                                      Color(0xFF16A34A),
                                ),

                                SizedBox(
                                  width:
                                      4,
                                ),

                                Text(
                                  '+18.2%',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        11,
                                    fontWeight:
                                        FontWeight.w700,
                                    color:
                                        Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                _MetricCard(
                              label:
                                  'Front-End',
                              value:
                                  '+32%',
                              accentColor:
                                  data.accentColor,
                              trendUp:
                                  true,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                _MetricCard(
                              label:
                                  'Back-End',
                              value:
                                  '-4%',
                              accentColor:
                                  data.accentColor,
                              trendUp:
                                  false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      Container(
                        height: 220,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              8,
                          vertical:
                              12,
                        ),
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin:
                                Alignment
                                    .topCenter,
                            end:
                                Alignment
                                    .bottomCenter,
                            colors: [
                              data
                                  .accentColor
                                  .withAlpha(
                                8,
                              ),
                              Colors
                                  .transparent,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .end,
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceAround,
                          children: [
                            _buildAnalyticsBar(
                              label:
                                  'Flutter',
                              value:
                                  '+14%',
                              height:
                                  55,
                              color: data
                                  .accentColor,
                            ),

                            _buildAnalyticsBar(
                              label:
                                  'React',
                              value:
                                  '+31%',
                              height:
                                  120,
                              color: data
                                  .accentColor,
                            ),

                            _buildAnalyticsBar(
                              label:
                                  'Node',
                              value:
                                  '+19%',
                              height:
                                  82,
                              color: data
                                  .accentColor,
                            ),

                            _buildAnalyticsBar(
                              label:
                                  'AI',
                              value:
                                  '+52%',
                              height:
                                  145,
                              color: data
                                  .accentColor,
                            ),

                            _buildAnalyticsBar(
                              label:
                                  'Data',
                              value:
                                  '+28%',
                              height:
                                  102,
                              color: data
                                  .accentColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildTag(
                            'Front-End',
                            data
                                .accentColor,
                          ),

                          _buildTag(
                            'Back-End',
                            data
                                .accentColor,
                          ),

                          _buildTag(
                            'AI',
                            data
                                .accentColor,
                          ),

                          _buildTag(
                            'Mobile',
                            data
                                .accentColor,
                          ),

                          _buildTag(
                            'Game Dev',
                            data
                                .accentColor,
                          ),

                          _buildTag(
                            'Data Analysis',
                            data
                                .accentColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          Text(
            data.title,
            style:
                const TextStyle(
              fontSize: 31,
              height: 1.2,
              fontWeight:
                  FontWeight.w800,
              color:
                  AppColors.textDark,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            data.description,
            style:
                const TextStyle(
              fontSize: 16,
              height: 1.7,
              color:
                  AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsBar({
    required String label,
    required String value,
    required double height,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight:
                FontWeight.w700,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: 26,
          height: height,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(
              begin:
                  Alignment.topCenter,
              end:
                  Alignment.bottomCenter,
              colors: [
                color,
                color.withAlpha(70),
              ],
            ),
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.w600,
            color:
                AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius:
            BorderRadius.circular(
          999,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight:
              FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetricCard
    extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.accentColor,
    this.trendUp = true,
  });

  final String label;
  final String value;
  final Color accentColor;
  final bool trendUp;

  @override
  Widget build(BuildContext context) {
    final trendColor =
        trendUp
            ? const Color(
                0xFF16A34A,
              )
            : const Color(
                0xFFDC2626,
              );

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                const TextStyle(
              color:
                  AppColors.textGray,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                trendUp
                    ? Icons
                        .trending_up
                    : Icons
                        .trending_down,
                color: trendColor,
                size: 18,
              ),

              const SizedBox(width: 4),

              Text(
                value,
                style:
                    TextStyle(
                  color:
                      trendColor,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.accentColor,
    required this.surfaceColor,
    required this.headerTitle,
    required this.headerSubtitle,
  });

  final String title;
  final String description;
  final Color accentColor;
  final Color surfaceColor;
  final String headerTitle;
  final String headerSubtitle;
}