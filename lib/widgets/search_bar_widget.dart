// lib/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'dart:async';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final bool isLoading;

  const SearchBarWidget({
    required this.onSearch,
    this.isLoading = false,
    super.key,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late PageController _suggestionsController;
  Timer? _suggestionTimer;

  // Common search suggestions
  final List<String> searchSuggestions = [
    'Fresh Vegetables',
    'Organic Fruits',
    'Local Honey',
    'Maple Syrup',
    'Farm Fresh Eggs',
    'Artisan Bread',
    'Canadian Cheese',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _suggestionsController = PageController(
      viewportFraction: 1,
      initialPage: 0,
    );

    _startSuggestionAnimation();
  }

  void _startSuggestionAnimation() {
    _suggestionTimer?.cancel();
    _suggestionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_isFocused && _controller.text.isEmpty) {
        final nextPage = (_suggestionsController.page?.toInt() ?? 0) + 1;
        _suggestionsController.animateToPage(
          nextPage % searchSuggestions.length,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _suggestionsController.dispose();
    _suggestionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          // Rotating border
          if (!_isFocused)
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(500, 50),
                  painter: SearchBarBorderPainter(
                    animation: _rotationAnimation.value,
                    primaryColor: const Color(0xFFE31837),
                  ),
                );
              },
            ),

          // Search input with suggestions
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: _isFocused
                      ? Border.all(color: const Color(0xFFE31837), width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Scrolling suggestions (behind TextField)
                    if (!_isFocused && _controller.text.isEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: PageView.builder(
                          controller: _suggestionsController,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final suggestion = searchSuggestions[
                                index % searchSuggestions.length];
                            return Center(
                              child: Text(
                                suggestion,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // TextField (on top, with transparent background)
                    Focus(
                      onFocusChange: (focused) {
                        setState(() => _isFocused = focused);
                      },
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: '',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Icon(
                              Icons.search,
                              color: _isFocused
                                  ? const Color(0xFFE31837)
                                  : Colors.grey,
                            ),
                          ),
                          suffixIcon: widget.isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE31837),
                                    strokeWidth: 2,
                                  ),
                                )
                              : _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _controller.clear();
                                        widget.onSearch('');
                                      },
                                    )
                                  : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onChanged: widget.onSearch,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarBorderPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;

  SearchBarBorderPainter({
    required this.animation,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(25),
    );

    // Create a path for the rounded rectangle
    final path = Path();

    // Top right curve
    path.moveTo(size.width - 25, 0);
    path.arcToPoint(
      Offset(size.width, 25),
      radius: const Radius.circular(25),
      clockwise: true,
    );

    // Right side
    path.lineTo(size.width, size.height - 25);

    // Bottom right curve
    path.arcToPoint(
      Offset(size.width - 25, size.height),
      radius: const Radius.circular(25),
      clockwise: true,
    );

    // Bottom side
    path.lineTo(25, size.height);

    // Bottom left curve
    path.arcToPoint(
      Offset(0, size.height - 25),
      radius: const Radius.circular(25),
      clockwise: true,
    );

    // Left side
    path.lineTo(0, 25);

    // Top left curve
    path.arcToPoint(
      Offset(25, 0),
      radius: const Radius.circular(25),
      clockwise: true,
    );

    // Top side
    path.lineTo(size.width - 25, 0);

    final metrics = path.computeMetrics().first;
    final length = metrics.length;

    // Calculate positions for two lines
    final lineLength = length * 0.12; // Length of each line

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = primaryColor;

    // Draw first line
    final firstLineStart = metrics.getTangentForOffset(
      (length * animation) % length,
    )!;
    final firstLineEnd = metrics.getTangentForOffset(
      (length * animation + lineLength) % length,
    )!;

    // Draw second line (opposite side)
    final secondLineStart = metrics.getTangentForOffset(
      (length * (animation + 0.5)) % length,
    )!;
    final secondLineEnd = metrics.getTangentForOffset(
      (length * (animation + 0.5) + lineLength) % length,
    )!;

    // Draw the lines following the path tangent
    canvas.drawLine(
      firstLineStart.position,
      firstLineEnd.position,
      paint,
    );
    canvas.drawLine(
      secondLineStart.position,
      secondLineEnd.position,
      paint,
    );
  }

  @override
  bool shouldRepaint(SearchBarBorderPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
