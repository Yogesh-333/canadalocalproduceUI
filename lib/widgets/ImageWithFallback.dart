// lib/widgets/common_widgets.dart
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const ImageWithFallback({
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AppConstants.defaultImagePath,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
        );
      },
    );
  }
}
