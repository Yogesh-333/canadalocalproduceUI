// lib/widgets/product_grid.dart
// ... (previous imports)

import 'package:canada_produce/providers/products_provider.dart';
import 'package:canada_produce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  void initState() {
    super.initState();
    // Load products when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadProducts(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${provider.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.loadProducts(refresh: true);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.isLoading && provider.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: provider.products[index]);
          },
        );
      },
    );
  }
}
