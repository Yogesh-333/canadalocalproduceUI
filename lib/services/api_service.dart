// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://api.canadalocalproduce.ca/api';

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

        // Since the API doesn't return pagination info, we'll calculate it
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

  Future<List<Category>> getCategories() async {
    try {
      final uri = Uri.parse('$baseUrl/categories');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        // Return default categories if API fails
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
        ];
      }
    } catch (e, stackTrace) {
      log('Error fetching categories:', error: e, stackTrace: stackTrace);
      // Return default categories on error
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
      ];
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
