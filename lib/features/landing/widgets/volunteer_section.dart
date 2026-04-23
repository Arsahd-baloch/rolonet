import 'package:flutter/material.dart';
import '../../../../shared/widgets/login_required_dialog.dart';

class VolunteerSection extends StatelessWidget {
  const VolunteerSection({super.key});

  static const _tasks = [
    {
      'title': 'Delivery Support',
      'desc': 'Help transport aid packages to remote and flood-affected areas.',
      'icon': Icons.local_shipping_rounded,
      'color': Color(0xFF3B82F6),
      'tag': 'Logistics',
    },
    {
      'title': 'Food Distribution',
      'desc':
          'Assist in sorting, packing and distributing food to families in need.',
      'icon': Icons.soup_kitchen_rounded,
      'color': Color(0xFF10B981),
      'tag': 'Food Aid',
    },
    {
      'title': 'Emergency Response',
      'desc':
          'Be on call for urgent relief operations during natural disasters.',
      'icon': Icons.emergency_rounded,
      'color': Color(0xFFEF4444),
      'tag': 'Urgent',
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.people_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volunteer Opportunities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Make a difference today',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Task cards
          ..._tasks.map((task) => _TaskCard(task: task)).toList(),
          const SizedBox(height: 8),
          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showLoginRequiredDialog(context),
              icon: const Icon(Icons.handshake_rounded, size: 18),
              label: const Text('Join Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
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

class _TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final Color color = task['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(task['icon'] as IconData, color: color, size: 24),
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
                        task['title'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
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
                        task['tag'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task['desc'] as String,
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
