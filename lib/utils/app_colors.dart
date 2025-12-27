import 'package:flutter/material.dart';

class AppColors {
  // --- الخيار 1: الفخامة العصرية (كحلي غامق وذهبي) ---
  // يعطي شعوراً بالثقة، الاحترافية، والفخامة. مناسب جداً لتطبيقات الديكور.

  // Primary Colors (الهوية الرئيسية)
  static const Color primary = Color(0xFF1A237E); // كحلي ملكي غامق (ممتاز للتدرج)
  static const Color primaryDark = Color(0xFF121959); // درجة أغمق للتدرجات
  static const Color secondary = Color(0xFFD4AF37); // ذهبي كلاسيكي (للأزرار والأسعار)
  static const Color secondaryLight = Color(0xFFFFD54F); // ذهبي فاتح (للتوهج)

  // Light Theme Colors (الوضع النهاري)
  static const Color backgroundLight = Color(0xFFF8F9FA); // ليس أبيض ناصعاً، بل رمادي ثلجي مريح
  static const Color surfaceLight = Color(0xFFFFFFFF); // البطاقات بيضاء
  static const Color textDarkLight = Color(0xFF2D3436); // نص أسود فحمي (أسهل للقراءة)
  static const Color textMediumLight = Color(0xFF636E72); // رمادي متوسط
  static const Color textLightLight = Color(0xFFB2BEC3);
  static const Color borderLight = Color(0xFFE9ECEF); // حدود ناعمة جداً

  // Dark Theme Colors (الوضع الليلي)
  static const Color backgroundDark = Color(0xFF121212); // أسود مع لمسة رمادية (Material Design)
  static const Color surfaceDark = Color(0xFF1E1E2C); // كحلي مسود للبطاقات (فخم جداً)
  static const Color textDarkDark = Color(0xFFF5F5F5); // أبيض
  static const Color textMediumDark = Color(0xFFB0BEC5); // رمادي فضي
  static const Color textLightDark = Color(0xFF546E7A);
  static const Color borderDark = Color(0xFF2C3E50);

  // Accent Colors (ألوان التنبيهات)
  static const Color success = Color(0xFF00B894); // أخضر زمردي
  static const Color error = Color(0xFFFF7675); // أحمر ناعم
  static const Color warning = Color(0xFFFDCB6E); // أصفر شمس
  static const Color info = Color(0xFF74B9FF); // أزرق سماوي

  // Transparent
  static const Color transparent = Color(0x00000000);
}