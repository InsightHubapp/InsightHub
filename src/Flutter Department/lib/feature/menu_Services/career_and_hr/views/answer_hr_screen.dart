import 'package:InsightHub/widget/app_header.dart';
import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/model/hr_quiz_result_model.dart';

class AnswerHrScreen extends StatefulWidget {
  final String categoryName;
  final int totalQuestions;
  final HrQuizResultModel result;

  const AnswerHrScreen({
    super.key,
    required this.categoryName,
    required this.totalQuestions,
    required this.result,
  });

  @override
  State<AnswerHrScreen> createState() => _AnswerHrScreenState();
}

class _AnswerHrScreenState extends State<AnswerHrScreen>
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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _correctCount => widget.result.result;

  int get _total => widget.totalQuestions;

  Color get _scoreColor {
    final pct = _correctCount / _total;

    if (pct >= 0.8) {
      return const Color(0xFF16A34A);
    }

    if (pct >= 0.5) {
      return const Color(0xFFF97316);
    }

    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  AppHeader(
                    title: widget.categoryName,
                    subtitle: 'Review your answers below',
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            40,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _ScoreCard(
                                correct: _correctCount,
                                total: _total,
                                scoreColor: _scoreColor,
                              ),

                              const SizedBox(height: 24),

                              const Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: Text(
                                  'Questions & Answers',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),

                              ...widget.result.correctAnswers.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _QuestionCard(item: item),
                                ),
                              ),

                              const SizedBox(height: 10),

                              ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.check),
                                label: const Text('Done'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  minimumSize:
                                      const Size.fromHeight(54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ]),
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
  }
}

class _ScoreCard extends StatelessWidget {
  final int correct;
  final int total;
  final Color scoreColor;

  const _ScoreCard({
    required this.correct,
    required this.total,
    required this.scoreColor,
  });

  String get _label {
    final pct = correct / total;

    if (pct >= 0.8) {
      return 'Excellent Result!';
    }

    if (pct >= 0.5) {
      return 'Good Effort!';
    }

    return 'Keep Practicing!';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (correct / total).clamp(0.0, 1.0);

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
                    backgroundColor:
                        const Color(0xFFE2E8F0),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      scoreColor,
                    ),
                  ),
                ),
                Text(
                  '$correct/$total',
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'You answered $correct out of $total questions correctly.',
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

class _QuestionCard extends StatelessWidget {
  final dynamic item;

  const _QuestionCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = item.isCorrect;

    final Color statusColor = isCorrect
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: statusColor.withOpacity(0.4),
          width: 1.3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: statusColor,
                      size: 16,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      isCorrect
                          ? 'Correct'
                          : 'Wrong',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                        fontSize: 13,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  item.difficulty,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            item.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check
                          : Icons.close,
                      size: 16,
                      color: statusColor,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Answer',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Color(0xFF64748B),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            item.userAnswer,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (!isCorrect) ...[
                  const Divider(height: 20),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Color(0xFF16A34A),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Correct Answer',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Color(0xFF64748B),
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              item.correctAnswer,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: AppColors.primaryBlue,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    item.explanation,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF1D4ED8),
                    ),
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