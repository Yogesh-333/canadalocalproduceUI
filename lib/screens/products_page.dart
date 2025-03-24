// lib/screens/products_page.dart
import 'package:canada_produce/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/filter_bar.dart';
import '../widgets/pagination_controls.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
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
            Expanded(
              child: Stack(
                children: [
                  ProductGrid(
                    products: provider.products,
                    isLoading: provider.isLoading,
                  ),
                  if (provider.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
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
