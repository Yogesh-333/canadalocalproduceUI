// lib/widgets/top_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import 'common_widgets.dart'; // Make sure this import is added

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageWithFallback(
            // Changed from NetworkImageWithFallback to ImageWithFallback
            imageUrl: AppConstants.logoUrl,
            height: 40,
          ).animate().fadeIn(duration: 600.ms),
          Row(
            children: [
              _buildNavItem('Home'),
              _buildNavItem('Products'),
              _buildNavItem('About'),
              _buildNavItem('Contact'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 30, duration: 600.ms);
  }
}
