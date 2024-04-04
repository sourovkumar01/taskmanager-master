import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Controller_Binder.dart';
import 'package:taskmanager/Presentation/Screens/Splash_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';

class TaskManager extends StatelessWidget {
  TaskManager({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManager.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Task Manager",
      home: const SplashScreen(),
      theme: _themeData,
      initialBinding: ControllerBinder(),
    );
  }
  final ThemeData _themeData = ThemeData(
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(backgroundColor: ColorDarkBlue),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: ColorWhite,
          hintStyle: const TextStyle(color: ColorLightGray)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorGreen,
            foregroundColor: ColorWhite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorGreen,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: ColorDarkBlue)));
}
