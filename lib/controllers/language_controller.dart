import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  late SharedPreferences _prefs;
  var isArabic = true.obs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    isArabic.value = _prefs.getBool('isArabic') ?? true;
    setLanguage(isArabic.value);
  }

  void toggleLanguage() {
    isArabic.value = !isArabic.value;
    _prefs.setBool('isArabic', isArabic.value);
    setLanguage(isArabic.value);
  }

  void setLanguage(bool arabic) {
    if (arabic) {
      Get.updateLocale(const Locale('ar', 'SA'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }
}
