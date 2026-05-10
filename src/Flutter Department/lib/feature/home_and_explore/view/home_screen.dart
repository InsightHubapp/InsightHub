import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/views/profile.dart';
import 'package:InsightHub/feature/home_and_explore/view/search_screen.dart';
import 'package:InsightHub/feature/menu_Services/survey_menu_screen.dart';
import 'package:InsightHub/widget/bottom_nav.dart';
import 'package:InsightHub/feature/home_and_explore/widget/home_screen_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final Set<int> _visitedIndexes = {0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLightGray,
      body: IndexedStack(
        index: selectedIndex,
        children: List.generate(
          widgetOptions.length,
          (index) => _visitedIndexes.contains(index)
              ? widgetOptions[index]
              : const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: .1),
            ),
          ],
        ),
        child: MainNavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
              _visitedIndexes.add(index);
            });
          },
        ),
      ),
    );
  }
}

final List<Widget> widgetOptions = <Widget>[
  const HomeScreenBody(),
  const SearchScreen(),
  SurveyMenuScreen(),
  const ProfileScreen(),
];
