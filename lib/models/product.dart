// lib/models/product.dart
class Product {
  final int id;
  final String name;
  final String description;
  final String price; // Changed from double to String
  final int categoryId;
  final String imageUrl;
  final String affiliateUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.affiliateUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      affiliateUrl: json['affiliate_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
