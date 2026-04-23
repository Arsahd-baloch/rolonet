import 'package:flutter/material.dart';
import '../../../../shared/widgets/login_required_dialog.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background decoration circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Humanitarian Aid Platform',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Helping\nCommunities\nin Crisis',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  'ReliefNet connects donors, volunteers, NGOs and beneficiaries — making humanitarian aid faster, transparent and more effective.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => showLoginRequiredDialog(context),
                        icon: const Icon(Icons.volunteer_activism, size: 18),
                        label: const Text('Donate Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E40AF),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => showLoginRequiredDialog(context),
                        icon: const Icon(Icons.people_outline, size: 18),
                        label: const Text('Be a Volunteer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Stats row
                Row(
                  children: [
                    _StatItem(value: '1,200+', label: 'Donors'),
                    _StatDivider(),
                    _StatItem(value: '340+', label: 'Volunteers'),
                    _StatDivider(),
                    _StatItem(value: '85', label: 'NGOs'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.25),
    );
  }
}
