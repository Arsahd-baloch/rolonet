import 'package:flutter/material.dart';
import '../../../../shared/widgets/login_required_dialog.dart';

class DonorSection extends StatelessWidget {
  const DonorSection({super.key});

  static const _items = [
    {
      'label': 'Clothes',
      'icon': Icons.checkroom_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'label': 'Food',
      'icon': Icons.fastfood_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'label': 'Furniture',
      'icon': Icons.chair_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'label': 'Money',
      'icon': Icons.attach_money_rounded,
      'color': Color(0xFF3B82F6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.volunteer_activism_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What You Can Donate',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Every contribution counts',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 2x2 Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1,
            children: _items.map((item) => _DonationItem(item: item)).toList(),
          ),
          const SizedBox(height: 24),
          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showLoginRequiredDialog(context),
              icon: const Icon(Icons.favorite_rounded, size: 18),
              label: const Text('Start Donating'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const _DonationItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color color = item['color'] as Color;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'] as IconData, color: color, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            item['label'] as String,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
