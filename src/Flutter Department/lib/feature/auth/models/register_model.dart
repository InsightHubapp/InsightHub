import 'package:InsightHub/core/utils/safe_parser.dart';

class RegisterModel {
  final String firstName;
  final String lastName;
  final int gender;
  final DateTime birthDate;
  final String collage;
  final bool isEmployed;
  final String email;
  final String password;
  final String confirmPassword;
  final int? trackId;
  final int? yearsExperience;

  const RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.collage,
    required this.isEmployed,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.trackId,
    this.yearsExperience,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate.toUtc().toIso8601String(),
      "collage": collage,
      "isEmployed": isEmployed,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "trackId": trackId,
      "yearsExperience": yearsExperience,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      firstName: SafeParser.getString(json, 'firstName'),
      lastName: SafeParser.getString(json, 'lastName'),
      gender: SafeParser.getInt(json, 'gender'),
      birthDate: DateTime.tryParse(SafeParser.getString(json, 'birthDate')) ?? DateTime.now(),
      collage: SafeParser.getString(json, 'collage'),
      isEmployed: SafeParser.getBool(json, 'isEmployed'),
      email: SafeParser.getString(json, 'email'),
      password: SafeParser.getString(json, 'password'),
      confirmPassword: SafeParser.getString(json, 'confirmPassword'),
      trackId: SafeParser.getInt(json, 'trackId'),
      yearsExperience: SafeParser.getInt(json, 'yearsExperience'),
    );
  }
}


