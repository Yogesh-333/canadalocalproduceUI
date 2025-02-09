// lib/widgets/product_card.dart
import 'package:canada_produce/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    required this.product,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          // Handle product click
          if (widget.product.affiliateUrl.isNotEmpty) {
            // Launch URL
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
          child: Card(
            elevation: isHovered ? 8 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: CachedImageWidget(
                      imageUrl: widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Content Section
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Text(
                        '\$${widget.product.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE31837),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Description
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Optional: Add to Cart or View Details Button
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button click
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isHovered
                                  ? const Color(0xFFE31837)
                                  : Colors.white,
                              foregroundColor: isHovered
                                  ? Colors.white
                                  : const Color(0xFFE31837),
                              elevation: isHovered ? 4 : 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: Color(0xFFE31837),
                                ),
                              ),
                            ),
                            child: const Text('View Details'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
