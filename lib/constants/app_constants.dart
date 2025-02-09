// lib/constants/app_constants.dart
class AppConstants {
  // Default image path in assets
  static const String defaultImagePath = 'assets/default_image.png';

  // URLs for images
  static const String logoUrl = 'assets/logo.jpeg';
  static const String bannerUrl = 'https://example.com/banner.jpg';

  // Product data with real image URLs
  static const List<Map<String, String>> products = [
    {
      'title': 'Fresh Vegetables',
      'imageUrl':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999',
      'url': 'https://example.com/product1',
    },
    {
      'title': 'Organic Fruits',
      'imageUrl':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf',
      'url': 'https://example.com/product2',
    },
    {
      'title': 'Fresh Berries',
      'imageUrl':
          'https://images.unsplash.com/photo-1596591606975-97ee5cef3a1e',
      'url': 'https://example.com/product3',
    },
    {
      'title': 'Maple Syrup',
      'imageUrl':
          'https://images.unsplash.com/photo-1589733955941-5eeaf752f6dd',
      'url': 'https://example.com/product4',
    },
    {
      'title': 'Local Honey',
      'imageUrl':
          'https://images.unsplash.com/photo-1587049352846-4a222e784d38',
      'url': 'https://example.com/product5',
    },
    {
      'title': 'Fresh Herbs',
      'imageUrl':
          'https://images.unsplash.com/photo-1466637574441-749b8f19452f',
      'url': 'https://example.com/product6',
    },
  ];

  // Navigation items
  static const List<String> navItems = [
    'Home',
    'Products',
    'About',
    'Contact',
  ];
}
