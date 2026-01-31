import 'package:dating_app/presentation/screens/discover_screen.dart';
import 'package:dating_app/presentation/screens/explore_screen.dart';
import 'package:dating_app/presentation/screens/matches_screen.dart';
import 'package:dating_app/presentation/screens/profile_screen.dart';
import 'package:dating_app/core/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DiscoverScreen(),
    const MatchesScreen(),
    const ExploreScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationManager>(context);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFE3C72),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_filled),
              activeIcon: const Icon(Icons.home_filled, size: 28),
              label: localization.tr('discover'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              activeIcon: const Icon(Icons.favorite, size: 28),
              label: localization.tr('matches'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore, size: 28),
              label: localization.tr('explore'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person, size: 28),
              label: localization.tr('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
