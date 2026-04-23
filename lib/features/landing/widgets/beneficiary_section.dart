import 'package:flutter/material.dart';
import '../../../../shared/widgets/login_required_dialog.dart';

class BeneficiarySection extends StatelessWidget {
  const BeneficiarySection({super.key});

  static const _beneficiaries = [
    {
      'name': 'Fatima & 3 Children',
      'need':
          'Urgent food supply and winter clothing for family displaced by flooding.',
      'location': 'Sindh, Pakistan',
      'avatar': 'F',
      'color': Color(0xFFEF4444),
      'urgency': 'Urgent',
    },
    {
      'name': 'Ahmad Family',
      'need':
          'Temporary shelter and basic household items after losing home in earthquake.',
      'location': 'AJK, Pakistan',
      'avatar': 'A',
      'color': Color(0xFFF59E0B),
      'urgency': 'High',
    },
    {
      'name': 'Elderly Couple',
      'need':
          'Regular medical care and monthly medication for chronic conditions.',
      'location': 'Lahore, Punjab',
      'avatar': 'E',
      'color': Color(0xFF3B82F6),
      'urgency': 'Moderate',
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
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'People in Need',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Real stories, real impact',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Beneficiary cards
          ..._beneficiaries.map((b) => _BeneficiaryCard(data: b)).toList(),
          const SizedBox(height: 8),
          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showLoginRequiredDialog(context),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Request Help'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
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

class _BeneficiaryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _BeneficiaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final Color color = data['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.15),
            child: Text(
              data['avatar'] as String,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['name'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    // Urgency badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data['urgency'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      data['location'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data['need'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.5,
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
