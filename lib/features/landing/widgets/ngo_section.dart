import 'package:flutter/material.dart';
import '../../../../shared/widgets/login_required_dialog.dart';

class NgoSection extends StatelessWidget {
  const NgoSection({super.key});

  static const _campaigns = [
    {
      'title': 'Winter Relief 2025',
      'location': 'Karachi, Pakistan',
      'progress': 0.70,
      'raised': 'PKR 350K',
      'goal': 'PKR 500K',
      'color': Color(0xFF3B82F6),
      'icon': Icons.ac_unit_rounded,
    },
    {
      'title': 'Emergency Food Drive',
      'location': 'Quetta, Balochistan',
      'progress': 0.45,
      'raised': 'PKR 90K',
      'goal': 'PKR 200K',
      'color': Color(0xFF10B981),
      'icon': Icons.fastfood_rounded,
    },
    {
      'title': 'Medical Supply Run',
      'location': 'Peshawar, KPK',
      'progress': 0.88,
      'raised': 'PKR 440K',
      'goal': 'PKR 500K',
      'color': Color(0xFFEF4444),
      'icon': Icons.medical_services_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: Color(0xFF1E40AF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NGO Operations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Active relief campaigns',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Campaign cards
          ..._campaigns.map((c) => _CampaignCard(campaign: c)).toList(),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Map<String, dynamic> campaign;
  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final double progress = campaign['progress'] as double;
    final Color color = campaign['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Image placeholder
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  campaign['icon'] as IconData,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 6),
                Text(
                  campaign['location'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Card body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Raised: ${campaign['raised']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}% funded',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showLoginRequiredDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
