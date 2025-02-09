// lib/widgets/filter_bar.dart
import 'package:flutter/material.dart';
import '../models/category.dart';

class FilterBar extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final String? sortBy;
  final String? orderBy;
  final Function(Category?) onCategoryChanged;
  final Function(String) onSortChanged;
  final Function(String) onOrderChanged;

  const FilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.sortBy,
    required this.orderBy,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onOrderChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Categories Dropdown
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Category>(
                value: selectedCategory,
                hint: const Text('All Categories'),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<Category>(
                    value: null,
                    child: Text('All Categories'),
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                ],
                onChanged: onCategoryChanged,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Sort By Dropdown
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortBy,
                hint: const Text('Sort By'),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'price', child: Text('Price')),
                  DropdownMenuItem(value: 'name', child: Text('Name')),
                  DropdownMenuItem(value: 'created_at', child: Text('Date')),
                ],
                onChanged: (value) {
                  if (value != null) onSortChanged(value);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Order By Dropdown
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: orderBy,
                hint: const Text('Order'),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'asc', child: Text('Ascending')),
                  DropdownMenuItem(value: 'desc', child: Text('Descending')),
                ],
                onChanged: (value) {
                  if (value != null) onOrderChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
