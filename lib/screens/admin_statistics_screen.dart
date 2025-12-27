import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../controllers/product_controller.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';

class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find();
    final ProductController productController = Get.find();

    // Ensure we have the latest orders
    orderController.loadAllOrders();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.statistics),
        centerTitle: true,
      ),
      body: Obx(() {
        final orders = orderController.orders;
        
        // Calculate Statistics
        final totalOrders = orders.length;
        final pendingOrders = orders.where((o) => o.status == 'pending').length;
        final completedOrders = orders.where((o) => o.status == 'completed').length;
        
        double totalRevenue = 0;
        for (var order in orders) {
          var product = productController.products.firstWhereOrNull((p) => p.id == order.productId);
          if (product != null) {
            totalRevenue += product.price;
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Total Revenue Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.totalRevenue,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${totalRevenue.toStringAsFixed(2)} ${AppStrings.rial}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Grid of Stats
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    AppStrings.totalOrders,
                    totalOrders.toString(),
                    Icons.shopping_cart,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    AppStrings.pending,
                    pendingOrders.toString(),
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    AppStrings.completed,
                    completedOrders.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _buildStatCard(
                    AppStrings.products,
                    productController.products.length.toString(),
                    Icons.inventory_2,
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
