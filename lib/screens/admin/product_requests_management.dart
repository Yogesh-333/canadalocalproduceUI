// lib/screens/admin/product_requests_management.dart
import 'package:flutter/material.dart';
import '../../models/product_request.dart';
import '../../models/category.dart';
import '../../services/admin_service.dart';
import '../../services/api_service.dart';

class ProductRequestsManagement extends StatefulWidget {
  const ProductRequestsManagement({super.key});

  @override
  State<ProductRequestsManagement> createState() => _ProductRequestsManagementState();
}

class _ProductRequestsManagementState extends State<ProductRequestsManagement> {
  final AdminService _adminService = AdminService();
  final ApiService _apiService = ApiService();

  List<ProductRequest> _requests = [];
  List<Category> _categories = [];
  bool _isLoading = true;

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
      final requestsData = await _adminService.getAllProductRequests();
      final categoriesData = await _apiService.getCategories();

      setState(() {
        _requests = requestsData;
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

  Future<void> _approveRequest(ProductRequest request) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _adminService.updateProductRequestStatus(
        request.id,
        'approved',
      );

      if (success) {
        _showSuccessSnackBar('Request approved successfully');
        _loadData();
      } else {
        _showErrorSnackBar('Failed to approve request');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _rejectRequest(ProductRequest request) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _adminService.updateProductRequestStatus(
        request.id,
        'rejected',
      );

      if (success) {
        _showSuccessSnackBar('Request rejected');
        _loadData();
      } else {
        _showErrorSnackBar('Failed to reject request');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _viewRequestDetails(ProductRequest request) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Request Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', request.name),
              _buildDetailRow('Category', _getCategoryName(request.categoryId)),
              _buildDetailRow('Price', '\$${request.price}'),
              _buildDetailRow('Description', request.description),
              if (request.imageUrl != null)
                _buildDetailRow('Image URL', request.imageUrl!),
              if (request.affiliateUrl != null)
                _buildDetailRow('Affiliate URL', request.affiliateUrl!),
              if (request.address != null)
                _buildDetailRow('Address', request.address!),
              _buildDetailRow('User ID', '${request.userId}'),
              _buildDetailRow('Status', request.status),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
          if (request.status == 'pending') ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectRequest(request);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('REJECT'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _approveRequest(request);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('APPROVE'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Product Requests Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Tab Bar for filtering by status
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pending'),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${_requests.where((r) => r.status == 'pending').length}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Approved'),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${_requests.where((r) => r.status == 'approved').length}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Rejected'),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${_requests.where((r) => r.status == 'rejected').length}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tab View
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Pending Requests Tab
                        _buildRequestsTable(
                          _requests.where((r) => r.status == 'pending').toList(),
                        ),

                        // Approved Requests Tab
                        _buildRequestsTable(
                          _requests.where((r) => r.status == 'approved').toList(),
                        ),

                        // Rejected Requests Tab
                        _buildRequestsTable(
                          _requests.where((r) => r.status == 'rejected').toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTable(List<ProductRequest> requests) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requests.isEmpty) {
      return const Center(child: Text('No requests found'));
    }

    return Card(
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
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: requests.map((request) {
              return DataRow(
                cells: [
                  DataCell(Text('${request.id}')),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Text(request.name),
                    ),
                  ),
                  DataCell(
                    Text(_getCategoryName(request.categoryId)),
                  ),
                  DataCell(Text('\$${request.price}')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          color: Colors.blue,
                          onPressed: () => _viewRequestDetails(request),
                          tooltip: 'View Details',
                        ),
                        if (request.status == 'pending') ...[
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            color: Colors.green,
                            onPressed: () => _approveRequest(request),
                            tooltip: 'Approve',
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () => _rejectRequest(request),
                            tooltip: 'Reject',
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}