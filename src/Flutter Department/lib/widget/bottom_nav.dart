






import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:InsightHub/core/constant/app_colors.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: AppColors.scaffoldBg,
          hoverColor: AppColors.scaffoldBg,
          gap: 8,
          activeColor: AppColors.primaryBlue,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor:AppColors.shadowblue,
          color:  AppColors.primaryBlue,
          haptic: true,

tabs: [
  GButton(
    icon: widget.selectedIndex == 0
        ? Icons.home
        : Icons.home_outlined,
    text: 'Home',
  ),
  GButton(
    icon: widget.selectedIndex == 1
        ? Icons.search
        : Icons.search_outlined,
    text: 'Search',
  ),
  GButton(
    icon: widget.selectedIndex == 2
        ? Icons.interests
        : Icons.interests_outlined,
    text: 'Services',
  ),
  GButton(
    icon: widget.selectedIndex == 3
        ? Icons.person
        : Icons.person_outline,
    text: 'Profile',
  ),
],
          selectedIndex: widget.selectedIndex,
          onTabChange: widget.onDestinationSelected,
        ),
      ),
    );
  }
}

