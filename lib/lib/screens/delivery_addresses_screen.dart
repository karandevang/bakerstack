// lib/screens/delivery_addresses_screen.dart
// Manage multiple delivery addresses

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class DeliveryAddressesScreen extends StatefulWidget {
  @override
  _DeliveryAddressesScreenState createState() => _DeliveryAddressesScreenState();
}

class _DeliveryAddressesScreenState extends State<DeliveryAddressesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _addresses = [];
  String? _defaultAddressId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Replace with actual API call
      // final data = await apiService.getAddresses();

      // Mock data
      await Future.delayed(Duration(seconds: 1));
      _addresses = [
        {
          'id': '1',
          'full_name': 'Karan Patel',
          'phone': '+91 9876543210',
          'address_line1': '123, Baker Street',
          'address_line2': 'Near Central Mall',
          'city': 'Mumbai',
          'state': 'Maharashtra',
          'pincode': '400001',
          'is_default': true,
        },
        {
          'id': '2',
          'full_name': 'Karan Patel',
          'phone': '+91 9876543210',
          'address_line1': '456, Business Park',
          'address_line2': 'Tower B, 5th Floor',
          'city': 'Mumbai',
          'state': 'Maharashtra',
          'pincode': '400070',
          'is_default': false,
        },
      ];

      _defaultAddressId = _addresses.firstWhere((a) => a['is_default'])['id'];

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load addresses'),
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
                            'Delivery Addresses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_addresses.length} saved addresses',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                      onPressed: () => _showAddAddressDialog(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6B73FF),
              ),
            )
                : _addresses.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadAddresses,
              color: Color(0xFF6B73FF),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  return _buildAddressCard(_addresses[index]);
                },
              ),
            ),
          ),
        ],
      ),

      // FAB to add address
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(),
        backgroundColor: Color(0xFF6B73FF),
        child: Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    final isDefault = address['id'] == _defaultAddressId;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDefault
            ? Border.all(color: Color(0xFF6B73FF), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Spacer(),

                // Default Badge
                if (isDefault)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),

            // Full Name
            Text(
              address['full_name'],
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 4),

            // Phone
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Color(0xFF6B7280)),
                SizedBox(width: 6),
                Text(
                  address['phone'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Address
            Text(
              '${address['address_line1']}, ${address['address_line2']}',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${address['city']}, ${address['state']} - ${address['pincode']}',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                // Set as Default
                if (!isDefault)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _setAsDefault(address['id']),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6B73FF),
                        side: BorderSide(color: Color(0xFF6B73FF)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Set as Default'),
                    ),
                  ),

                if (!isDefault) SizedBox(width: 8),

                // Edit Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editAddress(address),
                    icon: Icon(Icons.edit_outlined, size: 18),
                    label: Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF6B7280),
                      side: BorderSide(color: Color(0xFFD1D5DB)),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // Delete Button
                IconButton(
                  onPressed: () => _deleteAddress(address),
                  icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFFEF4444).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
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
            Icons.location_on_outlined,
            size: 100,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 24),
          Text(
            'No Addresses Saved',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Add a delivery address to\nget your orders delivered',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressDialog(),
            icon: Icon(Icons.add),
            label: Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B73FF),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(String addressId) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: API call
      // await apiService.setDefaultAddress(addressId);

      setState(() {
        _defaultAddressId = addressId;
        for (var addr in _addresses) {
          addr['is_default'] = addr['id'] == addressId;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Default address updated'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update default address'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  void _editAddress(Map<String, dynamic> address) {
    _showAddAddressDialog(existingAddress: address);
  }

  void _deleteAddress(Map<String, dynamic> address) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Address?'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final apiService = Provider.of<ApiService>(context, listen: false);
        // TODO: API call
        // await apiService.deleteAddress(address['id']);

        setState(() {
          _addresses.remove(address);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address deleted'),
            backgroundColor: Color(0xFF6B7280),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete address'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showAddAddressDialog({Map<String, dynamic>? existingAddress}) {
    final isEditing = existingAddress != null;

    // Controllers
    final fullNameController = TextEditingController(text: existingAddress?['full_name']);
    final phoneController = TextEditingController(text: existingAddress?['phone']);
    final line1Controller = TextEditingController(text: existingAddress?['address_line1']);
    final line2Controller = TextEditingController(text: existingAddress?['address_line2']);
    final cityController = TextEditingController(text: existingAddress?['city']);
    final stateController = TextEditingController(text: existingAddress?['state']);
    final pincodeController = TextEditingController(text: existingAddress?['pincode']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    isEditing ? 'Edit Address' : 'Add New Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Full Name', fullNameController),
                    SizedBox(height: 16),
                    _buildTextField('Phone Number', phoneController, keyboardType: TextInputType.phone),
                    SizedBox(height: 16),
                    _buildTextField('Address Line 1', line1Controller),
                    SizedBox(height: 16),
                    _buildTextField('Address Line 2 (Optional)', line2Controller),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('City', cityController)),
                        SizedBox(width: 12),
                        Expanded(child: _buildTextField('State', stateController)),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildTextField('Pincode', pincodeController, keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ),

            // Save Button
            Container(
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
                  onPressed: () {
                    // TODO: Validate and save
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing ? 'Address updated!' : 'Address added!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6B73FF),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Address' : 'Save Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6B73FF), width: 2),
        ),
      ),
    );
  }
}