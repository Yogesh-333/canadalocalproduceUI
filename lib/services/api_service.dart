// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://44.216.87.146:3000/api';

  // Get all products
  Future<List<Product>> getProducts({
    int page = 1,
    int limit = 10,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (minPrice != null) 'min_price': minPrice.toString(),
      if (maxPrice != null) 'max_price': maxPrice.toString(),
      if (sortBy != null) 'sort_by': sortBy,
      if (order != null) 'order': order,
    };

    final uri = Uri.parse('$baseUrl/products')
        .replace(queryParameters: queryParameters);

    try {
      log('Fetching products from: $uri');

      final response = await http.get(uri);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error fetching products:', error: e, stackTrace: stackTrace);
      throw Exception('Failed to load products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final uri = Uri.parse('$baseUrl/products/category/$categoryId');

    try {
      log('Fetching products for category $categoryId from: $uri');

      final response = await http.get(uri);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error fetching products by category:',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to load products for category: $e');
    }
  }

  // Add a new product
  Future<Product> addProduct(Product product) async {
    final uri = Uri.parse('$baseUrl/products');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'category_id': product.categoryId,
          'image_url': product.imageUrl,
          'affiliate_url': product.affiliateUrl,
        }),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update a product
  Future<Product> updateProduct(int id, Product product) async {
    final uri = Uri.parse('$baseUrl/products/$id');

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'category_id': product.categoryId,
          'image_url': product.imageUrl,
          'affiliate_url': product.affiliateUrl,
        }),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct(int id) async {
    final uri = Uri.parse('$baseUrl/products/$id');

    try {
      final response = await http.delete(uri);

      if (response.statusCode != 204) {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
