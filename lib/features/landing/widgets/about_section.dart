import 'package:flutter/material.dart';
import '../../../../shared/widgets/login_required_dialog.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // About content
        Container(
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
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About ReliefNet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                      Text('Our mission & values', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Description
              const Text(
                'ReliefNet is a humanitarian coordination platform built to bridge the gap between those who have the capacity to help and those who desperately need it.',
                style: TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.7),
              ),
              const SizedBox(height: 12),
              const Text(
                'By connecting NGOs, donors, volunteers, and beneficiaries in one unified platform, we make aid distribution faster, more transparent, and more impactful. Every donation is tracked, every volunteer effort is coordinated, and every beneficiary is heard.',
                style: TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.7),
              ),
              const SizedBox(height: 24),
              // Value pills
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _ValuePill(label: 'Transparency', icon: Icons.visibility_outlined),
                  _ValuePill(label: 'Speed', icon: Icons.flash_on_rounded),
                  _ValuePill(label: 'Trust', icon: Icons.verified_outlined),
                  _ValuePill(label: 'Impact', icon: Icons.trending_up_rounded),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showLoginRequiredDialog(context),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Learn More'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E40AF),
                    side: const BorderSide(color: Color(0xFF1E40AF), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Footer
        Container(
          width: double.infinity,
          color: const Color(0xFF1E293B),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ReliefNet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Connecting Relief, Restoring Hope.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFF334155), height: 1),
              const SizedBox(height: 16),
              const Text(
                '© 2025 ReliefNet. All rights reserved.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValuePill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ValuePill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF1E40AF)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        ],
      ),
    );
  }
}
