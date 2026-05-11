import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/app_shadow.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/job_model.dart';
class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final description = job.description ?? '';
    final salary = _extractSalary(description);
    final jobType = _extractJobType(description);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.25)),
          boxShadow: AppShadows.level3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                _avatar(),
                const SizedBox(width: 10),
                Expanded(child: _titleSection()),
              ],
            ),

            const SizedBox(height: 10),

            if ((job.location ?? '').isNotEmpty)
              _location(),

            const SizedBox(height: 8),

            _badges(salary, jobType),

            const SizedBox(height: 8),

            if (description.isNotEmpty)
              _description(description),

            const SizedBox(height: 12),

          SizedBox(
  width: double.infinity,
  child: GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF), 
            Color(0xFF4F46E5), 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text(
          "Apply",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ),
)
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          job.companyName.isNotEmpty
              ? job.companyName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          job.companyName,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _location() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            job.location!,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _badges(String? salary, String? jobType) {
    return Row(
      children: [
        if (salary != null) _badge(salary, Colors.green),
        if (jobType != null) ...[
          const SizedBox(width: 6),
          _badge(jobType, AppColors.primary),
        ]
      ],
    );
  }

  Widget _description(String description) {
    return Text(
      description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String? _extractSalary(String text) {
    final regex = RegExp(r'[\$£€]\s?[\d,]+');
    return regex.firstMatch(text)?.group(0);
  }

  String? _extractJobType(String text) {
    text = text.toLowerCase();

    if (text.contains('remote')) return 'Remote';
    if (text.contains('full-time')) return 'Full-time';

    return null;
  }
}