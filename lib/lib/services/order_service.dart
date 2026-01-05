
import 'package:http/http.dart';

import '../models/order.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final ApiService _api = ApiService();
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  /// Create new order from cart
  Future<Map<String, dynamic>> createOrder({
    int? addressId,
    String? notes,
  }) async {
    try {
      print('📦 Creating order...');

      final body = <String, dynamic>{};
      if (addressId != null) body['address_id'] = addressId;
      if (notes != null && notes.isNotEmpty) body['notes'] = notes;

      final response = await _api.post(
        ApiConfig.orders,
        body,
        auth: true,
      );

      if (response['success']) {
        final order = Order.fromJson(response['data']);
        print('✅ Order created: #${order.id}');
        return {
          'success': true,
          'order': order,
          'message': 'Order placed successfully!',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to create order',
        };
      }
    } catch (e) {
      print('❌ Error creating order: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get all orders
  Future<bool> fetchOrders({String? status}) async {
    try {
      print('📦 Fetching orders...');

      String endpoint = ApiConfig.orders;
      if (status != null && status.isNotEmpty) {
        endpoint += '?status=$status';
      }

      final response = await _api.get(endpoint, auth: true);

      if (response['success']) {
        final List<dynamic> data = response['data'];
        _orders = data.map((json) => Order.fromJson(json)).toList();
        print('✅ Orders loaded: ${_orders.length}');
        return true;
      } else {
        print('❌ Failed to fetch orders: ${response['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Error fetching orders: $e');
      return false;
    }
  }

  /// Get order by ID
  Future<Order?> getOrderById(int orderId) async {
    try {
      print('📦 Fetching order: $orderId');

      final response = await _api.get(
        '${ApiConfig.orders}/$orderId',
        auth: true,
      );

      if (response['success']) {
        return Order.fromJson(response['data']);
      } else {
        print('❌ Failed to fetch order: ${response['error']}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching order: $e');
      return null;
    }
  }

  /// Cancel order
  Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    try {
      print('📦 Cancelling order: $orderId');

      final response = await _api.patch(
        '${ApiConfig.orders}/$orderId/cancel',
        {},
        auth: true,
      );

      if (response['success']) {
        // Refresh orders
        await fetchOrders();
        return {
          'success': true,
          'message': 'Order cancelled successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to cancel order',
        };
      }
    } catch (e) {
      print('❌ Error cancelling order: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get orders by status
  Future<List<Order>> getOrdersByStatus(String status) async {
    await fetchOrders(status: status);
    return _orders;
  }

  /// Get processing orders
  Future<List<Order>> getProcessingOrders() async {
    return getOrdersByStatus('processing');
  }

  /// Get shipped orders
  Future<List<Order>> getShippedOrders() async {
    return getOrdersByStatus('shipped');
  }

  /// Get delivered orders
  Future<List<Order>> getDeliveredOrders() async {
    return getOrdersByStatus('delivered');
  }
}