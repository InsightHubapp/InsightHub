class SelectedJob {
  final int jobId;
  final int yearsExperience;

  const SelectedJob({
    required this.jobId,
    required this.yearsExperience,
  });

  Map<String, dynamic> toJson() {
    return {
      "jobId": jobId,
      "yearsExperience": yearsExperience,
    };
  }

  factory SelectedJob.fromJson(Map<String, dynamic> json) {
    return SelectedJob(
      jobId: json["jobId"],
      yearsExperience: json["yearsExperience"],
    );
  }
}