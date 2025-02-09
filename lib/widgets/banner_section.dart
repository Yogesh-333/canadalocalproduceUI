// lib/widgets/banner_section.dart
import 'package:canada_produce/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  bool isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE31837), // Canadian Red
            const Color(0xFFE31837).withOpacity(0.9),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Row(
              children: [
                // Left side content
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '🍁',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '100% Canadian Produce',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -30, duration: 600.ms),

                      const SizedBox(height: 32),

                      // Main heading
                      const Text(
                        'Support Local\nCanadian Farmers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -30, duration: 600.ms),

                      const SizedBox(height: 24),

                      // Subheading
                      Text(
                        'Fresh from Canadian farms to your table.\nSupporting sustainable agriculture and local communities.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 20,
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideX(begin: -30, duration: 600.ms),

                      const SizedBox(height: 40),

                      // Button
                      MouseRegion(
                        onEnter: (_) => setState(() => isButtonHovered = true),
                        onExit: (_) => setState(() => isButtonHovered = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()
                            ..scale(isButtonHovered ? 1.05 : 1.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFE31837),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: isButtonHovered ? 8 : 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Explore Products',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  transform: Matrix4.identity()
                                    ..translate(isButtonHovered ? 5.0 : 0.0),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(begin: -30, duration: 600.ms),
                    ],
                  ),
                ),

                // Right side - Logo
                // Right side - Logo
                // Right side - Logo
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Bottom white box
                        Container(
                          width: 280,
                          height: 320,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                        ),

                        // Middle red box
                        Positioned(
                          child: Container(
                            width: 240, // Smaller than white box
                            height: 280, // Smaller than white box
                            decoration: BoxDecoration(
                              color: const Color(0xFFE31837),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFE31837).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Logo on top
                        Positioned(
                          child: Image.asset(
                            AppConstants.logoUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.3, duration: 800.ms),
                  ),
                ),
              ],
            ),
          ),

          // Background decorative elements
          Positioned(
            right: -100,
            top: -100,
            child: Icon(
              Icons.eco,
              size: 400,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }
}
