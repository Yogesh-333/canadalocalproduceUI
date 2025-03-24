// lib/widgets/sorting_controls.dart
import 'package:flutter/material.dart';

class SortingControls extends StatelessWidget {
  final String? sortBy;
  final String? orderBy;
  final Function(String?) onSortChanged;
  final Function(String?) onOrderChanged;

  const SortingControls({
    required this.sortBy,
    required this.orderBy,
    required this.onSortChanged,
    required this.onOrderChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Sort By Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortBy,
              hint: const Text('Sort By'),
              items: const [
                DropdownMenuItem(value: 'price', child: Text('Price')),
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'created_at', child: Text('Date')),
              ],
              onChanged: onSortChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Order By Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: orderBy,
              hint: const Text('Order'),
              items: const [
                DropdownMenuItem(value: 'asc', child: Text('Ascending')),
                DropdownMenuItem(value: 'desc', child: Text('Descending')),
              ],
              onChanged: onOrderChanged,
            ),
          ),
        ),
      ],
    );
  }
}
