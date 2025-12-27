import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // مهم جداً: تمت إضافته للتحكم بشريط الحالة
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/language_controller.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';
import 'utils/localization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // نقوم بتهيئة الكنترولر هنا لنستطيع استخدام قيمته في themeMode
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() { // نستخدم Obx ليعيد بناء التطبيق عند تغيير الثيم
      return GetMaterialApp(
        title: 'أبو زياد',
        debugShowCheckedModeBanner: false,

        // Initialize Other Controllers
        initialBinding: BindingsBuilder(() {
          Get.put(AuthController());
          // ThemeController تم حقنه بالأعلى
          Get.put(LanguageController());
        }),

        // --- إعدادات الثيم النهاري (Light Theme) ---
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.backgroundLight,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // شفاف ليظهر التدرج الخلفي
            foregroundColor: AppColors.textDarkLight,
            elevation: 0,
            // هذا هو الحل السحري لمنع الـ Lag 👇
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // الشريط شفاف
              statusBarIconBrightness: Brightness.dark, // الأيقونات سوداء
              statusBarBrightness: Brightness.light, // لـ iOS
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textDarkLight),
            bodyMedium: TextStyle(color: AppColors.textMediumLight),
          ),
        ),

        // --- إعدادات الثيم الليلي (Dark Theme) ---
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.backgroundDark,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // شفاف
            foregroundColor: AppColors.textDarkDark,
            elevation: 0,
            // إعدادات الشريط للوضع الليلي 👇
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light, // الأيقونات بيضاء
              statusBarBrightness: Brightness.dark, // لـ iOS
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textDarkDark),
            bodyMedium: TextStyle(color: AppColors.textMediumDark),
          ),
        ),

        // جعلنا الثيم ديناميكياً بناءً على الكنترولر
        themeMode: themeController.theme,

        // Localization
        locale: const Locale('ar', 'SA'),
        fallbackLocale: const Locale('ar', 'SA'),
        translations: AppTranslations(),

        // Home
        home: const SplashScreen(),
      );
    });
  }
}