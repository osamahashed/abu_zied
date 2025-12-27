import 'package:get/get.dart';

class Product {
  final int? id;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final double price;
  final String image;
  final int categoryId;

  String get name {
    if (Get.locale?.languageCode == 'ar') {
      return nameAr;
    }
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  String get description {
    if (Get.locale?.languageCode == 'ar') {
      return descriptionAr ?? '';
    }
    return (descriptionEn != null && descriptionEn!.isNotEmpty)
        ? descriptionEn!
        : (descriptionAr ?? '');
  }

  Product({
    this.id,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.price,
    required this.image,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'price': price,
      'image': image,
      'category_id': categoryId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      nameAr: map['name_ar'],
      nameEn: map['name_en'],
      descriptionAr: map['description_ar'],
      descriptionEn: map['description_en'],
      price: map['price'].toDouble(),
      image: map['image'],
      categoryId: map['category_id'],
    );
  }
}
