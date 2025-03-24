// lib/services/admin_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/product_request.dart';
import 'api_service.dart';

class AdminService {
  static const String baseUrl = ApiService.baseUrl;

  // Get all products without pagination (for admin)
  Future<List<Product>> getAllProducts() async {
    try {
      final uri = Uri.parse('$baseUrl/products?limit=100');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      log('Error fetching all products: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  // Add a new product
  Future<bool> addProduct(Product product) async {
    try {
      final uri = Uri.parse('$baseUrl/products');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      log('Error adding product: $e');
      return false;
    }
  }

  // Update existing product
  Future<bool> updateProduct(int id, Product product) async {
    try {
      final uri = Uri.parse('$baseUrl/products/$id');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      log('Error updating product: $e');
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/products/$id');
      final response = await http.delete(uri);

      return response.statusCode == 200;
    } catch (e) {
      log('Error deleting product: $e');
      return false;
    }
  }

  // Get all product requests
  Future<List<ProductRequest>> getAllProductRequests() async {
    try {
      final uri = Uri.parse('$baseUrl/product-requests');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load product requests');
      }
    } catch (e) {
      log('Error fetching product requests: $e');
      throw Exception('Failed to load product requests: $e');
    }
  }

  // Approve or reject product request
  Future<bool> updateProductRequestStatus(int id, String status) async {
    try {
      final uri = Uri.parse('$baseUrl/product-requests/$id');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      return response.statusCode == 200;
    } catch (e) {
      log('Error updating product request: $e');
      return false;
    }
  }
}