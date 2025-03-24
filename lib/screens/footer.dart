// lib/widgets/footer_widget.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/ProductRequestDialog.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          // Development status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[800]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.construction, color: Colors.amber[300], size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'This website is still in development. We appreciate your patience as we continue to improve the platform.',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product submission callout
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.only(bottom: 48),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 768;

                if (isWideScreen) {
                  return Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SELL YOUR PRODUCTS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Join our marketplace and reach customers across Canada. List your fresh produce and grow your business today.',
                              style: TextStyle(
                                color: Colors.grey,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ProductRequestDialog.show(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'ADD YOUR PRODUCT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SELL YOUR PRODUCTS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Join our marketplace and reach customers across Canada. List your fresh produce and grow your business today.',
                        style: TextStyle(
                          color: Colors.grey,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ProductRequestDialog.show(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'ADD YOUR PRODUCT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // Non-profit message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 48),
            decoration: BoxDecoration(
              color: Colors.green[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[800]!, width: 1),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 768;

                if (isWideScreen) {
                  return Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WE ARE A NON-PROFIT INITIATIVE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'This platform is dedicated solely to supporting Canadian native products. You can help by spreading the word or making a small donation to keep this initiative going.',
                              style: TextStyle(
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrl(Uri.parse('mailto:support@canadalocalproduce.ca?subject=Support%20Donation'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green[900],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'SUPPORT US',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WE ARE A NON-PROFIT INITIATIVE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This platform is dedicated solely to supporting Canadian native products. You can help by spreading the word or making a small donation to keep this initiative going.',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrl(Uri.parse('mailto:support@canadalocalproduce.ca?subject=Support%20Donation'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green[900],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'SUPPORT US',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // Top section with columns
          LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              return isWideScreen
                  ? _buildWideFooter()
                  : _buildNarrowFooter();
            },
          ),

          const SizedBox(height: 48),

          // Divider
          Container(
            height: 1,
            color: Colors.grey[800],
          ),

          const SizedBox(height: 32),

          // Copyright and social icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '© ${DateTime.now().year} Canada Produce. All rights reserved. A non-profit initiative. Site under development.',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              Row(
                children: [
                  _buildSocialIcon(Icons.facebook)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWideFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company info
        const Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CANADA PRODUCE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Your trusted source for fresh, local produce throughout Canada. Supporting local farmers and bringing quality to your table.',
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),

        // Quick links
        Expanded(
          child: _buildLinkColumn('EXPLORE', [
            'Home',
            'About Us',
            'Products',
            'Contact',
          ]),
        ),

        // Categories
        Expanded(
          child: _buildLinkColumn('SHOP', [
            'Fruits',
            'Vegetables',
            'Organic',
            'Seasonal',
          ]),
        ),

        // Contact info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CONNECT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactItem(
                Icons.location_on_outlined,
                '123 Produce Lane, Toronto, ON',
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                Icons.phone_outlined,
                '+1 (123) 456-7890',
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                Icons.email_outlined,
                'info@canadaproduce.com',
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                Icons.support_outlined,
                'support@canadaproduce.com',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company info
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CANADA PRODUCE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Your trusted source for fresh, local produce throughout Canada. Supporting local farmers and bringing quality to your table.',
              style: TextStyle(
                color: Colors.grey,
                height: 1.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Quick links
        _buildLinkColumn('EXPLORE', [
          'Home',
          'About Us',
          'Products',
          'Contact',
        ]),
        const SizedBox(height: 32),

        // Categories
        _buildLinkColumn('SHOP', [
          'Fruits',
          'Vegetables',
          'Organic',
          'Seasonal',
        ]),
        const SizedBox(height: 32),

        // Contact info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONNECT',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildContactItem(
              Icons.location_on_outlined,
              '123 Produce Lane, Toronto, ON',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.phone_outlined,
              '+1 (123) 456-7890',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.email_outlined,
              'info@canadaproduce.com',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.support_outlined,
              'support@canadaproduce.com',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              // Add navigation logic here
            },
            child: Text(
              link,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }
}