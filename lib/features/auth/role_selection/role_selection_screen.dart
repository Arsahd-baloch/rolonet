import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Get Started'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Role',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                'Select how you want to join ReliefNet',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              _RoleCard(
                title: 'NGO',
                subtitle: 'Register as NGO',
                description: 'For organizations managing aid',
                icon: Icons.business_center_rounded,
                color: AppTheme.secondaryBlue,
                role: 'ngo',
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Donor',
                subtitle: 'Register as Donor',
                description: 'For people donating money or items',
                icon: Icons.volunteer_activism_rounded,
                color: AppTheme.successGreen,
                role: 'donor',
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Volunteer',
                subtitle: 'Register as Volunteer',
                description: 'For field support workers',
                icon: Icons.people_rounded,
                color: const Color(0xFF8B5CF6),
                role: 'volunteer',
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Beneficiary',
                subtitle: 'Register as Beneficiary',
                description: 'For people seeking help',
                icon: Icons.health_and_safety_rounded,
                color: AppTheme.errorRed,
                role: 'beneficiary',
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: () => AppRouter.toLogin(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String role;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => AppRouter.toRegister(context, role: role),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
