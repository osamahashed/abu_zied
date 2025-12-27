import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/database_helper.dart';

class ProductController extends GetxController {
  final dbHelper = DatabaseHelper.instance;

  var products = <Product>[].obs;
  var categories = <Category>[].obs;
  var filteredProducts = <Product>[].obs;
  var selectedCategory = Rx<Category?>(null);
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadProducts();
  }

  // Load all categories
  Future<void> loadCategories() async {
    try {
      List<Map<String, dynamic>> result = await dbHelper.getAllCategories();
      categories.value = result.map((cat) => Category.fromMap(cat)).toList();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Load all products
  Future<void> loadProducts() async {
    try {
      List<Map<String, dynamic>> result = await dbHelper.getAllProducts();
      products.value = result.map((prod) => Product.fromMap(prod)).toList();
      filteredProducts.value = products;
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  // Load products by category
  Future<void> loadProductsByCategory(int categoryId) async {
    try {
      List<Map<String, dynamic>> result =
          await dbHelper.getProductsByCategory(categoryId);
      filteredProducts.value =
          result.map((prod) => Product.fromMap(prod)).toList();
    } catch (e) {
      print('Error loading products by category: $e');
    }
  }

  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) =>
              product.nameAr.contains(query) ||
              product.nameEn.contains(query))
          .toList();
    }
  }

  // Filter by category
  void filterByCategory(Category? category) {
    selectedCategory.value = category;
    if (category == null) {
      filteredProducts.value = products;
    } else {
      loadProductsByCategory(category.id!);
    }
  }

  // Add product (Admin only)
  Future<bool> addProduct(Product product) async {
    try {
      await dbHelper.insertProduct(product.toMap());
      await loadProducts();
      return true;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Update product (Admin only)
  Future<bool> updateProduct(Product product) async {
    try {
      await dbHelper.updateProduct(product.toMap());
      await loadProducts();
      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Delete product (Admin only)
  Future<bool> deleteProduct(int productId) async {
    try {
      await dbHelper.deleteProduct(productId);
      await loadProducts();
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Add category (Admin only)
  Future<bool> addCategory(Category category) async {
    try {
      await dbHelper.insertCategory(category.toMap());
      await loadCategories();
      return true;
    } catch (e) {
      print('Error adding category: $e');
      return false;
    }
  }

  // Update category (Admin only)
  Future<bool> updateCategory(Category category) async {
    try {
      await dbHelper.updateCategory(category.toMap());
      await loadCategories();
      return true;
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  // Delete category (Admin only)
  Future<bool> deleteCategory(int categoryId) async {
    try {
      await dbHelper.deleteCategory(categoryId);
      await loadCategories();
      return true;
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }
}
