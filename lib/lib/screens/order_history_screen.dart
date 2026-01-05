// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _orderService = OrderService();

  List<Order> _orders = [];
  bool _isLoading = true;
  String? _selectedStatus;

  final List<String> _statusFilters = [
    'All',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    await _orderService.fetchOrders(
      status: _selectedStatus == 'All' ? null : _selectedStatus,
    );

    setState(() {
      _orders = _orderService.orders;
      _isLoading = false;
    });
  }

  void _filterOrders(String? status) {
    setState(() {
      _selectedStatus = status;
    });
    _loadOrders();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: const Color(0xFF7B2CBF),
      ),
      body: Column(
        children: [
          _buildStatusFilter(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilters.length,
        itemBuilder: (context, index) {
          final status = _statusFilters[index];
          final isSelected = _selectedStatus == status ||
              (_selectedStatus == null && status == 'All');

          return GestureDetector(
            onTap: () => _filterOrders(status == 'All' ? null : status),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF7B2CBF)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  status == 'All' ? status : status.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/order-detail',
          arguments: {'orderId': order.id},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(order.createdAt),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Order Items
              Text(
                '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),

              // Total Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.formattedTotal,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B2CBF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // View Details Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/order-detail',
                      arguments: {'orderId': order.id},
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7B2CBF),
                    side: const BorderSide(color: Color(0xFF7B2CBF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('VIEW DETAILS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            _selectedStatus == null
                ? 'No orders yet'
                : 'No $_selectedStatus orders',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start shopping to see your orders here!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                    (route) => false,
              );
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B2CBF),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}