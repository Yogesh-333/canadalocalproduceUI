// lib/providers/products_provider.dart
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadProducts({
    bool refresh = false,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _products = [];
      _hasMore = true;
    }

    if (_isLoading || (!_hasMore && !refresh)) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProducts = await _apiService.getProducts(
        page: _currentPage,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        order: order,
      );

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductsByCategory(int categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProductsByCategory(categoryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
