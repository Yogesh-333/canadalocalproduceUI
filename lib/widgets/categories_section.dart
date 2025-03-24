// lib/widgets/categories_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/category.dart';

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category?) onCategorySelected;
  final bool isLoading;

  // Define popular category IDs
  static const List<int> popularCategoryIds = [
    1, // Food & Grocery
    5, // Fruits & Vegetables
    6, // Meat & Poultry
    4, // Dairy & Eggs
    8, // Bakery
    2, // Beverages
    7, // Seafood
    3, // Snacks
  ];

  const CategoriesSection({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CategoriesLoadingIndicator();
    }

    final popularCategories =
        categories.where((cat) => popularCategoryIds.contains(cat.id)).toList();
    final otherCategories = categories
        .where((cat) => !popularCategoryIds.contains(cat.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (selectedCategory != null) ...[
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => onCategorySelected(null),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ...popularCategories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CategoryChip(
                    category: category,
                    isSelected: category.id == selectedCategory?.id,
                    onSelected: () => onCategorySelected(
                      category.id == selectedCategory?.id ? null : category,
                    ),
                  ),
                );
              }),
              // More Categories Button
              MoreCategoriesButton(
                allCategories: categories,
                otherCategories: otherCategories,
                selectedCategory: selectedCategory,
                onCategorySelected: onCategorySelected,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MoreCategoriesButton extends StatelessWidget {
  final List<Category> allCategories;
  final List<Category> otherCategories;
  final Category? selectedCategory;
  final Function(Category?) onCategorySelected;

  const MoreCategoriesButton({
    required this.allCategories,
    required this.otherCategories,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showCategoriesDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      icon: const Icon(Icons.grid_view),
      label: const Text('More Categories'),
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AllCategoriesDialog(
        categories: allCategories,
        selectedCategory: selectedCategory,
        onCategorySelected: (category) {
          onCategorySelected(category);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class AllCategoriesDialog extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category?) onCategorySelected;

  const AllCategoriesDialog({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: categories.map((category) {
                    return CategoryChip(
                      category: category,
                      isSelected: category.id == selectedCategory?.id,
                      onSelected: () => onCategorySelected(
                        category.id == selectedCategory?.id ? null : category,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatefulWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFE31837)
                : isHovered
                    ? Colors.grey[100]
                    : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFE31837)
                  : Colors.grey[300]!,
            ),
            boxShadow: [
              if (widget.isSelected || isHovered)
                BoxShadow(
                  color: widget.isSelected
                      ? const Color(0xFFE31837).withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Text(
            widget.category.name,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoriesLoadingIndicator extends StatelessWidget {
  const CategoriesLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(
              6,
              (index) => Container(
                margin: const EdgeInsets.only(right: 12),
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
