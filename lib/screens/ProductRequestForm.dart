// lib/widgets/product_request_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../services/api_service.dart';

class ProductRequestForm extends StatefulWidget {
  final VoidCallback? onClose;

  const ProductRequestForm({
    this.onClose,
    super.key,
  });

  @override
  State<ProductRequestForm> createState() => _ProductRequestFormState();
}

class _ProductRequestFormState extends State<ProductRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _affiliateUrlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  int? _selectedCategoryId;
  bool _isLoading = false;
  String? _errorMessage;
  bool _success = false;
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _apiErrors;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categories =
          Provider.of<ProductsProvider>(context, listen: false).categories;
      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategoryId = categories[0].id;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _affiliateUrlController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitProductRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _apiErrors = null;
    });

    try {
      final errorData = await _apiService.submitProductRequest(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        categoryId: _selectedCategoryId!,
        imageUrl: _imageUrlController.text,
        affiliateUrl: _affiliateUrlController.text,
        userId: 1,
        address: _addressController.text,
      );

      if (errorData == null) {
        setState(() {
          _success = true;
        });
      } else {
        setState(() {
          _apiErrors = errorData;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
        'Network error. Please check your connection and try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _success = false;
      _errorMessage = null;
      _apiErrors = null;
    });
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageUrlController.clear();
    _affiliateUrlController.clear();
    _addressController.clear();
    final categories =
        Provider.of<ProductsProvider>(context, listen: false).categories;
    if (categories.isNotEmpty) {
      setState(() {
        _selectedCategoryId = categories[0].id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a consistent border radius to use throughout the form
    const double borderRadiusValue = 8.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.1),
      //       blurRadius: 10,
      //       offset: const Offset(0, 4),
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Your Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Fill out the form below to request your product to be added to our platform.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          if (_success) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        'Product Request Submitted',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Thank you for your submission! We will review your product request soon.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                    ),
                    child: const Text('Submit Another Product'),
                  ),
                ],
              ),
            ),
          ] else ...[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price (CAD) *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(borderRadiusValue),
                            ),
                            prefixText: '\$ ',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<ProductsProvider>(
                    builder: (context, productsProvider, child) {
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadiusValue),
                          ),
                        ),
                        value: _selectedCategoryId,
                        items: productsProvider.categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      hintText: 'http://example.com/image.jpg',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _affiliateUrlController,
                    decoration: InputDecoration(
                      labelText: 'Affiliate URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      hintText: 'http://example.com/affiliate',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_apiErrors != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...(_apiErrors?["errors"] ?? []).map((error) => Text(
                            error["msg"] ?? "Unknown error",
                            style: TextStyle(color: Colors.red.shade800),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_errorMessage != null) const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitProductRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadiusValue),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('SUBMIT REQUEST'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'If you have any issues, feel free to reach Support (support@canadalocalproduce.ca)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}