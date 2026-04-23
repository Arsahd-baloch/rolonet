import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String role;

  const RegisterScreen({super.key, required this.role});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Role display config
  Map<String, dynamic> get _roleConfig {
    switch (widget.role.toLowerCase()) {
      case 'ngo':
        return {
          'label': 'NGO',
          'color': AppTheme.secondaryBlue,
          'icon': Icons.business_center_rounded,
        };
      case 'donor':
        return {
          'label': 'Donor',
          'color': AppTheme.successGreen,
          'icon': Icons.volunteer_activism_rounded,
        };
      case 'volunteer':
        return {
          'label': 'Volunteer',
          'color': const Color(0xFF8B5CF6),
          'icon': Icons.people_rounded,
        };
      case 'beneficiary':
        return {
          'label': 'Beneficiary',
          'color': AppTheme.errorRed,
          'icon': Icons.health_and_safety_rounded,
        };
      default:
        return {
          'label': 'User',
          'color': AppTheme.primaryBlue,
          'icon': Icons.person_outline,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _roleConfig;
    final Color roleColor = config['color'] as Color;
    final String roleLabel = config['label'] as String;
    final IconData roleIcon = config['icon'] as IconData;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: roleColor.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(roleIcon, color: roleColor, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Register as $roleLabel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: roleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── COMMON FIELDS ──────────────────────────
                const _SectionLabel(text: 'Basic Information'),
                const SizedBox(height: 16),

                const _FieldLabel(text: 'Full Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Full name is required' : null,
                ),
                const SizedBox(height: 16),

                const _FieldLabel(text: 'Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Email is required' : null,
                ),
                const SizedBox(height: 16),

                const _FieldLabel(text: 'Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.textLight,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 16),

                const _FieldLabel(text: 'Phone Number'),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone_outlined, size: 20),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Phone number is required'
                      : null,
                ),

                // ── ROLE-SPECIFIC FIELDS ───────────────────
                const SizedBox(height: 32),
                const _SectionLabel(text: 'Role Information'),
                const SizedBox(height: 16),

                if (widget.role.toLowerCase() == 'ngo') ...[
                  const _FieldLabel(text: 'Organization Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter organization name',
                      prefixIcon: Icon(Icons.domain_rounded, size: 20),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Organization name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel(text: 'Registration Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter registration number',
                      prefixIcon: Icon(Icons.badge_outlined, size: 20),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Registration number is required'
                        : null,
                  ),
                ],

                if (widget.role.toLowerCase() == 'donor') ...[
                  const _FieldLabel(text: 'Donation Preference (Optional)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'e.g. Money, Food, Clothes',
                      prefixIcon: Icon(
                        Icons.favorite_outline_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                ],

                if (widget.role.toLowerCase() == 'volunteer') ...[
                  const _FieldLabel(text: 'Skills'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'e.g. First Aid, Driving, Logistics',
                      prefixIcon: Icon(Icons.build_outlined, size: 20),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Please enter at least one skill'
                        : null,
                  ),
                ],

                if (widget.role.toLowerCase() == 'beneficiary') ...[
                  const _FieldLabel(text: 'Address'),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Enter your address',
                      prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Address is required' : null,
                  ),
                ],

                const SizedBox(height: 48),

                // Submit button
                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authProvider);

                    // Show error snackbar if there's an error
                    ref.listen<AuthState>(authProvider, (previous, next) {
                      if (next.error != null && next.error != previous?.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(next.error!),
                            backgroundColor: AppTheme.errorRed,
                          ),
                        );
                      }
                    });

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await ref
                                      .read(authProvider.notifier)
                                      .register(
                                        name: _nameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        role: widget.role.toLowerCase(),
                                      );

                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Registration successful! Please log in.',
                                        ),
                                        backgroundColor: AppTheme.successGreen,
                                      ),
                                    );
                                    AppRouter.toLogin(context);
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: roleColor,
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text('Register as $roleLabel'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
  }
}
