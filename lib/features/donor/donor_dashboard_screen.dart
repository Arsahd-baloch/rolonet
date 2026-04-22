import 'package:flutter/material.dart';

class DonorDashboardScreen extends StatelessWidget {
  const DonorDashboardScreen({super.key});

  // Simulate logged-in state (placeholder)
  static const bool _isLoggedIn = false;

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E40AF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_outline, color: Color(0xFF1E40AF), size: 28),
        ),
        title: const Text(
          'Login Required',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: const Text(
          'Please login to donate.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to Login screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
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
            _AppBar(onLoginTap: () {
              // TODO: Navigate to Login screen
            }),
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
                        } else {
                          // TODO: Navigate to donation flow
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

// ─────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onLoginTap;
  const _AppBar({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white,
      child: Row(
        children: [
          // Title
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donor Hub',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              Text(
                'Support causes that matter',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const Spacer(),
          // Search icon
          IconButton(
            onPressed: () {
              // TODO: Open search
            },
            icon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 24),
          ),
          const SizedBox(width: 4),
          // Login/Register button
          ElevatedButton(
            onPressed: onLoginTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            child: const Text('Login'),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF34D399)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 60,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Make a Difference',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Explore items\nyou can donate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Support real-world causes and help communities in need.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Image placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 42),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// IMPACT SECTION
// ─────────────────────────────────────────────
class _ImpactSection extends StatelessWidget {
  static const _stats = [
    {'value': '12,400', 'label': 'Lives Helped', 'icon': Icons.favorite_rounded, 'color': Color(0xFFEF4444)},
    {'value': '340', 'label': 'Active Campaigns', 'icon': Icons.campaign_rounded, 'color': Color(0xFF3B82F6)},
    {'value': 'PKR 8.2M', 'label': 'Total Donations', 'icon': Icons.attach_money_rounded, 'color': Color(0xFF10B981)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Your Impact Matters', subtitle: 'Collective donor contribution'),
          const SizedBox(height: 14),
          Row(
            children: (_stats as List<Map<String, dynamic>>)
                .map((s) => Expanded(child: _StatCard(stat: s)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Map<String, dynamic> stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final Color color = stat['color'] as Color;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(stat['icon'] as IconData, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            stat['value'] as String,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            stat['label'] as String,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DONATION CATEGORIES GRID
// ─────────────────────────────────────────────
class _CategoriesSection extends StatelessWidget {
  static const _categories = [
    {'title': 'Clothing', 'desc': 'Clothes, blankets, shoes', 'icon': Icons.checkroom_rounded, 'color': Color(0xFF8B5CF6)},
    {'title': 'Food', 'desc': 'Packaged food, dry goods', 'icon': Icons.fastfood_rounded, 'color': Color(0xFF10B981)},
    {'title': 'Furniture', 'desc': 'Beds, chairs, tables', 'icon': Icons.chair_rounded, 'color': Color(0xFFF59E0B)},
    {'title': 'Money', 'desc': 'Financial support for campaigns', 'icon': Icons.attach_money_rounded, 'color': Color(0xFF3B82F6)},
    {'title': 'Medical', 'desc': 'First aid, medicines', 'icon': Icons.medical_services_rounded, 'color': Color(0xFFEF4444)},
    {'title': 'Other Items', 'desc': 'General donations', 'icon': Icons.category_rounded, 'color': Color(0xFF64748B)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Donation Categories', subtitle: 'Choose what you want to give'),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, i) {
              final item = _categories[i] as Map<String, dynamic>;
              return _CategoryCard(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color color = item['color'] as Color;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // TODO: Navigate to category detail
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: color, size: 22),
              ),
              const Spacer(),
              Text(
                item['title'] as String,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 3),
              Text(
                item['desc'] as String,
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FEATURED CAMPAIGNS
// ─────────────────────────────────────────────
class _FeaturedCampaignsSection extends StatelessWidget {
  final void Function(BuildContext context) onDonateTap;

  const _FeaturedCampaignsSection({required this.onDonateTap});

  static const _campaigns = [
    {
      'title': 'Winter Relief 2025',
      'ngo': 'Al-Khidmat Foundation',
      'progress': 0.70,
      'raised': 'PKR 350K',
      'goal': 'PKR 500K',
      'color': Color(0xFF3B82F6),
      'icon': Icons.ac_unit_rounded,
    },
    {
      'title': 'Emergency Food Drive',
      'ngo': 'Edhi Foundation',
      'progress': 0.45,
      'raised': 'PKR 90K',
      'goal': 'PKR 200K',
      'color': Color(0xFF10B981),
      'icon': Icons.soup_kitchen_rounded,
    },
    {
      'title': 'Medical Supply Run',
      'ngo': 'CSSR Pakistan',
      'progress': 0.88,
      'raised': 'PKR 440K',
      'goal': 'PKR 500K',
      'color': Color(0xFFEF4444),
      'icon': Icons.medical_services_rounded,
    },
    {
      'title': 'Shelter for Flood Victims',
      'ngo': 'Saylani Welfare',
      'progress': 0.35,
      'raised': 'PKR 175K',
      'goal': 'PKR 500K',
      'color': Color(0xFFF59E0B),
      'icon': Icons.home_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: const _SectionHeader(title: 'Featured Campaigns', subtitle: 'Ongoing relief operations'),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: _campaigns.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final campaign = _campaigns[i] as Map<String, dynamic>;
                return _CampaignCard(
                  campaign: campaign,
                  onDonateTap: () => onDonateTap(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Map<String, dynamic> campaign;
  final VoidCallback onDonateTap;

  const _CampaignCard({required this.campaign, required this.onDonateTap});

  @override
  Widget build(BuildContext context) {
    final Color color = campaign['color'] as Color;
    final double progress = campaign['progress'] as double;

    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(campaign['icon'] as IconData, color: Colors.white, size: 38),
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign['title'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  campaign['ngo'] as String,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(progress * 100).toInt()}% funded · ${campaign['raised']}',
                  style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDonateTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                    child: const Text('Donate'),
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

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }
}
