// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/products_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider()..loadProducts(refresh: true),
        ),
      ],
      child: MaterialApp(
        title: 'Canadian Local Produce',
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Poppins',
        ),
        home: const HomePage(),
      ),
    );
  }
}
