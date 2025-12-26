// lib/screens/orders_screen.dart
// Order history with status tracking

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _activeOrders = [];
  List<Map<String, dynamic>> _completedOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Load orders from API

      // Mock data
      await Future.delayed(Duration(seconds: 1));

      _activeOrders = [
        {
          'id': 'BKS12345',
          'order_number': '#BKS12345',
          'date': DateTime.now().subtract(Duration(days: 1)),
          'status': 'processing',
          'items_count': 3,
          'total_amount': 1870.0,
          'items': [
            {'name': 'Premium Cake Box', 'quantity': 2},
            {'name': 'Cupcake Boxes', 'quantity': 1},
          ],
          'delivery_date': DateTime.now().add(Duration(days: 2)),
        },
        {
          'id': 'BKS12344',
          'order_number': '#BKS12344',
          'date': DateTime.now().subtract(Duration(days: 3)),
          'status': 'shipped',
          'items_count': 2,
          'total_amount': 1425.0,
          'items': [
            {'name': 'Baker\'s Flour - 25kg', 'quantity': 1},
          ],
          'delivery_date': DateTime.now().add(Duration(days: 1)),
        },
      ];

      _completedOrders = [
        {
          'id': 'BKS12343',
          'order_number': '#BKS12343',
          'date': DateTime.now().subtract(Duration(days: 15)),
          'status': 'delivered',
          'items_count': 4,
          'total_amount': 2340.0,
          'items': [
            {'name': 'Premium Cake Box', 'quantity': 3},
            {'name': 'Cupcake Boxes', 'quantity': 1},
          ],
          'delivered_date': DateTime.now().subtract(Duration(days: 10)),
        },
        {
          'id': 'BKS12342',
          'order_number': '#BKS12342',
          'date': DateTime.now().subtract(Duration(days: 30)),
          'status': 'delivered',
          'items_count': 2,
          'total_amount': 980.0,
          'items': [
            {'name': 'Cake Boxes - 8 inch', 'quantity': 2},
          ],
          'delivered_date': DateTime.now().subtract(Duration(days: 25)),
        },
      ];

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load orders'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B73FF), Color(0xFF9F7FFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Orders',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_activeOrders.length + _completedOrders.length} total orders',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab, // Fill the tab
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Color(0xFF6B73FF),
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      dividerColor: Colors.transparent, // Remove divider
                      tabs: [
                        Tab(text: 'Active (${_activeOrders.length})'),
                        Tab(text: 'Completed (${_completedOrders.length})'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Tab Views
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF6B73FF)))
                : TabBarView(
              controller: _tabController,
              children: [
                // Active Orders
                _buildOrdersList(_activeOrders, isActive: true),

                // Completed Orders
                _buildOrdersList(_completedOrders, isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return _buildEmptyState(isActive);
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: Color(0xFF6B73FF),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(orders[index], isActive: isActive);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {required bool isActive}) {
    final status = order['status'];
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Order Number
                  Text(
                    order['order_number'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B7280)),
                  SizedBox(width: 6),
                  Text(
                    _formatDate(order['date']),
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Items Preview
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order['items'].take(2).map<Widget>((item) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Color(0xFF6B73FF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${item['name']} (${item['quantity']}x)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    if (order['items'].length > 2)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '+${order['items'].length - 2} more items',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B73FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '₹${order['total_amount'].toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B73FF),
                        ),
                      ),
                    ],
                  ),

                  // View Details Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF6B73FF),
                      side: BorderSide(color: Color(0xFF6B73FF)),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('View Details'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isActive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? Icons.shopping_bag_outlined : Icons.check_circle_outline,
            size: 100,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 24),
          Text(
            isActive ? 'No Active Orders' : 'No Completed Orders',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12),
          Text(
            isActive
                ? 'Your active orders will appear here'
                : 'Your order history will appear here',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          if (isActive) ...[
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B73FF),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Start Shopping'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'processing':
        return Color(0xFFF59E0B); // Orange
      case 'shipped':
        return Color(0xFF3B82F6); // Blue
      case 'delivered':
        return Color(0xFF10B981); // Green
      case 'cancelled':
        return Color(0xFFEF4444); // Red
      default:
        return Color(0xFF6B7280); // Gray
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}