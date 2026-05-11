import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/hr_question_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:InsightHub/cuibt/cubit/logout_cubit.dart';
import 'package:InsightHub/cuibt/cubit/profile_cubit.dart';
import 'package:InsightHub/core/services/api_service.dart';
import 'package:InsightHub/core/services/secure_storege.dart';
import 'package:InsightHub/feature/auth/views/register/confirmation.dart';
import 'package:InsightHub/feature/auth/views/register/email_registter.dart';
import 'package:InsightHub/feature/auth/views/register/labor_information.dart';
import 'package:InsightHub/feature/auth/views/register/personal_one.dart';
import 'package:InsightHub/feature/auth/views/register/personal_two.dart';
import 'package:InsightHub/feature/app_start/views/onboarding.dart';
import 'package:InsightHub/feature/app_start/views/welcome.dart';
import 'package:InsightHub/feature/auth/views/sign_in.dart';
import 'package:InsightHub/feature/app_start/views/splash.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/views/menu_hr_categories_screen.dart';
import 'package:InsightHub/feature/home_and_explore/view/home_screen.dart';
import 'package:InsightHub/views/edit_profile.dart';
import 'package:InsightHub/views/profile.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/views/question_screen.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/views/career_result_screen.dart';
import 'package:InsightHub/feature/menu_Services/survey_menu_screen.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/views/survey_thank_you_screen.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/views/news_screen.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/views/jobs_screen.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/auth/cubit/login_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/career_result_cubit.dart';
import 'package:InsightHub/feature/menu_Services/career_and_hr/cubit/question_cubit.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/dashboard_cubit.dart';
import 'package:InsightHub/feature/home_and_explore/cubit/search_dashboard_cubit.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/news_cubit.dart';
import 'package:InsightHub/feature/menu_Services/jop_and_news/cubit/jobs_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  SecureStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    ApiService.unauthorizedNotifier.addListener(_handleUnauthorized);
  }

  @override
  void dispose() {
    ApiService.unauthorizedNotifier.removeListener(_handleUnauthorized);
    super.dispose();
  }

  void _handleUnauthorized() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    navigator.pushNamedAndRemoveUntil(Routes.signInScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => LogoutCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => CareerResultCubit()),
        BlocProvider(create: (context) => QuestionCubit()),
        BlocProvider(create: (context) => HrQuestionCubit()),
        BlocProvider(create: (context) => DashboardCubit()),
        BlocProvider(create: (context) => SearchDashboardCubit()),
        BlocProvider(create: (context) => NewsCubit()),
        BlocProvider(create: (context) => JobsCubit()),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Insight Hub',
        home: const SplashScreen(),
        routes: {
          Routes.onboardingScreen: (_) => const OnboardingScreen(),
          Routes.welcomeScreen: (_) => const WelcomeScreen(),
          Routes.homeScreen: (_) => const HomeScreen(),
          Routes.signInScreen: (_) => const SignInScreen(),
          Routes.registerEmailScreen: (_) => const RegisterAccountScreen(),
          Routes.registerNameScreen: (_) => const RegisterNameScreen(),
          Routes.registerEducationScreen: (_) =>
              const RegisterEducationScreen(),
          Routes.laborInformationScreen: (_) => const LaborInformationScreen(),
          Routes.confirmationScreen: (_) => ConfirmationScreen(),
          Routes.questionScreen: (_) => const QuestionScreen(),
          // Backwards compatible route → career result.
          Routes.matchScreen: (_) => const CareerResultScreen(),
          Routes.careerResultScreen: (_) => const CareerResultScreen(),
          Routes.profileScreen: (_) => const ProfileScreen(),
          Routes.editProfileScreen: (_) => const EditProfileScreen(),
          Routes.surveyMenuScreen: (_) => const SurveyMenuScreen(),
          Routes.surveyThankYouScreen: (_) => const SurveyThankYouScreen(),
          Routes.newsScreen: (_) => const NewsScreen(),
          Routes.jobScreen: (_) => const JobsScreen(),
          Routes.menuHrCategoriesScreen: (_) => const MenuHrCategoriesScreen(),
        },
      ),
    );
  }
}
