// lib/widgets/product_request_dialog.dart
import 'package:flutter/material.dart';
import '../screens/ProductRequestForm.dart';


class ProductRequestDialog extends StatelessWidget {
  const ProductRequestDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ProductRequestForm(
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}