import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // مكتبة تحديد مسار التخزين
import 'package:path/path.dart' as path; // مكتبة التعامل مع مسارات الملفات
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';

class AdminManageProductsScreen extends StatefulWidget {
  const AdminManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<AdminManageProductsScreen> createState() =>
      _AdminManageProductsScreenState();
}

class _AdminManageProductsScreenState extends State<AdminManageProductsScreen> {
  final ProductController productController = Get.find();

  // Controllers
  final TextEditingController nameArController = TextEditingController();
  final TextEditingController nameEnController = TextEditingController();
  final TextEditingController descriptionArController = TextEditingController();
  final TextEditingController descriptionEnController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  // Variables
  int? selectedCategoryId;
  Product? editingProduct;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.manageProducts),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Form Section ---
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.addEditProduct,
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
                        labelText: AppStrings.productNameAr,
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
                        labelText: AppStrings.productNameEn,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description AR
                    TextField(
                      controller: descriptionArController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppStrings.productDescriptionAr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description EN
                    TextField(
                      controller: descriptionEnController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppStrings.productDescriptionEn,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: AppStrings.price,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Image Picker Widget
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _pickedImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : (imageController.text.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageController.text.startsWith('assets')
                              ? Image.asset(
                            imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          )
                              : Image.file(
                            File(imageController.text),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          ),
                        )
                            : const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Dropdown
                    Obx(
                          () => DropdownButton<int>(
                        isExpanded: true,
                        value: selectedCategoryId,
                        hint: Text(AppStrings.selectCategory),
                        items: productController.categories
                            .map((category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.nameAr), // Prefer Arabic Name here
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedCategoryId = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          editingProduct != null ? AppStrings.update : AppStrings.add,
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

          // --- List Section ---
          Expanded(
            child: Obx(
                  () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  var product = productController.products[index];
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
                                product.nameAr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price} ${AppStrings.rial}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProduct(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProduct(product.id!),
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

  // --- Logic Functions ---

  // 1. اختيار الصورة من المعرض
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
        // نعرض الصورة المؤقتة حالياً حتى يتم الحفظ
        imageController.text = image.path;
      });
    }
  }

  // 2. دالة جديدة: حفظ الصورة بشكل دائم في مجلد التطبيق
  Future<String> _saveImagePermanently(File imageFile) async {
    // الحصول على مسار مجلد المستندات الخاص بالتطبيق
    final directory = await getApplicationDocumentsDirectory();

    // إنشاء اسم فريد للصورة باستخدام التوقيت الحالي
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';

    // المسار الجديد الكامل
    final String newPath = path.join(directory.path, fileName);

    // نسخ الصورة إلى المسار الجديد
    final File newImage = await imageFile.copy(newPath);

    return newImage.path;
  }

  // 3. حفظ المنتج (إضافة أو تعديل)
  void _submitProduct() async {
    if (nameArController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategoryId == null) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.fillAllFields,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String finalImagePath = imageController.text;

    // 🔥 التعديل الجوهري هنا:
    // إذا قام المستخدم باختيار صورة جديدة من المعرض، نقوم بحفظها بشكل دائم
    if (_pickedImage != null) {
      finalImagePath = await _saveImagePermanently(_pickedImage!);
    }

    Product product = Product(
      id: editingProduct?.id,
      nameAr: nameArController.text,
      nameEn: nameEnController.text,
      descriptionAr: descriptionArController.text,
      descriptionEn: descriptionEnController.text,
      price: double.parse(priceController.text),
      image: finalImagePath, // نستخدم المسار الدائم
      categoryId: selectedCategoryId!,
    );

    bool success;
    if (editingProduct != null) {
      success = await productController.updateProduct(product);
    } else {
      success = await productController.addProduct(product);
    }

    if (success) {
      Get.snackbar(
        AppStrings.success,
        editingProduct != null ? AppStrings.updated : AppStrings.added,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      _clearForm();
    }
  }

  void _editProduct(Product product) {
    setState(() {
      editingProduct = product;
      nameArController.text = product.nameAr;
      nameEnController.text = product.nameEn;
      descriptionArController.text = product.descriptionAr ?? '';
      descriptionEnController.text = product.descriptionEn ?? '';
      priceController.text = product.price.toString();
      imageController.text = product.image;
      selectedCategoryId = product.categoryId;
      _pickedImage = null; // تفريغ الصورة المختارة عند وضع التعديل
    });
  }

  void _deleteProduct(int productId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete),
        content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
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
      bool success = await productController.deleteProduct(productId);
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
    descriptionArController.clear();
    descriptionEnController.clear();
    priceController.clear();
    imageController.clear();
    setState(() {
      selectedCategoryId = null;
      editingProduct = null;
      _pickedImage = null;
    });
  }

  @override
  void dispose() {
    nameArController.dispose();
    nameEnController.dispose();
    descriptionArController.dispose();
    descriptionEnController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }
}