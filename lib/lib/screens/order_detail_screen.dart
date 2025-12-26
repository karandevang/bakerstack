// lib/screens/order_detail_screen.dart
// Detailed order view with tracking and actions

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  OrderDetailScreen({required this.order});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Map<String, dynamic> _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final status = _order['status'];
    final isDelivered = status == 'delivered';

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
              child: Padding(
                padding: EdgeInsets.all(20),
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
                            'Order Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _order['order_number'],
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
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Status Card
                  _buildStatusCard(),
                  SizedBox(height: 16),

                  // Tracking Timeline (if not delivered)
                  if (!isDelivered) ...[
                    _buildTrackingTimeline(),
                    SizedBox(height: 16),
                  ],

                  // Delivery Address
                  _buildSectionTitle('Delivery Address'),
                  SizedBox(height: 12),
                  _buildDeliveryAddress(),
                  SizedBox(height: 16),

                  // Order Items
                  _buildSectionTitle('Order Items'),
                  SizedBox(height: 12),
                  _buildOrderItems(),
                  SizedBox(height: 16),

                  // Payment Summary
                  _buildSectionTitle('Payment Summary'),
                  SizedBox(height: 12),
                  _buildPaymentSummary(),
                  SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Buttons
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildStatusCard() {
    final status = _order['status'];
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [statusColor, statusColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getStatusIcon(status),
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getStatusMessage(status),
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
          if (_order['delivery_date'] != null && status != 'delivered') ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Expected delivery: ${_formatDeliveryDate(_order['delivery_date'])}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    final status = _order['status'];
    final steps = [
      {'name': 'Order Placed', 'completed': true},
      {'name': 'Processing', 'completed': status != 'processing'},
      {'name': 'Shipped', 'completed': status == 'shipped' || status == 'delivered'},
      {'name': 'Delivered', 'completed': status == 'delivered'},
    ];

    return Container(
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Tracking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;
            final isCompleted = step['completed'] as bool;

            return _buildTimelineStep(
              step['name'] as String,
              isCompleted,
              isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, bool isCompleted, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Color(0xFF6B73FF) : Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Color(0xFF6B73FF) : Color(0xFFE5E7EB),
              ),
          ],
        ),
        SizedBox(width: 16),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
              color: isCompleted ? Color(0xFF1A1A1A) : Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF6B73FF), size: 20),
              SizedBox(width: 8),
              Text(
                'Karan Patel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '123, Baker Street, Near Central Mall',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          Text(
            'Mumbai, Maharashtra - 400001',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Color(0xFF6B7280)),
              SizedBox(width: 6),
              Text(
                '+91 9876543210',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    // Expand the items list for detail view
    final items = [
      {'name': 'Premium Cake Box - 10 inch White', 'quantity': 2, 'price': 245.0},
      {'name': 'Cupcake Boxes - 6 Cavity Clear', 'quantity': 1, 'price': 180.0},
      {'name': 'Baker\'s Flour - 25kg Premium Grade', 'quantity': 1, 'price': 1200.0},
    ];

    return Container(
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Quantity Badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF6B73FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${item['quantity']}x',
                      style: TextStyle(
                        color: Color(0xFF6B73FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹${item['price']} each',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                // Item Total
                Text(
                  '₹${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final subtotal = _order['total_amount'] - 50.0; // Assuming ₹50 delivery fee
    final deliveryFee = 50.0;
    final total = _order['total_amount'];

    return Container(
      padding: EdgeInsets.all(20),
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
      child: Column(
        children: [
          _buildPriceRow('Subtotal', subtotal),
          SizedBox(height: 12),
          _buildPriceRow('Delivery Fee', deliveryFee),
          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B73FF),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                SizedBox(width: 8),
                Text(
                  'Payment: Cash on Delivery',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomActions() {
    final status = _order['status'];

    if (status == 'delivered') {
      return null; // No actions for delivered orders
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Cancel Order (only for processing)
            if (status == 'processing')
              Expanded(
                child: OutlinedButton(
                  onPressed: _showCancelDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFEF4444),
                    side: BorderSide(color: Color(0xFFEF4444), width: 2),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            if (status == 'processing') SizedBox(width: 12),

            // Track Order / Need Help
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Customer support: +91 1800-123-4567'),
                      backgroundColor: Color(0xFF6B73FF),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B73FF),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Need Help?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'processing':
        return Color(0xFFF59E0B);
      case 'shipped':
        return Color(0xFF3B82F6);
      case 'delivered':
        return Color(0xFF10B981);
      case 'cancelled':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'processing':
        return Icons.hourglass_empty;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
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

  String _getStatusMessage(String status) {
    switch (status) {
      case 'processing':
        return 'Your order is being prepared';
      case 'shipped':
        return 'Your order is on the way';
      case 'delivered':
        return 'Order has been delivered';
      case 'cancelled':
        return 'Order was cancelled';
      default:
        return '';
    }
  }

  String _formatDeliveryDate(DateTime date) {
    final days = date.difference(DateTime.now()).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Order?'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order cancelled successfully'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}