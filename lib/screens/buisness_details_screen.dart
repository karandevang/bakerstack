// lib/screens/business_details_screen.dart
// Manage business information and GST details

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class BusinessDetailsScreen extends StatefulWidget {
  @override
  _BusinessDetailsScreenState createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _panController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _isLoading = true;
  bool _hasChanges = false;
  bool _isGstRegistered = false;

  @override
  void initState() {
    super.initState();
    _loadBusinessDetails();

    // Track changes
    _businessNameController.addListener(() => setState(() => _hasChanges = true));
    _gstNumberController.addListener(() => setState(() => _hasChanges = true));
    _panController.addListener(() => setState(() => _hasChanges = true));
    _addressLine1Controller.addListener(() => setState(() => _hasChanges = true));
    _addressLine2Controller.addListener(() => setState(() => _hasChanges = true));
    _cityController.addListener(() => setState(() => _hasChanges = true));
    _stateController.addListener(() => setState(() => _hasChanges = true));
    _pincodeController.addListener(() => setState(() => _hasChanges = true));
  }

  Future<void> _loadBusinessDetails() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Load from API

      // Mock data
      await Future.delayed(Duration(seconds: 1));
      _businessNameController.text = 'Sweet Delights Bakery';
      _gstNumberController.text = '27AABCU9603R1ZM';
      _panController.text = 'AABCU9603R';
      _addressLine1Controller.text = '123, Baker Street';
      _addressLine2Controller.text = 'Commercial Complex';
      _cityController.text = 'Mumbai';
      _stateController.text = 'Maharashtra';
      _pincodeController.text = '400001';
      _isGstRegistered = true;

      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load business details'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          return await _showDiscardDialog();
        }
        return true;
      },
      child: Scaffold(
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
                        onPressed: () async {
                          if (_hasChanges) {
                            final shouldPop = await _showDiscardDialog();
                            if (shouldPop) Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Business Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage your bakery information',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_hasChanges)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Unsaved',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
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
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF6B73FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF6B73FF).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF6B73FF),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Add your business details to receive GST invoices and enable B2B features',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF374151),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Business Name
                      _buildSectionTitle('Business Information'),
                      SizedBox(height: 12),
                      _buildTextField(
                        controller: _businessNameController,
                        label: 'Business/Bakery Name',
                        icon: Icons.store_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      // GST Toggle
                      _buildSectionTitle('Tax Information'),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GST Registered',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Enable to add GST details',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isGstRegistered,
                              onChanged: (value) {
                                setState(() {
                                  _isGstRegistered = value;
                                  _hasChanges = true;
                                });
                              },
                              activeColor: Color(0xFF6B73FF),
                            ),
                          ],
                        ),
                      ),

                      // GST Details (conditional)
                      if (_isGstRegistered) ...[
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _gstNumberController,
                          label: 'GST Number (Optional)',
                          icon: Icons.receipt_long_outlined,
                          hint: 'e.g., 27AABCU9603R1ZM',
                          validator: (value) {
                            if (value != null && value.isNotEmpty && value.length != 15) {
                              return 'GST number must be 15 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _panController,
                          label: 'PAN Number (Optional)',
                          icon: Icons.credit_card_outlined,
                          hint: 'e.g., AABCU9603R',
                          validator: (value) {
                            if (value != null && value.isNotEmpty && value.length != 10) {
                              return 'PAN number must be 10 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                      SizedBox(height: 24),

                      // Business Address
                      _buildSectionTitle('Business Address'),
                      SizedBox(height: 12),
                      _buildTextField(
                        controller: _addressLine1Controller,
                        label: 'Address Line 1',
                        icon: Icons.location_on_outlined,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressLine2Controller,
                        label: 'Address Line 2 (Optional)',
                        icon: Icons.location_on_outlined,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _cityController,
                              label: 'City',
                              icon: Icons.location_city_outlined,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _stateController,
                              label: 'State',
                              icon: Icons.map_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _pincodeController,
                        label: 'Pincode',
                        icon: Icons.pin_drop_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length != 6) {
                            return 'Pincode must be 6 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Bottom Buttons
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
            child: Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (_hasChanges) {
                        final shouldPop = await _showDiscardDialog();
                        if (shouldPop) Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF6B73FF),
                      side: BorderSide(color: Color(0xFF6B73FF)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Save
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: !_hasChanges ? null : _saveBusinessDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B73FF),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Changes',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF6B73FF)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6B73FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }

  Future<void> _saveBusinessDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Save via API

      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      setState(() => _hasChanges = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Business details updated successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update business details'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<bool> _showDiscardDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Discard changes?'),
        content: Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Keep Editing'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Discard'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _gstNumberController.dispose();
    _panController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }
}