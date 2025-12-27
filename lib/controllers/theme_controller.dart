import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  late SharedPreferences _prefs;
  var isDarkMode = false.obs;

  // 1. هذا هو السطر الناقص الذي يسبب الخطأ الأحمر في main.dart
  // يقوم بإرجاع نوع الثيم (ليلي أو نهاري) بناءً على القيمة المحفوظة
  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    // قراءة القيمة المحفوظة، وإذا لم توجد نعتبرها false (نهاري)
    isDarkMode.value = _prefs.getBool('isDarkMode') ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _prefs.setBool('isDarkMode', isDarkMode.value);

    // تغيير الثيم فعلياً في التطبيق
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // دوال الألوان (يمكنك استخدامها في main.dart إذا أردت فصل الكود)
  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF8B5A2B),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8B5A2B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF1E1E1E)),
        bodyMedium: TextStyle(color: Color(0xFF666666)),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF8B5A2B),
      scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D2D2D),
        foregroundColor: Color(0xFFF5F5F5),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF5F5F5)),
        bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
      ),
    );
  }
}