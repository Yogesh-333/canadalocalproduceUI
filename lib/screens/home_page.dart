// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/ProductRequestDialog.dart';
import '../widgets/banner_section.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/categories_section.dart';
import '../widgets/sorting_controls.dart';
import '../widgets/product_grid.dart';
import '../widgets/pagination_controls.dart';
import 'footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Create a pulsing scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).loadCategories();
      Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Banner Section
          const SliverToBoxAdapter(
            child: BannerSection(),
          ),

          // Search, Categories, and Sorting Section
          SliverToBoxAdapter(
            child: Consumer<ProductsProvider>(
              builder: (context, provider, child) {
                return Container(
                  color: Colors.grey[50],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      // Search Bar
                      Center(
                        child: SearchBarWidget(
                          onSearch: provider.searchProducts,
                          isLoading: provider.isSearching,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Categories
                      if (provider.categories.isNotEmpty) ...[
                        CategoriesSection(
                          categories: provider.categories,
                          selectedCategory: provider.selectedCategory,
                          onCategorySelected: provider.setCategory,
                          isLoading: provider.isLoading,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Sorting Controls
                      SortingControls(
                        sortBy: provider.sortBy,
                        orderBy: provider.orderBy,
                        onSortChanged: provider.setSortBy,
                        onOrderChanged: provider.setOrderBy,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Products Section
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Consumer<ProductsProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      // Products Grid
                      ProductGrid(
                        products: provider.products,
                        isLoading: provider.isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Pagination
                      if (provider.products.isNotEmpty)
                        PaginationControls(
                          currentPage: provider.currentPage,
                          totalPages: provider.totalPages,
                          onPageChanged: provider.setPage,
                          isLoading: provider.isLoading,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Footer Section
          const SliverToBoxAdapter(
            child: FooterWidget(),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            ProductRequestDialog.show(context);
          },
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('List Your Product', style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          )),
        ),
      ),
    );
  }
}