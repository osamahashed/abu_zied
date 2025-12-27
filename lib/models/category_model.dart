import 'package:get/get.dart';

class Category {
  final int? id;
  final String nameAr;
  final String nameEn;
  final String? icon;

  String get name {
    if (Get.locale?.languageCode == 'ar') {
      return nameAr;
    }
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  Category({
    this.id,
    required this.nameAr,
    required this.nameEn,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      nameAr: map['name_ar'],
      nameEn: map['name_en'],
      icon: map['icon'],
    );
  }
}
