// lib/screens/order_detail_screen.dart
import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _orderService = OrderService();

  Order? _order;
  bool _isLoading = true;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    setState(() => _isLoading = true);

    final order = await _orderService.getOrderById(widget.orderId);

    setState(() {
      _order = order;
      _isLoading = false;
    });
  }

  Future<void> _cancelOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isCancelling = true);

      final result = await _orderService.cancelOrder(widget.orderId);

      setState(() => _isCancelling = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['success']
                  ? 'Order cancelled successfully'
                  : result['error'] ?? 'Failed to cancel order',
            ),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (result['success']) {
          _loadOrderDetail();
        }
      }
    }
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
        title: Text('Order #${widget.orderId}'),
        backgroundColor: const Color(0xFF7B2CBF),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _order == null
          ? _buildErrorState()
          : _buildOrderDetail(),
    );
  }

  Widget _buildOrderDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusSection(),
          const Divider(height: 1),
          _buildItemsSection(),
          const Divider(height: 1),
          _buildPricingSection(),
          if (_order!.status.toLowerCase() == 'processing')
            _buildCancelButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: _getStatusColor(_order!.status).withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(_order!.status),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(_order!.status),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _order!.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(_order!.status),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ordered on ${_formatDate(_order!.createdAt)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusTimeline(),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final statuses = ['processing', 'shipped', 'delivered'];
    final currentIndex = statuses.indexOf(_order!.status.toLowerCase());

    if (currentIndex == -1) return const SizedBox.shrink();

    return Column(
      children: List.generate(statuses.length, (index) {
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? _getStatusColor(_order!.status)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                      : null,
                ),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    color: isCompleted
                        ? _getStatusColor(_order!.status)
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Text(
              statuses[index].toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCompleted ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _order!.items.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final item = _order!.items[index];
              final product = item.product;

              return Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? 'Product',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${item.quantity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${item.price.toStringAsFixed(2)} × ${item.quantity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B2CBF),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildPriceRow('Subtotal', _order!.totalAmount),
          const SizedBox(height: 8),
          _buildPriceRow('Delivery Charges', 0.0, isFree: true),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _order!.formattedTotal,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B2CBF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        isFree
            ? const Text(
          'FREE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        )
            : Text(
          '₹${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: _isCancelling ? null : _cancelOrder,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isCancelling
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.red,
            ),
          )
              : const Text(
            'CANCEL ORDER',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Order not found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Icons.access_time;
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

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}