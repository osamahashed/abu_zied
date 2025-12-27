import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';
import 'admin_manage_products_screen.dart';
import 'admin_manage_categories_screen.dart';
import 'orders_screen.dart';
import 'admin_statistics_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppStrings.adminPanel),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.adminPanel,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Admin Menu Cards
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                // Manage Categories
                _buildAdminCard(
                  title: AppStrings.manageCategories,
                  icon: Icons.category,
                  onTap: () {
                    Get.to(() => const AdminManageCategoriesScreen());
                  },
                ),
                // Manage Products
                _buildAdminCard(
                  title: AppStrings.manageProducts,
                  icon: Icons.shopping_bag,
                  onTap: () {
                    Get.to(() => const AdminManageProductsScreen());
                  },
                ),
                // View Orders
                _buildAdminCard(
                  title: AppStrings.viewOrders,
                  icon: Icons.list,
                  onTap: () {
                    Get.to(() => const OrdersScreen());
                  },
                ),
                // Statistics
                _buildAdminCard(
                  title: AppStrings.statistics,
                  icon: Icons.bar_chart,
                  onTap: () {
                    Get.to(() => const AdminStatisticsScreen());
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Statistics Section
            Text(
              AppStrings.statistics,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    AppStrings.categories,
                    productController.categories.length.toString(),
                  ),
                  _buildStatCard(
                    AppStrings.products,
                    productController.products.length.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
