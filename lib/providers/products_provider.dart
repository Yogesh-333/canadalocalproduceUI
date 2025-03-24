// lib/providers/products_provider.dart
import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Products state
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isSearching = false;
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
  String _searchQuery = '';

  // Getters
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  Category? get selectedCategory => _selectedCategory;
  String? get sortBy => _sortBy;
  String? get orderBy => _orderBy;
  String get searchQuery => _searchQuery;

  // Load products with all filters
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _products = [];
    }

    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      log('Loading products with filters: '
          'page: $_currentPage, '
          'category: ${_selectedCategory?.name}, '
          'sortBy: $_sortBy, '
          'order: $_orderBy');

      final result = await _apiService.getProducts(
        page: _currentPage,
        limit: _itemsPerPage,
        categoryId: _selectedCategory?.id,
        sortBy: _sortBy,
        order: _orderBy,
      );

      if (refresh) {
        _products = result.products;
      } else {
        _products.addAll(result.products);
      }

      _currentPage = result.currentPage;
      _totalPages = result.totalPages;
      _totalItems = result.totalItems;

      log('Loaded ${result.products.length} products. '
          'Total pages: $_totalPages, '
          'Total items: $_totalItems');
    } catch (e, stackTrace) {
      log('Error loading products:', error: e, stackTrace: stackTrace);
      _error = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    if (query == _searchQuery) return;

    _searchQuery = query;
    _isSearching = true;
    notifyListeners();

    try {
      if (query.isEmpty) {
        // Reset search and load normal products
        _selectedCategory = null;
        _sortBy = null;
        _orderBy = null;
        await loadProducts(refresh: true);
      } else {
        log('Searching products with query: $query');

        final result = await _apiService.searchProducts(
          query: query,
          page: 1,
          limit: _itemsPerPage,
        );

        _products = result.products;
        _currentPage = result.currentPage;
        _totalPages = result.totalPages;
        _totalItems = result.totalItems;

        log('Found ${result.products.length} products for query: $query');
      }
    } catch (e, stackTrace) {
      log('Error searching products:', error: e, stackTrace: stackTrace);
      _error = 'Failed to search products: $e';
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return;

    try {
      log('Loading categories');
      _categories = await _apiService.getCategories();
      log('Loaded ${_categories.length} categories');
    } catch (e, stackTrace) {
      log('Error loading categories:', error: e, stackTrace: stackTrace);
      _error = 'Failed to load categories: $e';
      _categories = [];
    }
    notifyListeners();
  }

  // Set category filter
  void setCategory(Category? category) {
    log('Setting category filter: ${category?.name}');
    if (_selectedCategory?.id == category?.id) return;

    _selectedCategory = category;
    _searchQuery = ''; // Clear search when changing category
    loadProducts(refresh: true);
  }

  // Set sort by
  void setSortBy(String? sortBy) {
    log('Setting sort by: $sortBy');
    if (_sortBy == sortBy) return;

    _sortBy = sortBy;
    loadProducts(refresh: true);
  }

  // Set order by
  void setOrderBy(String? orderBy) {
    log('Setting order by: $orderBy');
    if (_orderBy == orderBy) return;

    _orderBy = orderBy;
    loadProducts(refresh: true);
  }

  // Set page
  void setPage(int page) {
    log('Setting page: $page');
    if (_currentPage == page) return;

    _currentPage = page;
    loadProducts();
  }

  // Clear all filters
  void clearFilters() {
    log('Clearing all filters');
    _selectedCategory = null;
    _sortBy = null;
    _orderBy = null;
    _searchQuery = '';
    loadProducts(refresh: true);
  }

  // Refresh data
  Future<void> refresh() async {
    log('Refreshing all data');
    await loadCategories();
    await loadProducts(refresh: true);
  }

  // Error handling
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
