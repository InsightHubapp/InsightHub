import 'package:InsightHub/core/constant/api_constants.dart';

class Endpoints {
  static String baseUrl = ApiConstants.baseUrl;

  static const String login = '/account/login';
  static const String register = '/Account/register';
  static const String logout = '/Account/logout';
  static const String profile = '/Account/profile';
  static const String deleteAccount = '/Account/DeleteAccount';
  static const String updateProfile = '/Account/UpdateProfile';
  static const String checkEmailExistence = '/Account/EmailExistance';
  static const String sendOtp = '/Account/send-otp';
  static const String verifyOtp = '/Account/verify-otp';

  static const String questions = '/Survey/questions';
  static const String answers = '/Survey/submit';

  static const String careerQuizQuestions = '/CareerQuiz/questions';
  static const String careerQuizFullMatch = '/CareerQuiz/full-match';
  static const String careerQuizResult = '/CareerQuiz/result';
  static const String navigationStatus = '/UserSubmission/EmploymentStatus';


  static const String analysisHome = '/AnalysisProxy/home';
  static const String analysisExplore = '/AnalysisProxy/explore';

  static const String relatedJobs = '/News';
  static const String jobs = '/JobsOffers';

  static const String hrCategories = '/InterviewQuiz/Questions';
  static const String hrQuizSubmit = '/InterviewQuiz/Submit';
}
