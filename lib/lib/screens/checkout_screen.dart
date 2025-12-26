// lib/screens/checkout_screen.dart
// Checkout with address selection and order summary

import 'package:bakerstack/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'delivery_addresses_screen.dart';
// import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _selectedAddress;
  List<Map<String, dynamic>> _cartItems = [];
  double _subtotal = 0.0;
  double _deliveryFee = 50.0;
  double _discount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
  }

  Future<void> _loadCheckoutData() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Load cart and default address from API

      // Mock data
      await Future.delayed(Duration(seconds: 1));

      _selectedAddress = {
        'id': '1',
        'full_name': 'Karan Patel',
        'phone': '+91 9876543210',
        'address_line1': '123, Baker Street',
        'address_line2': 'Near Central Mall',
        'city': 'Mumbai',
        'state': 'Maharashtra',
        'pincode': '400001',
      };

      _cartItems = [
        {
          'id': '1',
          'name': 'Premium Cake Box - 10 inch',
          'quantity': 2,
          'price': 245.0,
        },
        {
          'id': '2',
          'name': 'Cupcake Boxes - 6 Cavity',
          'quantity': 1,
          'price': 180.0,
        },
      ];

      _calculateTotals();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load checkout data'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  void _calculateTotals() {
    _subtotal = _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double get _total => _subtotal + _deliveryFee - _discount;

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
                    Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF6B73FF)))
                : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  _buildSectionTitle('Delivery Address'),
                  SizedBox(height: 12),
                  _buildAddressCard(),
                  SizedBox(height: 24),

                  // Order Summary Section
                  _buildSectionTitle('Order Summary'),
                  SizedBox(height: 12),
                  _buildOrderSummary(),
                  SizedBox(height: 24),

                  // Price Details Section
                  _buildSectionTitle('Price Details'),
                  SizedBox(height: 12),
                  _buildPriceDetails(),
                  SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Button
      bottomNavigationBar: _isLoading
          ? null
          : Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Total Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹${_total.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B73FF),
                        ),
                      ),
                    ],
                  ),

                  // Proceed Button
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed: _selectedAddress == null ? null : _proceedToPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6B73FF),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Proceed to Payment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
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

  Widget _buildAddressCard() {
    if (_selectedAddress == null) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFEF4444), width: 2),
        ),
        child: Column(
          children: [
            Icon(Icons.location_off, size: 48, color: Color(0xFFEF4444)),
            SizedBox(height: 12),
            Text(
              'No delivery address selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please add a delivery address',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: _navigateToAddresses,
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF6B73FF),
                side: BorderSide(color: Color(0xFF6B73FF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Add Address'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF6B73FF), width: 2),
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
              Expanded(
                child: Text(
                  _selectedAddress!['full_name'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              TextButton(
                onPressed: _navigateToAddresses,
                child: Text('Change'),
              ),
            ],
          ),
          SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Color(0xFF6B7280)),
              SizedBox(width: 8),
              Text(
                _selectedAddress!['phone'],
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          Text(
            '${_selectedAddress!['address_line1']}, ${_selectedAddress!['address_line2']}',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF374151),
              height: 1.4,
            ),
          ),
          Text(
            '${_selectedAddress!['city']}, ${_selectedAddress!['state']} - ${_selectedAddress!['pincode']}',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF374151),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
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
      child: Column(
        children: [
          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _cartItems.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Quantity Badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFF6B73FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${item['quantity']}x',
                          style: TextStyle(
                            color: Color(0xFF6B73FF),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Item name
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),

                    // Price
                    Text(
                      '₹${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails() {
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
        children: [
          _buildPriceRow('Subtotal', _subtotal),
          SizedBox(height: 12),
          _buildPriceRow('Delivery Fee', _deliveryFee),
          if (_discount > 0) ...[
            SizedBox(height: 12),
            _buildPriceRow('Discount', -_discount, isDiscount: true),
          ],
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
                '₹${_total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B73FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
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
          '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 15,
            color: isDiscount ? Color(0xFF10B981) : Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _navigateToAddresses() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryAddressesScreen(),
      ),
    );

    // Reload if address was changed
    if (result != null) {
      _loadCheckoutData();
    }
  }

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          totalAmount: _total,
          addressId: _selectedAddress!['id'],
        ),
      ),
    );
    // TODO: Navigate to Contact Us Screen
  }
}