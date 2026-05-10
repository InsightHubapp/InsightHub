import 'package:InsightHub/core/utils/safe_parser.dart';

class ProfileModel {
  final String email;
  final String firstName;
  final String lastName;
  final int? gender;
  final DateTime? birthDate;
  final String collage;
  final bool isEmployed;
  final int? yearsExperience;
  final String trackName;

  const ProfileModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.collage,
    required this.isEmployed,
    required this.yearsExperience,
    required this.trackName,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: SafeParser.getString(json, 'email'),
      firstName: SafeParser.getString(json, 'firstName'),
      lastName: SafeParser.getString(json, 'lastName'),
      gender: SafeParser.getInt(json, 'gender'),
      birthDate: DateTime.tryParse(SafeParser.getString(json, 'birthDate')),
      collage: SafeParser.getString(json, 'collage'),
      isEmployed: SafeParser.getBool(json, 'isEmployed'),
      yearsExperience: SafeParser.getInt(json, 'yearsExperience'),
      trackName: SafeParser.getString(json, 'trackName'),
    );
  }

  factory ProfileModel.dummy() {
    return ProfileModel(
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
      gender: 1,
      birthDate: DateTime.now().subtract(const Duration(days: 10000)),
      collage: 'University of Technology',
      isEmployed: true,
      yearsExperience: 3,
      trackName: 'Software Engineer',
    );
  }
}


