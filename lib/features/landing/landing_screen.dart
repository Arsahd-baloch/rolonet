import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Header(),
              _HeroSection(),
              _RoleSectionTitle(),
              _RoleCardsSection(),
              _AboutSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo + App Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ReliefNet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Connecting Aid. Delivering Hope.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Login button
          TextButton(
            onPressed: () => AppRouter.toLogin(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          const SizedBox(width: 4),
          // Register button
          ElevatedButton(
            onPressed: () => AppRouter.toRoleSelection(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hero icon placeholder
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            'ReliefNet connects donors, volunteers, NGOs, and beneficiaries into one unified humanitarian system.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              height: 1.65,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 28),
          // Quick stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroStat(value: '1,200+', label: 'Donors'),
              _VerticalDivider(),
              _HeroStat(value: '340+', label: 'Volunteers'),
              _VerticalDivider(),
              _HeroStat(value: '85+', label: 'NGOs'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.25),
    );
  }
}

// ─────────────────────────────────────────────
// ROLE SECTION TITLE
// ─────────────────────────────────────────────
class _RoleSectionTitle extends StatelessWidget {
  const _RoleSectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 32, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Role',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Select how you want to contribute to ReliefNet',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROLE CARDS SECTION
// ─────────────────────────────────────────────
class _RoleCardsSection extends StatelessWidget {
  const _RoleCardsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: const [
          _RoleCard(
            icon: Icons.business_center_rounded,
            title: 'NGO',
            description: 'Manage campaigns and distribute aid',
            color: Color(0xFF3B82F6),
          ),
          SizedBox(height: 12),
          _RoleCard(
            icon: Icons.volunteer_activism_rounded,
            title: 'Donor',
            description: 'Donate money, items, and support causes',
            color: Color(0xFF10B981),
          ),
          SizedBox(height: 12),
          _RoleCard(
            icon: Icons.people_rounded,
            title: 'Volunteer',
            description: 'Help in real-world relief operations',
            color: Color(0xFF8B5CF6),
          ),
          SizedBox(height: 12),
          _RoleCard(
            icon: Icons.health_and_safety_rounded,
            title: 'Beneficiary',
            description: 'Request and receive assistance',
            color: Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          AppRouter.toRoleDashboard(context, title.toLowerCase());
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ABOUT SECTION
// ─────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'About ReliefNet',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'ReliefNet is a humanitarian aid platform designed to improve transparency, coordination, and delivery of support.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'ReliefNet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Connecting Aid. Delivering Hope.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2025 ReliefNet. All rights reserved.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
