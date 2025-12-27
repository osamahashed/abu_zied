import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../models/category_model.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';
import '../utils/icon_helper.dart';

class AdminManageCategoriesScreen extends StatefulWidget {
  const AdminManageCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AdminManageCategoriesScreen> createState() =>
      _AdminManageCategoriesScreenState();
}

class _AdminManageCategoriesScreenState
    extends State<AdminManageCategoriesScreen> {
  final ProductController productController = Get.find();
  final TextEditingController nameArController = TextEditingController();
  final TextEditingController nameEnController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  Category? editingCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppStrings.manageCategories),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Add/Edit Category Form
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      AppStrings.addEditCategory,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name AR
                    TextField(
                      controller: nameArController,
                      decoration: InputDecoration(
                        labelText: AppStrings.categoryNameAr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name EN
                    TextField(
                      controller: nameEnController,
                      decoration: InputDecoration(
                        labelText: AppStrings.categoryNameEn,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Icon
                    // Icon Picker
                    GestureDetector(
                      onTap: () => _showIconPicker(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              IconHelper.getIcon(iconController.text),
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                iconController.text.isEmpty
                                    ? AppStrings.selectIcon
                                    : iconController.text,
                                style: TextStyle(
                                  color: iconController.text.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitCategory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          editingCategory != null ? AppStrings.update : AppStrings.add,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Categories List
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: productController.categories.length,
                itemBuilder: (context, index) {
                  var category = productController.categories[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.nameAr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.nameEn,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editCategory(category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCategory(category.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitCategory() async {
    if (nameArController.text.isEmpty) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.fillCategoryNameAr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Category category = Category(
      id: editingCategory?.id,
      nameAr: nameArController.text,
      nameEn: nameEnController.text,
      icon: iconController.text,
    );

    bool success;
    if (editingCategory != null) {
      success = await productController.updateCategory(category);
    } else {
      success = await productController.addCategory(category);
    }

    if (success) {
      Get.snackbar(
        AppStrings.success,
        editingCategory != null ? AppStrings.updated : AppStrings.added,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      _clearForm();
    }
  }

  void _editCategory(Category category) {
    setState(() {
      editingCategory = category;
      nameArController.text = category.nameAr;
      nameEnController.text = category.nameEn;
      iconController.text = category.icon ?? '';
    });
  }

  void _deleteCategory(int categoryId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete),
        content: const Text('هل أنت متأكد من حذف هذه الفئة؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bool success = await productController.deleteCategory(categoryId);
      if (success) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.deleted,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  void _clearForm() {
    nameArController.clear();
    nameEnController.clear();
    iconController.clear();
    setState(() {
      editingCategory = null;
    });
  }

  void _showIconPicker() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              Text(
                AppStrings.selectIcon,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: IconHelper.iconMap.length,
                  itemBuilder: (context, index) {
                    final String key = IconHelper.iconMap.keys.elementAt(index);
                    final IconData icon = IconHelper.iconMap.values.elementAt(index);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          iconController.text = key;
                        });
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: iconController.text == key
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameArController.dispose();
    nameEnController.dispose();
    iconController.dispose();
    super.dispose();
  }
}
