// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import '../widgets/banner_section.dart';
import '../widgets/products_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerSection(),
            ProductsSection(),
          ],
        ),
      ),
    );
  }
}
