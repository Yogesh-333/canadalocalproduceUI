// lib/screens/admin/products_management.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../services/admin_service.dart';
import '../../services/api_service.dart';
import 'product_form_dialog.dart';

class ProductsManagement extends StatefulWidget {
  const ProductsManagement({super.key});

  @override
  State<ProductsManagement> createState() => _ProductsManagementState();
}

class _ProductsManagementState extends State<ProductsManagement> {
  final AdminService _adminService = AdminService();
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Category> _categories = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final productsData = await _adminService.getAllProducts();
      final categoriesData = await _apiService.getCategories();

      setState(() {
        _products = productsData;
        _filteredProducts = productsData;
        _categories = categoriesData;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _addProduct() async {
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => ProductFormDialog(
        categories: _categories,
      ),
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _adminService.addProduct(result);
        if (success) {
          _showSuccessSnackBar('Product added successfully');
          _loadData();
        } else {
          _showErrorSnackBar('Failed to add product');
        }
      } catch (e) {
        _showErrorSnackBar('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editProduct(Product product) async {
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => ProductFormDialog(
        product: product,
        categories: _categories,
      ),
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _adminService.updateProduct(product.id, result);
        if (success) {
          _showSuccessSnackBar('Product updated successfully');
          _loadData();
        } else {
          _showErrorSnackBar('Failed to update product');
        }
      } catch (e) {
        _showErrorSnackBar('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _adminService.deleteProduct(product.id);
        if (success) {
          _showSuccessSnackBar('Product deleted successfully');
          _loadData();
        } else {
          _showErrorSnackBar('Failed to delete product');
        }
      } catch (e) {
        _showErrorSnackBar('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getCategoryName(int categoryId) {
    final category = _categories.firstWhere(
          (c) => c.id == categoryId,
      orElse: () => Category(id: -1, name: 'Unknown'),
    );
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header and search
          Row(
            children: [
              const Text(
                'Products Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _filterProducts,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _addProduct,
                icon: const Icon(Icons.add),
                label: const Text('ADD PRODUCT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Products table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _filteredProducts.map((product) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${product.id}')),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                              ),
                              child: Text(product.name),
                            ),
                          ),
                          DataCell(
                            Text(_getCategoryName(product.categoryId)),
                          ),
                          DataCell(Text('\$${product.price}')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () => _editProduct(product),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _deleteProduct(product),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}