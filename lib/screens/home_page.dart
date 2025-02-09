// lib/screens/home_page.dart
import 'package:canada_produce/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import '../widgets/banner_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerSection(),
            SizedBox(
              height: 800, // Adjust this height as needed
              child: ProductGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
