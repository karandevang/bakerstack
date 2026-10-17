// lib/screens/marketplace_feed_screen.dart
import 'package:flutter/material.dart';
import '../services/marketplace_service.dart';
import '../models/marketplace_item.dart';

class MarketplaceFeedScreen extends StatefulWidget {
  const MarketplaceFeedScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceFeedScreen> createState() => _MarketplaceFeedScreenState();
}

class _MarketplaceFeedScreenState extends State<MarketplaceFeedScreen> {
  final _marketplaceService = MarketplaceService();

  List<MarketplaceItem> _listings = [];
  List<MarketplaceItem> _filteredListings = [];
  bool _isLoading = true;
  String? _selectedCondition;

  final List<String> _conditions = [
    'All',
    'Excellent',
    'Good',
    'Fair',
    'Poor',
  ];

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  Future<void> _loadListings() async {
    setState(() => _isLoading = true);

    await _marketplaceService.fetchListings();

    setState(() {
      _listings = _marketplaceService.listings;
      _filteredListings = _listings;
      _isLoading = false;
    });
  }

  void _filterByCondition(String? condition) {
    setState(() {
      _selectedCondition = condition;
      if (condition == null || condition == 'All') {
        _filteredListings = _listings;
      } else {
        _filteredListings = _listings
            .where((item) => item.condition == condition)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: const Color(0xFF7B2CBF),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () {
              Navigator.pushNamed(context, '/create-listing').then((_) {
                _loadListings();
              });
            },
            tooltip: 'Create Listing',
          ),
          IconButton(
            icon: const Icon(Icons.my_library_books),
            onPressed: () {
              Navigator.pushNamed(context, '/my-listings');
            },
            tooltip: 'My Listings',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildConditionFilter(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredListings.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadListings,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredListings.length,
                itemBuilder: (context, index) {
                  final listing = _filteredListings[index];
                  return _buildListingCard(listing);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-listing').then((_) {
            _loadListings();
          });
        },
        backgroundColor: const Color(0xFF7B2CBF),
        icon: const Icon(Icons.add),
        label: const Text('Sell Equipment'),
      ),
    );
  }

  Widget _buildConditionFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _conditions.length,
        itemBuilder: (context, index) {
          final condition = _conditions[index];
          final isSelected = _selectedCondition == condition ||
              (_selectedCondition == null && condition == 'All');

          return GestureDetector(
            onTap: () => _filterByCondition(
              condition == 'All' ? null : condition,
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF7B2CBF)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  condition,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListingCard(MarketplaceItem listing) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/marketplace-detail',
          arguments: {'listingId': listing.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Equipment Image
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.construction,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                // Sold Badge
                if (listing.isSold)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'SOLD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Condition Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getConditionColor(listing.condition),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      listing.condition.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Equipment Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.equipmentName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.condition,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),

                    // Price
                    Text(
                      listing.formattedPrice,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B2CBF),
                      ),
                    ),
                  ],
                ),
              ),
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
            Icons.storefront,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            _selectedCondition == null
                ? 'No listings available'
                : 'No $_selectedCondition listings',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to sell your equipment!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/create-listing').then((_) {
                _loadListings();
              });
            },
            icon: const Icon(Icons.add_business),
            label: const Text('Create Listing'),
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

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}