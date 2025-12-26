// lib/screens/payment_screen.dart
// Payment method selection and order placement

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String addressId;

  PaymentScreen({
    required this.totalAmount,
    required this.addressId,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cod';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cod',
      'name': 'Cash on Delivery',
      'subtitle': 'Pay when you receive',
      'icon': Icons.money,
      'enabled': true,
    },
    {
      'id': 'upi',
      'name': 'UPI',
      'subtitle': 'Google Pay, PhonePe, Paytm',
      'icon': Icons.account_balance_wallet,
      'enabled': true,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card,
      'enabled': true,
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'subtitle': 'All major banks',
      'icon': Icons.account_balance,
      'enabled': true,
    },
    {
      'id': 'wallet',
      'name': 'Wallet',
      'subtitle': 'Paytm, PhonePe, Amazon Pay',
      'icon': Icons.wallet,
      'enabled': true,
    },
  ];

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
                            'Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Choose payment method',
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
                  // Amount Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6B73FF), Color(0xFF9F7FFF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6B73FF).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '₹${widget.totalAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.account_balance_wallet,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Payment Methods
                  Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Payment Method Cards
                  ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)),

                  SizedBox(height: 100), // Space for button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Button
      bottomNavigationBar: Container(
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
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B73FF),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 24),
                SizedBox(width: 12),
                Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    final isEnabled = method['enabled'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isEnabled
            ? () {
          setState(() {
            _selectedPaymentMethod = method['id'];
          });
        }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Color(0xFF6B73FF) : Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Color(0xFF6B73FF).withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(0xFF6B73FF).withOpacity(0.1)
                      : Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  method['icon'],
                  color: isSelected ? Color(0xFF6B73FF) : Color(0xFF6B7280),
                  size: 24,
                ),
              ),
              SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? Color(0xFF1A1A1A) : Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      method['subtitle'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              // Radio Button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Color(0xFF6B73FF) : Color(0xFFD1D5DB),
                    width: 2,
                  ),
                  color: isSelected ? Color(0xFF6B73FF) : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    setState(() => _isProcessing = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // TODO: Create order via API
      // final order = await apiService.createOrder(
      //   addressId: widget.addressId,
      //   paymentMethod: _selectedPaymentMethod,
      // );

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isProcessing = false);

      // Show success dialog
      _showSuccessDialog();
    } catch (e) {
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Color(0xFF10B981),
                ),
              ),
              SizedBox(height: 24),

              // Success Message
              Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),

              Text(
                'Your order has been placed successfully. You will receive a confirmation email shortly.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              // Order ID
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order ID: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      '#BKS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6B73FF),
                        side: BorderSide(color: Color(0xFF6B73FF)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Continue Shopping'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to orders screen
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('View your order in "My Orders"'),
                            backgroundColor: Color(0xFF6B73FF),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B73FF),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('View Order'),
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
}