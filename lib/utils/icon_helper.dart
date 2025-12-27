import 'package:flutter/material.dart';

class IconHelper {
  static const Map<String, IconData> iconMap = {
    'wardrobe': Icons.checkroom,
    'kitchen': Icons.kitchen,
    'bed': Icons.bed,
    'chair': Icons.chair,
    'table': Icons.table_restaurant,
    'sofa': Icons.weekend,
    'home': Icons.home,
    'star': Icons.star,
    'favorite': Icons.favorite,
    'settings': Icons.settings,
    'light': Icons.lightbulb,
    'tv': Icons.tv,
    'computer': Icons.computer,
    'phone': Icons.phone_android,
    'book': Icons.menu_book,
    'coffee': Icons.coffee,
    'local_cafe': Icons.local_cafe,
    'restaurant': Icons.restaurant,
    'shopping_bag': Icons.shopping_bag,
    'store': Icons.store,
    'build': Icons.build,
    'brush': Icons.brush,
    'design_services': Icons.design_services,
    'inventory': Icons.inventory_2,
    'cabinet': Icons.shelves,
  };

  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return Icons.category;
    }
    return iconMap[iconName] ?? Icons.category;
  }
}
