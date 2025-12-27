import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../services/database_helper.dart';

class OrderController extends GetxController {
  final dbHelper = DatabaseHelper.instance;

  var orders = <Order>[].obs;
  var userOrders = <Order>[].obs;

  // Create order
  Future<bool> createOrder(
    int userId,
    int productId,
    String? notes,
  ) async {
    try {
      Order newOrder = Order(
        userId: userId,
        productId: productId,
        notes: notes,
        orderDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        status: 'pending',
      );

      await dbHelper.insertOrder(newOrder.toMap());
      await loadAllOrders();
      return true;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  // Load all orders (Admin only)
  Future<void> loadAllOrders() async {
    try {
      List<Map<String, dynamic>> result = await dbHelper.getAllOrders();
      orders.value = result.map((order) => Order.fromMap(order)).toList();
    } catch (e) {
      print('Error loading orders: $e');
    }
  }

  // Load user orders
  Future<void> loadUserOrders(int userId) async {
    try {
      List<Map<String, dynamic>> result =
          await dbHelper.getOrdersByUser(userId);
      userOrders.value = result.map((order) => Order.fromMap(order)).toList();
    } catch (e) {
      print('Error loading user orders: $e');
    }
  }

  // Update order status (Admin only)
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      var order = await dbHelper.getOrderById(orderId);
      if (order != null) {
        Order updatedOrder = Order.fromMap(order);
        updatedOrder = Order(
          id: updatedOrder.id,
          userId: updatedOrder.userId,
          productId: updatedOrder.productId,
          notes: updatedOrder.notes,
          orderDate: updatedOrder.orderDate,
          status: status,
        );
        await dbHelper.updateOrder(updatedOrder.toMap());
        await loadAllOrders();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  // Delete order (Admin only)
  Future<bool> deleteOrder(int orderId) async {
    try {
      await dbHelper.deleteOrder(orderId);
      await loadAllOrders();
      return true;
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }
}
