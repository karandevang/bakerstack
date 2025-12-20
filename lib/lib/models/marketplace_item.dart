
class MarketplaceItem {
  final String id;
  final String title;
  final int price;
  final String location;
  final String condition;
  final String imageUrl;
  final DateTime postedAt;

  MarketplaceItem({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.condition,
    required this.imageUrl,
    required this.postedAt,
  });
}