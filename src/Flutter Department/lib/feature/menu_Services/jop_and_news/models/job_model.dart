class JobModel {
  final String title;
  final String companyName;
  final String location;
  final String? description;
  final String? redirectUrl;
  final DateTime? createdDate;

  JobModel({
    required this.title,
    required this.companyName,
    required this.location,
    this.description,
    this.redirectUrl,
    this.createdDate,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: json['title'] ?? '',
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
      description: json['description'],
      redirectUrl: json['redirectUrl'],
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'companyName': companyName,
      'location': location,
      'description': description,
      'redirectUrl': redirectUrl,
      'createdDate': createdDate?.toIso8601String(),
    };
  }

  factory JobModel.dummy() {
    return JobModel(
      title: 'Senior Software Engineer',
      companyName: 'Tech Innovators Inc.',
      location: 'San Francisco, CA',
      description: 'We are looking for an experienced software engineer to join our team. The ideal candidate will have strong skills in Flutter and Dart.',
      redirectUrl: 'https://example.com/job',
      createdDate: DateTime.now(),
    );
  }
}

class JobResponse {
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final List<JobModel> data;

  JobResponse({
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.data,
  });

  factory JobResponse.fromJson(Map<String, dynamic> json) {
    List<JobModel> jobList = [];
    
    if (json['data'] != null && json['data'] is List) {
      jobList = (json['data'] as List)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return JobResponse(
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 15,
      totalPages: json['totalPages'] ?? 1,
      data: jobList,
    );
  }
}