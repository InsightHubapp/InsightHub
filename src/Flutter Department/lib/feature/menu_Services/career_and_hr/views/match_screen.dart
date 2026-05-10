import 'package:InsightHub/widget/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/match_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/question_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/career_quiz_result_model.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/match_model.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  static const String routeName = '/matchScreen';

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;

  final cubit = context.read<MatchCubit>();

  if (cubit.state is! MatchLoaded) {
    cubit.fetchResult();
  } else {
    _controller.forward(from: 0);
  }
});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _scoreColor(double score) {
    if (score > 80) return const Color(0xFF16A34A);
    if (score >= 50) return const Color(0xFFF97316);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.bgGradient, // 👈 هنا
        ),
        child: SafeArea(
          child: BlocConsumer<MatchCubit, MatchState>(
            listener: (context, state) {
              if (state is MatchLoaded) {
                _controller.forward(from: 0);
              }
            },
            builder: (context, state) {
              /// ✅ Error
              if (state is MatchError) {
                return _MatchErrorView(
                  message: state.message,
                  onRetry: () {
                    // context.read<MatchCubit>().reset(); // 🔥 Don't reset result here
                    context.read<QuestionCubit>().reset();
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.questionScreen,
                    );
                  },
                );
              }

              /// ❗ مهم جدًا: ما ترجعش شاشة فاضية
              final isLoading = state is MatchLoading || state is MatchInitial || state is! MatchLoaded;
              final result = isLoading ? CareerQuizResultModel.dummy() : state.result;
        
              /// ===== Career Quiz Result =====
              if (result is CareerQuizResultModel) {
                return Skeletonizer(
                  enabled: isLoading,
                  child: _CareerQuizResultView(
                    result: result,
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                  ),
                );
              }
        
              /// ===== Matching Result =====
              final matchResult = result as MatchResultModel;
              final scoreColor = _scoreColor(matchResult.similarityScore);
        
              return Skeletonizer(
                enabled: isLoading,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                child: Column(
  children: [
    /// ───────── FIXED HEADER ─────────
    Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            Color(0xFF1D4ED8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: AppHeader(
        title: 'Best Match',
        subtitle: matchResult.matchedUserName.isEmpty
            ? 'No matched user found'
            : matchResult.matchedUserName,
        trailing: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homeScreen,
              (route) => false,
            );
          },
        ),
      ),
    ),

    /// ───────── SCROLLABLE BODY ─────────
    Expanded(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              100,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ScoreCard(
                  score: matchResult.similarityScore,
                  scoreColor: scoreColor,
                ),

                const SizedBox(height: 18),

                _InfoCard(
                  title: 'Matched User',
                  icon: Icons.person_outline_rounded,
                  child: Text(
                    matchResult.matchedUserName.isEmpty
                        ? 'Unknown user'
                        : matchResult.matchedUserName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                _InfoCard(
                  title: 'Experience',
                  icon: Icons.work_outline_rounded,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${matchResult.totalYearsExperience} years total experience',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: matchResult.jobs.isEmpty
                            ? [
                                _TagChip(
                                  label: 'No jobs available',
                                  backgroundColor:
                                      const Color(
                                    0xFFF1F5F9,
                                  ),
                                  textColor:
                                      const Color(
                                    0xFF475569,
                                  ),
                                ),
                              ]
                            : matchResult.jobs
                                  .map(
                                    (job) => _TagChip(
                                      label: job,
                                      backgroundColor:
                                          const Color(
                                        0xFFDBEAFE,
                                      ),
                                      textColor:
                                          const Color(
                                        0xFF1D4ED8,
                                      ),
                                    ),
                                  )
                                  .toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _InfoCard(
                  title: 'Matched Answers',
                  icon: Icons.quiz_outlined,
                  child: Column(
                    children:
                        matchResult.employedAnswers.isEmpty
                            ? const [
                                _EmptyAnswersView(),
                              ]
                            : matchResult.employedAnswers
                                  .map(
                                    (answer) => Padding(
                                      padding:
                                          const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child:
                                          _AnswerCard(
                                        answer: answer,
                                      ),
                                    ),
                                  )
                                  .toList(),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                     onPressed: () async {
  final cubit = context.read<QuestionCubit>();

  cubit.reset();

  final success = await cubit.fetchQuestionsAsync(
    isEmployed: true,
  );

  if (!context.mounted) return;

  if (success) {
    Navigator.pushReplacementNamed(
      context,
      Routes.questionScreen,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to load questions',
        ),
      ),
    );
  }
},
                        icon: const Icon(
                          Icons.refresh,
                        ),
                        label: const Text(
                          'Retake',
                        ),
                        style:
                            OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator
                              .pushNamedAndRemoveUntil(
                            context,
                            Routes.homeScreen,
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.check,
                        ),
                        label: const Text(
                          'Finish',
                        ),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primaryBlue,
                          foregroundColor:
                              Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    ),
  ],
),),
              ));
            },
          ),
        ),
      ),
    );
  }
}

class _CareerQuizResultView extends StatelessWidget {
  final CareerQuizResultModel result;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const _CareerQuizResultView({
    required this.result,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: AppColors.bgGradient,
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Column(
              children: [
                /// ───────────── FIXED APP HEADER ─────────────
                AppHeader(
                  title: 'Career Matches',
                  subtitle:
                      'Based on your quiz.',
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.homeScreen,
                        (route) => false,
                      );
                    },
                  ),
                ),

                /// ───────────── SCROLLABLE BODY ─────────────
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          24,
                          24,
                          20,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final trackMatch =
                                  result.topTracks[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 24),
                                child: _TrackMatchCard(
                                  trackMatch: trackMatch,
                                  rank: index + 1,
                                ),
                              );
                            },
                            childCount: result.topTracks.length,
                          ),
                        ),
                      ),

                      /// Bottom Buttons
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            0,
                            24,
                            40,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<QuestionCubit>()
                                        .reset();

                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.questionScreen,
                                    );
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retake'),
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator
                                        .pushNamedAndRemoveUntil(
                                      context,
                                      Routes.homeScreen,
                                      (route) => false,
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('Finish'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        AppColors.primaryBlue,
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}}

class _TrackMatchCard extends StatefulWidget {
  final TrackMatch trackMatch;
  final int rank;

  const _TrackMatchCard({required this.trackMatch, required this.rank});

  @override
  State<_TrackMatchCard> createState() => _TrackMatchCardState();
}

class _TrackMatchCardState extends State<_TrackMatchCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final track = widget.trackMatch.track;
    final insights = widget.trackMatch.marketInsights;

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF0F172A,
              ).withOpacity(_isExpanded ? 0.12 : 0.06),
              blurRadius: _isExpanded ? 30 : 20,
              offset: Offset(0, _isExpanded ? 15 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Rank and Score
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(_isExpanded ? 0 : 24),
                  bottomRight: Radius.circular(_isExpanded ? 0 : 24),
                ),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '#${widget.rank}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      track.trackName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Text(
                    '${track.percentage.round()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.description,
                    maxLines: _isExpanded ? null : 2,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Skills section (Always visible)
                  const Text(
                    'Key Skills',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: track.requiredSkills
                        .split(',')
                        .take(_isExpanded ? 100 : 3)
                        .map(
                          (skill) => _TagChip(
                            label: skill.trim(),
                            backgroundColor: const Color(0xFFEFF6FF),
                            textColor: const Color(0xFF1D4ED8),
                          ),
                        )
                        .toList(),
                  ),

                  if (_isExpanded) ...[
                    const Divider(height: 40),

                    // Performance Metrics Section
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.barChart2,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Performance Metrics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SkillProgressBar(
                      label: 'Technical Level',
                      value: insights.avgTechnicalLevel,
                    ),
                    _SkillProgressBar(
                      label: 'Problem Solving',
                      value: insights.avgProblemSolving,
                    ),
                    _SkillProgressBar(
                      label: 'Communication',
                      value: insights.avgCommunication,
                    ),
                    _SkillProgressBar(
                      label: 'Soft Skills',
                      value: insights.avgSoftSkills,
                    ),
                    _SkillProgressBar(
                      label: 'Adaptability',
                      value: insights.avgAdaptability,
                    ),
                    _SkillProgressBar(
                      label: 'Teamwork',
                      value: insights.avgTeamwork,
                    ),
                    _SkillProgressBar(
                      label: 'Learning Proactivity',
                      value: insights.avgLearningProactivity,
                    ),
                    _SkillProgressBar(
                      label: 'Resilience',
                      value: insights.avgResilience,
                    ),
                    _SkillProgressBar(
                      label: 'Ownership',
                      value: insights.avgOwnership,
                    ),

                    const Divider(height: 40),

                    // Market Deep Dive Section
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.trendingUp,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Market Deep Dive',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InsightStatRow(
                      icon: Icons.people_outline,
                      label: 'Industry Professionals',
                      value: '${insights.totalEmployeesInTrack}',
                    ),
                    const SizedBox(height: 12),
                    _InsightStatRow(
                      icon: Icons.history,
                      label: 'Average Experience',
                      value:
                          '${insights.avgYearsExperience.toStringAsFixed(1)} yrs',
                    ),
                    const SizedBox(height: 12),
                    _InsightStatRow(
                      icon: Icons.apartment,
                      label: 'Common Company Size',
                      value: insights.mostCommonCompanySize,
                    ),
                    const SizedBox(height: 12),
                    _InsightStatRow(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Work Environment',
                      value: insights.mostCommonEnvironment,
                    ),
                    const SizedBox(height: 12),
                    _SkillProgressBar(
                      label: 'Salary Satisfaction',
                      value: insights.avgSalarySatisfaction,
                    ),
                    _SkillProgressBar(
                      label: 'Work-Life Balance',
                      value: insights.avgWorkLifeBalance,
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tap to see full market insights',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: AppColors.primaryBlue.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillProgressBar extends StatelessWidget {
  final String label;
  final double value; // 0 to 5 scale

  const _SkillProgressBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final progress = (value / 5.0).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Text(
                value.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, Color(0xFF60A5FA)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InsightStatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const Spacer(),
        Text(
          value.isEmpty || value == 'N/A' ? 'Not specified' : value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final double score;
  final Color scoreColor;

  const _ScoreCard({required this.score, required this.scoreColor});

  @override
  Widget build(BuildContext context) {
    final progress = (score.clamp(0, 100) / 100).toDouble();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                ),
                Text(
                  '${score.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Similarity Score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This score reflects how closely your answers align with the matched profile.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final AnswerModel answer;

  const _AnswerCard({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer.question.isEmpty
                ? 'Question not available'
                : answer.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              answer.answerText.isEmpty
                  ? 'Answer value: ${answer.answer}'
                  : answer.answerText,
              style: const TextStyle(
                color: Color(0xFF166534),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _TagChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyAnswersView extends StatelessWidget {
  const _EmptyAnswersView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Text(
        'No matched answers are available yet.',
        style: TextStyle(fontSize: 15, color: Color(0xFF475569)),
      ),
    );
  }
}

class _MatchErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MatchErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              size: 42,
              color: Color(0xFFDC2626),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
