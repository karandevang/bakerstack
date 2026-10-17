import '../models/address.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class AddressService {
  static final AddressService _instance = AddressService._internal();
  factory AddressService() => _instance;
  AddressService._internal();

  final ApiService _api = ApiService();
  List<Address> _addresses = [];
  Address? _defaultAddress;

  List<Address> get addresses => _addresses;
  Address? get defaultAddress => _defaultAddress;

  /// Fetch all addresses
  Future<bool> fetchAddresses() async {
    try {
      print('📍 Fetching addresses...');

      final response = await _api.get(ApiConfig.addresses, auth: true);

      if (response['success']) {
        final List<dynamic> data = response['data'];
        _addresses = data.map((json) => Address.fromJson(json)).toList();

        // Find default address
        try {
          _defaultAddress = _addresses.firstWhere((addr) => addr.isDefault);
        } catch (e) {
          _defaultAddress = _addresses.isNotEmpty ? _addresses.first : null;
        }

        print('✅ Addresses loaded: ${_addresses.length}');
        return true;
      } else {
        print('❌ Failed to fetch addresses: ${response['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Error fetching addresses: $e');
      return false;
    }
  }

  /// Create new address
  Future<Map<String, dynamic>> createAddress({
    required String fullName,
    required String phone,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String pincode,
    bool isDefault = false,
  }) async {
    try {
      print('📍 Creating address...');

      final response = await _api.post(
        ApiConfig.addresses,
        {
          'full_name': fullName,
          'phone': phone,
          'address_line1': addressLine1,
          if (addressLine2 != null) 'address_line2': addressLine2,
          'city': city,
          'state': state,
          'pincode': pincode,
          'is_default': isDefault,
        },
        auth: true,
      );

      if (response['success']) {
        await fetchAddresses();
        return {
          'success': true,
          'message': 'Address added successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to add address',
        };
      }
    } catch (e) {
      print('❌ Error creating address: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update address
  Future<Map<String, dynamic>> updateAddress(
      int addressId, {
        String? fullName,
        String? phone,
        String? addressLine1,
        String? addressLine2,
        String? city,
        String? state,
        String? pincode,
      }) async {
    try {
      print('📍 Updating address: $addressId');

      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (phone != null) body['phone'] = phone;
      if (addressLine1 != null) body['address_line1'] = addressLine1;
      if (addressLine2 != null) body['address_line2'] = addressLine2;
      if (city != null) body['city'] = city;
      if (state != null) body['state'] = state;
      if (pincode != null) body['pincode'] = pincode;

      final response = await _api.put(
        '${ApiConfig.addresses}/$addressId',
        body,
        auth: true,
      );

      if (response['success']) {
        await fetchAddresses();
        return {
          'success': true,
          'message': 'Address updated successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to update address',
        };
      }
    } catch (e) {
      print('❌ Error updating address: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Delete address
  Future<Map<String, dynamic>> deleteAddress(int addressId) async {
    try {
      print('📍 Deleting address: $addressId');

      final response = await _api.delete(
        '${ApiConfig.addresses}/$addressId',
        auth: true,
      );

      if (response['success']) {
        await fetchAddresses();
        return {
          'success': true,
          'message': 'Address deleted successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to delete address',
        };
      }
    } catch (e) {
      print('❌ Error deleting address: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Set default address
  Future<Map<String, dynamic>> setDefaultAddress(int addressId) async {
    try {
      print('📍 Setting default address: $addressId');

      final response = await _api.patch(
        '${ApiConfig.addresses}/$addressId/set-default',
        {},
        auth: true,
      );

      if (response['success']) {
        await fetchAddresses();
        return {
          'success': true,
          'message': 'Default address updated',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to set default address',
        };
      }
    } catch (e) {
      print('❌ Error setting default address: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get default address
  Future<Address?> getDefaultAddress() async {
    try {
      final response = await _api.get(
        ApiConfig.addressDefault,
        auth: true,
      );

      if (response['success'] && response['data'] != null) {
        return Address.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Error getting default address: $e');
      return null;
    }
  }
}