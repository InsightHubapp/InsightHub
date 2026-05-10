class NewsModel {
  final String title;
  final String? sourceName;
  final DateTime? publishedAt;
  final String? url;
  final String? urlToImage;

  NewsModel({
    required this.title,
    this.sourceName,
    this.publishedAt,
    this.url,
    this.urlToImage,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      sourceName: json['sourceName'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      url: json['url'],
      urlToImage: json['urlToImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sourceName': sourceName,
      'publishedAt': publishedAt?.toIso8601String(),
      'url': url,
      'urlToImage': urlToImage,
    };
  }

  factory NewsModel.dummy() {
    return NewsModel(
      title: 'Global Markets Rally as Tech Stocks Surge Higher',
      sourceName: 'Tech Insider',
      publishedAt: DateTime.now(),
      url: 'https://example.com/news',
      urlToImage: null,
    );
  }
}