// lib/providers/products_provider.dart
import 'dart:developer';

import 'package:canada_produce/models/category.dart';
import 'package:canada_produce/models/product.dart';
import 'package:canada_produce/services/api_service.dart';
import 'package:flutter/material.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _itemsPerPage = 12;

  // Filters
  Category? _selectedCategory;
  String? _sortBy;
  String? _orderBy;

  // Getters
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  Category? get selectedCategory => _selectedCategory;
  String? get sortBy => _sortBy;
  String? get orderBy => _orderBy;

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getProducts(
        page: _currentPage,
        limit: _itemsPerPage,
        categoryId: _selectedCategory?.id,
        sortBy: _sortBy,
        order: _orderBy,
      );

      _products = result.products;
      _currentPage = result.currentPage;
      _totalPages = result.totalPages;
      _totalItems = result.totalItems;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _apiService.getCategories();
      notifyListeners();
    } catch (e) {
      // If categories fail to load, we'll use the default ones from the API service
      log('Error loading categories: $e');
      _categories = [];
      notifyListeners();
    }
  }

  void setCategory(Category? category) {
    _selectedCategory = category;
    loadProducts(refresh: true);
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    loadProducts(refresh: true);
  }

  void setOrderBy(String orderBy) {
    _orderBy = orderBy;
    loadProducts(refresh: true);
  }

  void setPage(int page) {
    _currentPage = page;
    loadProducts();
  }
}
