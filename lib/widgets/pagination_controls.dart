// lib/widgets/pagination_controls.dart
import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool isLoading;

  const PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Page Button
          IconButton(
            onPressed: currentPage > 1 && !isLoading
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),

          // Page Numbers
          Row(
            children: _buildPageNumbers(),
          ),

          // Next Page Button
          IconButton(
            onPressed: currentPage < totalPages && !isLoading
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];

    // Always show first page
    pageNumbers.add(_buildPageButton(1));

    // Add ellipsis if needed
    if (currentPage > 3) {
      pageNumbers.add(const Text('...'));
    }

    // Add pages around current page
    for (int i = currentPage - 1; i <= currentPage + 1; i++) {
      if (i > 1 && i < totalPages) {
        pageNumbers.add(_buildPageButton(i));
      }
    }

    // Add ellipsis if needed
    if (currentPage < totalPages - 2) {
      pageNumbers.add(const Text('...'));
    }

    // Always show last page
    if (totalPages > 1) {
      pageNumbers.add(_buildPageButton(totalPages));
    }

    return pageNumbers;
  }

  Widget _buildPageButton(int pageNumber) {
    final isSelected = pageNumber == currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed:
            isLoading || isSelected ? null : () => onPageChanged(pageNumber),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE31837) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFFE31837),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(pageNumber.toString()),
      ),
    );
  }
}
