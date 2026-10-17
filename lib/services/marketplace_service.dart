import '../models/marketplace_item.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class MarketplaceService {
  static final MarketplaceService _instance = MarketplaceService._internal();
  factory MarketplaceService() => _instance;
  MarketplaceService._internal();

  final ApiService _api = ApiService();
  List<MarketplaceItem> _listings = [];
  List<MarketplaceItem> _myListings = [];

  List<MarketplaceItem> get listings => _listings;
  List<MarketplaceItem> get myListings => _myListings;

  /// Fetch all marketplace listings
  Future<bool> fetchListings() async {
    try {
      print('🏪 Fetching marketplace listings...');

      final response = await _api.get(ApiConfig.marketplaceListings);

      if (response['success']) {
        final List<dynamic> data = response['data'];
        _listings = data.map((json) => MarketplaceItem.fromJson(json)).toList();
        print('✅ Listings loaded: ${_listings.length}');
        return true;
      } else {
        print('❌ Failed to fetch listings: ${response['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Error fetching listings: $e');
      return false;
    }
  }

  /// Get my listings
  Future<bool> fetchMyListings() async {
    try {
      print('🏪 Fetching my listings...');

      final response = await _api.get(
        ApiConfig.marketplaceMyListings,
        auth: true,
      );

      if (response['success']) {
        final List<dynamic> data = response['data'];
        _myListings = data.map((json) => MarketplaceItem.fromJson(json)).toList();
        print('✅ My listings loaded: ${_myListings.length}');
        return true;
      } else {
        print('❌ Failed to fetch my listings: ${response['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Error fetching my listings: $e');
      return false;
    }
  }

  /// Create new listing
  Future<Map<String, dynamic>> createListing({
    required String equipmentName,
    required String description,
    required String condition,
    required double price,
    required String contactPhone,
    required String contactEmail,
    String? imageUrl,
  }) async {
    try {
      print('🏪 Creating listing...');

      final response = await _api.post(
        ApiConfig.marketplaceListings,
        {
          'equipment_name': equipmentName,
          'description': description,
          'condition': condition,
          'price': price,
          'contact_phone': contactPhone,
          'contact_email': contactEmail,
          if (imageUrl != null) 'image_url': imageUrl,
        },
        auth: true,
      );

      if (response['success']) {
        await fetchMyListings();
        return {
          'success': true,
          'message': 'Listing created successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to create listing',
        };
      }
    } catch (e) {
      print('❌ Error creating listing: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update listing
  Future<Map<String, dynamic>> updateListing(
      int listingId, {
        String? equipmentName,
        String? description,
        String? condition,
        double? price,
        String? contactPhone,
        String? contactEmail,
        String? imageUrl,
      }) async {
    try {
      print('🏪 Updating listing: $listingId');

      final body = <String, dynamic>{};
      if (equipmentName != null) body['equipment_name'] = equipmentName;
      if (description != null) body['description'] = description;
      if (condition != null) body['condition'] = condition;
      if (price != null) body['price'] = price;
      if (contactPhone != null) body['contact_phone'] = contactPhone;
      if (contactEmail != null) body['contact_email'] = contactEmail;
      if (imageUrl != null) body['image_url'] = imageUrl;

      final response = await _api.put(
        '${ApiConfig.marketplaceListings}/$listingId',
        body,
        auth: true,
      );

      if (response['success']) {
        await fetchMyListings();
        return {
          'success': true,
          'message': 'Listing updated successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to update listing',
        };
      }
    } catch (e) {
      print('❌ Error updating listing: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Delete listing
  Future<Map<String, dynamic>> deleteListing(int listingId) async {
    try {
      print('🏪 Deleting listing: $listingId');

      final response = await _api.delete(
        '${ApiConfig.marketplaceListings}/$listingId',
        auth: true,
      );

      if (response['success']) {
        await fetchMyListings();
        return {
          'success': true,
          'message': 'Listing deleted successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to delete listing',
        };
      }
    } catch (e) {
      print('❌ Error deleting listing: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Mark listing as sold
  Future<Map<String, dynamic>> markAsSold(int listingId) async {
    try {
      print('🏪 Marking as sold: $listingId');

      final response = await _api.patch(
        '${ApiConfig.marketplaceListings}/$listingId/mark-sold',
        {},
        auth: true,
      );

      if (response['success']) {
        await fetchMyListings();
        return {
          'success': true,
          'message': 'Marked as sold',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to mark as sold',
        };
      }
    } catch (e) {
      print('❌ Error marking as sold: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get listing by ID
  Future<MarketplaceItem?> getListingById(int listingId) async {
    try {
      final response = await _api.get(
        '${ApiConfig.marketplaceListings}/$listingId',
      );

      if (response['success']) {
        return MarketplaceItem.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Error getting listing: $e');
      return null;
    }
  }
}


































