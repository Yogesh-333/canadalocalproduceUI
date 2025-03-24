// lib/models/product_request.dart
class ProductRequest {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String? imageUrl;
  final String? affiliateUrl;
  final int userId;
  final String? address;
  final String status; // 'pending', 'approved', 'rejected'

  ProductRequest({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.imageUrl,
    this.affiliateUrl,
    required this.userId,
    this.address,
    required this.status,
  });

  factory ProductRequest.fromJson(Map<String, dynamic> json) {
    return ProductRequest(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      affiliateUrl: json['affiliate_url'],
      userId: json['user_id'],
      address: json['address'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'image_url': imageUrl,
      'affiliate_url': affiliateUrl,
      'user_id': userId,
      'address': address,
      'status': status,
    };
  }
}