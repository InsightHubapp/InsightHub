import 'package:flutter/material.dart';
import 'package:InsightHub/core/utils/date_utils.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:InsightHub/core/utils/url_launcher_helper.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (news.url != null && news.url!.isNotEmpty) {
          UrlLauncherHelper.openUrl(news.url!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: news.urlToImage != null
                  ? Image.network(
                      news.urlToImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.globe, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(news.sourceName ?? 'Unknown'),
                      ),
                      Text(DateUtilsHelper.format(news.publishedAt)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 👇 جوه الكارد
  Widget _placeholder() {
    return Container(
      height: 150,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(LucideIcons.image, size: 40),
      ),
    );
  }


}