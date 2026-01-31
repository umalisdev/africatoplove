import 'package:dating_app/presentation/screens/home_screen.dart';
import 'package:dating_app/core/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocalizationManager(),
      child: const SparkMatchApp(),
    ),
  );
}

class SparkMatchApp extends StatelessWidget {
  const SparkMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationManager>(
      builder: (context, localization, child) {
        return MaterialApp(
          title: localization.tr('app_name'),
          debugShowCheckedModeBanner: false,
          locale: localization.locale,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            primaryColor: const Color(0xFFFE3C72),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black54),
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE3C72),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
            ),
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Color(0xFFFE3C72),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
