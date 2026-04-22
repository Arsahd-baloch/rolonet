import 'package:flutter/material.dart';

// ─── Mock Data Models ────────────────────────
enum CampaignStatus { active, draft, closed }

class _Campaign {
  final String title;
  final String description;
  final double progress;
  final CampaignStatus status;
  final Color color;
  final IconData icon;

  const _Campaign({
    required this.title,
    required this.description,
    required this.progress,
    required this.status,
    required this.color,
    required this.icon,
  });
}

class _InventoryItem {
  final String name;
  final int quantity;
  final int threshold;
  final String unit;
  final IconData icon;

  const _InventoryItem({
    required this.name,
    required this.quantity,
    required this.threshold,
    required this.unit,
    required this.icon,
  });

  bool get isLowStock => quantity <= threshold;
}

// ─────────────────────────────────────────────
// NGO DASHBOARD SCREEN
// ─────────────────────────────────────────────
class NgoDashboardScreen extends StatelessWidget {
  const NgoDashboardScreen({super.key});

  static const List<_Campaign> _campaigns = [
    _Campaign(
      title: 'Winter Relief 2025',
      description: 'Distributing warm clothing and blankets to flood-affected families across Sindh.',
      progress: 0.72,
      status: CampaignStatus.active,
      color: Color(0xFF3B82F6),
      icon: Icons.ac_unit_rounded,
    ),
    _Campaign(
      title: 'Emergency Food Drive',
      description: 'Providing packaged food and dry rations to displaced communities in Balochistan.',
      progress: 0.45,
      status: CampaignStatus.active,
      color: Color(0xFF10B981),
      icon: Icons.fastfood_rounded,
    ),
    _Campaign(
      title: 'Medical Aid — Spring',
      description: 'Mobile medical camps providing free healthcare to rural communities.',
      progress: 0.0,
      status: CampaignStatus.draft,
      color: Color(0xFF8B5CF6),
      icon: Icons.medical_services_rounded,
    ),
    _Campaign(
      title: 'Monsoon Shelter Project',
      description: 'Temporary shelters for families displaced by the 2024 monsoon floods.',
      progress: 1.0,
      status: CampaignStatus.closed,
      color: Color(0xFF64748B),
      icon: Icons.home_rounded,
    ),
  ];

  static const List<_InventoryItem> _inventory = [
    _InventoryItem(name: 'Blankets', quantity: 45, threshold: 50, unit: 'pieces', icon: Icons.airline_seat_individual_suite_rounded),
    _InventoryItem(name: 'Food Packs', quantity: 120, threshold: 100, unit: 'packs', icon: Icons.inventory_2_rounded),
    _InventoryItem(name: 'Medicines', quantity: 18, threshold: 30, unit: 'kits', icon: Icons.medical_services_outlined),
    _InventoryItem(name: 'Water Bottles', quantity: 200, threshold: 150, unit: 'bottles', icon: Icons.water_drop_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats row
                    const _StatsRow(),
                    const SizedBox(height: 24),
                    // Quick actions
                    const _QuickActions(),
                    const SizedBox(height: 24),
                    // Campaigns section
                    const _SectionHeader(title: 'My Campaigns', subtitle: 'Active and draft campaigns'),
                    const SizedBox(height: 12),
                    ..._campaigns.map((c) => _CampaignCard(campaign: c)),
                    const SizedBox(height: 24),
                    // Inventory section
                    const _SectionHeader(title: 'Inventory Management', subtitle: 'Track your aid stock levels'),
                    const SizedBox(height: 12),
                    const _InventorySection(),
                    const SizedBox(height: 24),
                    // Mini report preview
                    const _ReportPreview(),
                    const SizedBox(height: 16),
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
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white,
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NGO Dashboard',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              Text(
                'Manage campaigns and resources',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const Spacer(),
          // Profile icon placeholder
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E40AF).withOpacity(0.2)),
            ),
            child: const Icon(Icons.domain_rounded, color: Color(0xFF1E40AF), size: 22),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATS ROW
// ─────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: const [
        _StatCard(label: 'Total Campaigns', value: '12', icon: Icons.campaign_rounded, color: Color(0xFF3B82F6)),
        _StatCard(label: 'Active Campaigns', value: '4', icon: Icons.play_circle_rounded, color: Color(0xFF10B981)),
        _StatCard(label: 'Donations Received', value: 'PKR 2.4M', icon: Icons.attach_money_rounded, color: Color(0xFFF59E0B)),
        _StatCard(label: 'Inventory Items', value: '383', icon: Icons.inventory_rounded, color: Color(0xFF8B5CF6)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  maxLines: 2,
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
// QUICK ACTIONS
// ─────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Quick Actions', subtitle: 'Common management tasks'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Create Campaign',
                icon: Icons.add_circle_rounded,
                color: const Color(0xFF1E40AF),
                onTap: () {
                  // TODO: Open create campaign UI (not implemented yet)
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                label: 'Add Inventory',
                icon: Icons.add_box_rounded,
                color: const Color(0xFF10B981),
                onTap: () {
                  // TODO: Open add inventory UI (not implemented yet)
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                label: 'View Reports',
                icon: Icons.bar_chart_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  // TODO: Open reports UI (not implemented yet)
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CAMPAIGN CARD
// ─────────────────────────────────────────────
class _CampaignCard extends StatelessWidget {
  final _Campaign campaign;
  const _CampaignCard({required this.campaign});

  Color get _statusColor {
    switch (campaign.status) {
      case CampaignStatus.active: return const Color(0xFF10B981);
      case CampaignStatus.draft:  return const Color(0xFFF59E0B);
      case CampaignStatus.closed: return const Color(0xFF94A3B8);
    }
  }

  String get _statusLabel {
    switch (campaign.status) {
      case CampaignStatus.active: return 'ACTIVE';
      case CampaignStatus.draft:  return 'DRAFT';
      case CampaignStatus.closed: return 'CLOSED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Image placeholder header
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [campaign.color.withOpacity(0.7), campaign.color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(campaign.icon, color: Colors.white, size: 32),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Text(
                      _statusLabel,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                Text(
                  campaign.description,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5),
                ),
                const SizedBox(height: 12),
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: campaign.progress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(campaign.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(campaign.progress * 100).toInt()}%',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: campaign.color),
                    ),
                  ],
                ),
                if (campaign.status != CampaignStatus.closed) ...[
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Open edit UI (not implemented yet)
                          },
                          icon: const Icon(Icons.edit_outlined, size: 15),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E40AF),
                            side: const BorderSide(color: Color(0xFFBFDBFE)),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: View campaign details (not implemented yet)
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 15),
                          label: const Text('Details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Close campaign (not implemented yet)
                          },
                          icon: const Icon(Icons.close_rounded, size: 15),
                          label: const Text('Close'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFFECACA)),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INVENTORY SECTION
// ─────────────────────────────────────────────
class _InventorySection extends StatelessWidget {
  const _InventorySection();

  static const List<_InventoryItem> _items = [
    _InventoryItem(name: 'Blankets', quantity: 45, threshold: 50, unit: 'pieces', icon: Icons.airline_seat_individual_suite_rounded),
    _InventoryItem(name: 'Food Packs', quantity: 120, threshold: 100, unit: 'packs', icon: Icons.inventory_2_rounded),
    _InventoryItem(name: 'Medicines', quantity: 18, threshold: 30, unit: 'kits', icon: Icons.medical_services_outlined),
    _InventoryItem(name: 'Water Bottles', quantity: 200, threshold: 150, unit: 'bottles', icon: Icons.water_drop_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: _items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _InventoryRow(item: item),
              if (i < _items.length - 1)
                const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  final _InventoryItem item;
  const _InventoryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.isLowStock
                  ? const Color(0xFFEF4444).withOpacity(0.08)
                  : const Color(0xFF10B981).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 20,
              color: item.isLowStock ? const Color(0xFFEF4444) : const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text('${item.quantity} ${item.unit}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          // Low stock badge
          if (item.isLowStock)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Low Stock',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'In Stock',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MINI REPORT PREVIEW
// ─────────────────────────────────────────────
class _ReportPreview extends StatelessWidget {
  const _ReportPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Reports Preview', subtitle: 'Quick analytics snapshot'),
        const SizedBox(height: 12),
        Row(
          children: [
            // Donations trend placeholder
            Expanded(
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Donations Trend', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    const Text('↑ 23% this month', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                    const Spacer(),
                    // Mock bar chart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [0.4, 0.6, 0.5, 0.8, 0.7, 0.9].map((h) {
                        return Container(
                          width: 14,
                          height: 40 * h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Campaign success rate placeholder
            Expanded(
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Campaign Success', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    const Text('75% completion rate', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                    const Spacer(),
                    // Mock donut placeholder
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 52,
                            height: 52,
                            child: CircularProgressIndicator(
                              value: 0.75,
                              strokeWidth: 7,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                            ),
                          ),
                          const Text('75%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SHARED
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
