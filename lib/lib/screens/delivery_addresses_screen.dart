// lib/screens/delivery_addresses_screen.dart
import 'package:flutter/material.dart';
import '../services/address_service.dart';
import '../models/address.dart';

class DeliveryAddressesScreen extends StatefulWidget {
  const DeliveryAddressesScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressesScreen> createState() => _DeliveryAddressesScreenState();
}

class _DeliveryAddressesScreenState extends State<DeliveryAddressesScreen> {
  final _addressService = AddressService();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    await _addressService.fetchAddresses();
    setState(() => _isLoading = false);
  }

  Future<void> _setDefaultAddress(int addressId) async {
    final result = await _addressService.setDefaultAddress(addressId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Default address updated'),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (result['success']) {
        setState(() {});
      }
    }
  }

  Future<void> _deleteAddress(int addressId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _addressService.deleteAddress(addressId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Address deleted'),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (result['success']) {
          setState(() {});
        }
      }
    }
  }

  void _addNewAddress() {
    _showAddressDialog();
  }

  void _editAddress(Address address) {
    _showAddressDialog(address: address);
  }

  void _showAddressDialog({Address? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddressFormDialog(
        address: address,
        onSaved: () {
          Navigator.pop(context);
          _loadAddresses();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Addresses'),
        backgroundColor: const Color(0xFF7B2CBF),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addressService.addresses.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _loadAddresses,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _addressService.addresses.length,
          itemBuilder: (context, index) {
            final address = _addressService.addresses[index];
            return _buildAddressCard(address);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAddress,
        backgroundColor: const Color(0xFF7B2CBF),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'No addresses saved',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add a delivery address to continue',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addNewAddress,
            icon: const Icon(Icons.add_location),
            label: const Text('Add Address'),
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

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault
            ? Border.all(color: const Color(0xFF7B2CBF), width: 2)
            : null,
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
            // Header
            Row(
              children: [
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2CBF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editAddress(address),
                  color: const Color(0xFF7B2CBF),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _deleteAddress(address.id),
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Name and Phone
            Row(
              children: [
                const Icon(Icons.person, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  address.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  address.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.fullAddress,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),

            // Set Default Button
            if (!address.isDefault) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _setDefaultAddress(address.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7B2CBF),
                    side: const BorderSide(color: Color(0xFF7B2CBF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('SET AS DEFAULT'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Address Form Dialog Widget
class AddressFormDialog extends StatefulWidget {
  final Address? address;
  final VoidCallback onSaved;

  const AddressFormDialog({
    Key? key,
    this.address,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _addressService = AddressService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;

  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _nameController = TextEditingController(text: address?.fullName ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _addressLine1Controller = TextEditingController(text: address?.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: address?.addressLine2 ?? '');
    _cityController = TextEditingController(text: address?.city ?? '');
    _stateController = TextEditingController(text: address?.state ?? '');
    _pincodeController = TextEditingController(text: address?.pincode ?? '');
    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Map<String, dynamic> result;

    if (widget.address != null) {
      // Update existing address
      result = await _addressService.updateAddress(
        widget.address!.id,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim().isNotEmpty
            ? _addressLine2Controller.text.trim()
            : null,
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
      );
    } else {
      // Create new address
      result = await _addressService.createAddress(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim().isNotEmpty
            ? _addressLine2Controller.text.trim()
            : null,
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        isDefault: _isDefault,
      );
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['success']) {
        widget.onSaved();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to save address'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.address != null ? 'Edit Address' : 'Add New Address',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address Line 1
                TextFormField(
                  controller: _addressLine1Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 1',
                    prefixIcon: const Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address Line 2
                TextFormField(
                  controller: _addressLine2Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 2 (Optional)',
                    prefixIcon: const Icon(Icons.home_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // City and State
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter city';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter state';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pincode
                TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    prefixIcon: const Icon(Icons.pin_drop),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pincode';
                    }
                    if (value.length != 6) {
                      return 'Pincode must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Default Checkbox
                if (widget.address == null)
                  CheckboxListTile(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() => _isDefault = value ?? false);
                    },
                    title: const Text('Set as default address'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF7B2CBF),
                  ),
                const SizedBox(height: 16),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2CBF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'SAVE ADDRESS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
}