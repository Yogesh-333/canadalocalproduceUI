// lib/widgets/products_section.dart
import 'package:canada_produce/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

import 'filter_bar.dart';
import 'pagination_controls.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({super.key});

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  @override
  void initState() {
    super.initState();
    // Load categories and products when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductsProvider>();
      provider.loadCategories();
      provider.loadProducts(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilterBar(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                sortBy: provider.sortBy,
                orderBy: provider.orderBy,
                onCategoryChanged: provider.setCategory,
                onSortChanged: provider.setSortBy,
                onOrderChanged: provider.setOrderBy,
              ),
            ),
            SizedBox(
              height: 800, // Adjust this height as needed
              child: ProductGrid(
                products: provider.products,
                isLoading: provider.isLoading,
              ),
            ),
            PaginationControls(
              currentPage: provider.currentPage,
              totalPages: provider.totalPages,
              onPageChanged: provider.setPage,
              isLoading: provider.isLoading,
            ),
          ],
        );
      },
    );
  }
}
