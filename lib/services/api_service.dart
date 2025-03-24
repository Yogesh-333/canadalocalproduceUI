// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://api.canadalocalproduce.ca/api';

  // Existing getProducts method
  Future<ProductsResponse> getProducts({
    int page = 1,
    int limit = 12,
    int? categoryId,
    String? sortBy,
    String? order,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (sortBy != null) 'sort_by': sortBy,
        if (order != null) 'order': order,
      };

      final uri = Uri.parse('$baseUrl/products')
          .replace(queryParameters: queryParameters);
      log('Fetching products from: $uri');

      final response = await http.get(uri);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final products = data.map((json) => Product.fromJson(json)).toList();

        return ProductsResponse(
          products: products,
          currentPage: page,
          totalPages: (products.length / limit).ceil(),
          totalItems: products.length,
        );
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error fetching products:', error: e, stackTrace: stackTrace);
      throw Exception('Failed to load products: $e');
    }
  }

  // New search method
  Future<ProductsResponse> searchProducts({
    required String query,
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final queryParameters = {
        'query': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/products/search')
          .replace(queryParameters: queryParameters);
      log('Searching products: $uri');

      final response = await http.get(uri);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final products = data.map((json) => Product.fromJson(json)).toList();

        return ProductsResponse(
          products: products,
          currentPage: page,
          totalPages: (products.length / limit).ceil(),
          totalItems: products.length,
        );
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e, stackTrace) {
      log('Error searching products:', error: e, stackTrace: stackTrace);
      throw Exception('Failed to search products: $e');
    }
  }

  // Existing getCategories method
  Future<List<Category>> getCategories() async {
    try {
      final uri = Uri.parse('$baseUrl/categories');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final categories = data.map((json) => Category.fromJson(json)).toList();
        // Sort categories alphabetically
        categories.sort((a, b) => a.name.compareTo(b.name));
        return categories;
      } else {
        // Return default categories if API fails
        return _getDefaultCategories();
      }
    } catch (e, stackTrace) {
      log('Error fetching categories:', error: e, stackTrace: stackTrace);
      return _getDefaultCategories();
    }
  }

  // Helper method for default categories
  List<Category> _getDefaultCategories() {
    return [
      Category(id: 11, name: 'Shoes'),
      Category(id: 12, name: 'Auto Parts'),
      Category(id: 13, name: 'Jewelry'),
      Category(id: 15, name: 'Electronics'),
      Category(id: 16, name: 'Software'),
      Category(id: 18, name: 'Musical Instruments'),
      Category(id: 19, name: 'Art Supplies'),
      Category(id: 20, name: 'Pet Supplies'),
      Category(id: 21, name: 'Home Decor'),
      Category(id: 22, name: 'Furniture'),
      Category(id: 23, name: 'Garden Tools'),
      Category(id: 24, name: 'Seasonal'),
    ]..sort((a, b) => a.name.compareTo(b.name)); // Sort default categories
  }

  // New method for submitting product requests
  Future<Map<String, dynamic>?> submitProductRequest({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    String? imageUrl,
    String? affiliateUrl,
    required int userId,
    required String address,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/product-requests');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'category_id': categoryId,
          'image_url': imageUrl,
          'affiliate_url': affiliateUrl,
          'user_id': userId,
          'address': address,
        }),
      );

      log('Product request response status: ${response.statusCode}');
      log('Product request response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // Success, no errors
      } else {
        // Parse error response
        try{
          final errorData = json.decode(response.body);
          return errorData;
        }catch(e){
          return {"errors": [{"msg": "Failed to submit request: Invalid server response"}]};
        }
      }
    } catch (e, stackTrace) {
      log('Error submitting product request:', error: e, stackTrace: stackTrace);
      return {"errors": [{"msg": "Network error"}]}; // Network error
    }
  }
}

class ProductsResponse {
  final List<Product> products;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  ProductsResponse({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}