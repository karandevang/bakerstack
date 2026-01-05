// lib/screens/marketplace_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/marketplace_service.dart';
import '../services/auth_service.dart';
import '../models/marketplace_item.dart';

class MarketplaceDetailScreen extends StatefulWidget {
  final int listingId;

  const MarketplaceDetailScreen({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  @override
  State<MarketplaceDetailScreen> createState() => _MarketplaceDetailScreenState();
}

class _MarketplaceDetailScreenState extends State<MarketplaceDetailScreen> {
  final _marketplaceService = MarketplaceService();
  final _authService = AuthService();

  MarketplaceItem? _listing;
  bool _isLoading = true;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _loadListing();
  }

  Future<void> _loadListing() async {
    setState(() => _isLoading = true);

    final listing = await _marketplaceService.getListingById(widget.listingId);

    setState(() {
      _listing = listing;
      _isOwner = listing?.userId == _authService.userId;
      _isLoading = false;
    });
  }

  Future<void> _markAsSold() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Sold'),
        content: const Text('Are you sure you want to mark this item as sold?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mark as Sold'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _marketplaceService.markAsSold(widget.listingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Listing updated'),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (result['success']) {
          _loadListing();
        }
      }
    }
  }

  Future<void> _deleteListing() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to delete this listing?'),
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
      final result = await _marketplaceService.deleteListing(widget.listingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Listing deleted'),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (result['success']) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _callSeller() async {
    final phone = _listing?.contactPhone;
    if (phone != null) {
      final uri = Uri.parse('tel:$phone');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _emailSeller() async {
    final email = _listing?.contactEmail;
    if (email != null) {
      final uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listing == null
          ? _buildErrorState()
          : _buildListingDetail(),
    );
  }

  Widget _buildListingDetail() {
    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: const Color(0xFF7B2CBF),
          actions: _isOwner
              ? [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit listing screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit functionality coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteListing,
            ),
          ]
              : null,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.construction,
                      size: 120,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                if (_listing!.isSold)
                  Positioned(
                    top: 60,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SOLD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Equipment Details
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Condition Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getConditionColor(_listing!.condition).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _listing!.condition.toUpperCase(),
                      style: TextStyle(
                        color: _getConditionColor(_listing!.condition),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Equipment Name
                  Text(
                    _listing!.equipmentName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    _listing!.formattedPrice,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B2CBF),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _listing!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seller Contact (if not owner)
                  if (!_isOwner) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Seller Contact',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactButton(
                      icon: Icons.phone,
                      label: _listing!.contactPhone,
                      onTap: _callSeller,
                    ),
                    const SizedBox(height: 12),
                    _buildContactButton(
                      icon: Icons.email,
                      label: _listing!.contactEmail,
                      onTap: _emailSeller,
                    ),
                  ],

                  // Owner Actions
                  if (_isOwner && !_listing!.isSold) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _markAsSold,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'MARK AS SOLD',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF7B2CBF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF7B2CBF).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF7B2CBF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF7B2CBF)),
          ],
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
            'Listing not found',
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