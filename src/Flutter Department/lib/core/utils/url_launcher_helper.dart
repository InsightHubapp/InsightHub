import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> openUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    final uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      throw Exception('Cannot open this URL');
    }

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}