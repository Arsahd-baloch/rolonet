import 'package:flutter/material.dart';

class DonorDashboardScreen extends StatelessWidget {
  const DonorDashboardScreen({super.key});

  static const bool _isLoggedIn = false;

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Login Required',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: const Text(
          'Please login to donate.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroSection(),
                    _ImpactSection(),
                    _CategoriesSection(),
                    _FeaturedCampaignsSection(
                      onDonateTap: (context) {
                        if (!_isLoggedIn) {
                          _showLoginDialog(context);
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── HERO ─────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF10B981),
      ),
      child: const Text(
        "Explore items you can donate",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

// ───────────────────────── IMPACT ─────────────────────────
class _ImpactSection extends StatelessWidget {
  static const stats = [
    {
      'value': '12,400',
      'label': 'Lives Helped',
      'icon': Icons.favorite,
      'color': Color(0xFFEF4444),
    },
    {
      'value': '340',
      'label': 'Campaigns',
      'icon': Icons.campaign,
      'color': Color(0xFF3B82F6),
    },
    {
      'value': 'PKR 8.2M',
      'label': 'Donations',
      'icon': Icons.attach_money,
      'color': Color(0xFF10B981),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: stats.map((s) {
          final color = s['color'] as Color;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ✅ FIX
                children: [
                  Icon(s['icon'] as IconData, color: color),
                  const SizedBox(height: 8),
                  Text(
                    s['value'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s['label'] as String,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ───────────────────────── CATEGORIES ─────────────────────────
class _CategoriesSection extends StatelessWidget {
  static const categories = [
    {'title': 'Food', 'icon': Icons.fastfood, 'color': Color(0xFF10B981)},
    {'title': 'Clothes', 'icon': Icons.checkroom, 'color': Color(0xFF8B5CF6)},
    {'title': 'Medical', 'icon': Icons.medical_services, 'color': Color(0xFFEF4444)},
    {'title': 'Money', 'icon': Icons.attach_money, 'color': Color(0xFF3B82F6)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0, // ✅ FIX OVERFLOW
        ),
        itemBuilder: (context, i) {
          final item = categories[i];
          final color = item['color'] as Color;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ FIX
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item['icon'] as IconData, color: color),
                const Spacer(),
                Text(
                  item['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ───────────────────────── CAMPAIGNS ─────────────────────────
class _FeaturedCampaignsSection extends StatelessWidget {
  final void Function(BuildContext context) onDonateTap;

  const _FeaturedCampaignsSection({required this.onDonateTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Featured Campaigns",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(3, (i) {
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text("Campaign")),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}