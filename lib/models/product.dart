class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int categoryId;
  final String imageUrl;
  final String affiliateUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? address; // Added address field

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
    this.address, // Added address field
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
      address: json['address'], // Added address field
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'address': address,
    };
  }
}