import 'package:flutter/material.dart';

// ─── Mock Data ───────────────────────────────
enum UserStatus { active, suspended }

enum NgoVerification { verified, pending, rejected }

class _User {
  final String name;
  final String role;
  final UserStatus status;
  const _User({required this.name, required this.role, required this.status});
}

class _Ngo {
  final String name;
  final NgoVerification verification;
  const _Ngo({required this.name, required this.verification});
}

class _LogEntry {
  final String event;
  final String time;
  final IconData icon;
  final Color color;
  const _LogEntry({
    required this.event,
    required this.time,
    required this.icon,
    required this.color,
  });
}

// ─────────────────────────────────────────────
// ADMIN DASHBOARD SCREEN
// ─────────────────────────────────────────────
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool isDisasterMode = false;
  int _selectedMenu = 0;

  static const _menuItems = [
    {'label': 'Dashboard', 'icon': Icons.dashboard_rounded},
    {'label': 'Users', 'icon': Icons.people_rounded},
    {'label': 'NGOs', 'icon': Icons.business_center_rounded},
    {'label': 'Campaigns', 'icon': Icons.campaign_rounded},
    {'label': 'Donations', 'icon': Icons.volunteer_activism_rounded},
    {'label': 'Disaster Mode', 'icon': Icons.emergency_rounded},
    {'label': 'Reports', 'icon': Icons.bar_chart_rounded},
    {'label': 'System Logs', 'icon': Icons.receipt_long_rounded},
  ];

  static const List<_User> _users = [
    _User(name: 'Ahmed Khan', role: 'NGO', status: UserStatus.active),
    _User(name: 'Sara Ali', role: 'Donor', status: UserStatus.active),
    _User(name: 'Bilal Raza', role: 'Volunteer', status: UserStatus.suspended),
    _User(name: 'Fatima Malik', role: 'Beneficiary', status: UserStatus.active),
    _User(name: 'Omar Sheikh', role: 'Donor', status: UserStatus.active),
  ];

  static const List<_Ngo> _ngos = [
    _Ngo(name: 'Al-Khidmat Foundation', verification: NgoVerification.verified),
    _Ngo(name: 'Edhi Foundation', verification: NgoVerification.verified),
    _Ngo(name: 'Green Aid Network', verification: NgoVerification.pending),
    _Ngo(name: 'Hope Relief Org', verification: NgoVerification.rejected),
  ];

  static const List<_LogEntry> _logs = [
    _LogEntry(
      event: 'User "Sara Ali" logged in',
      time: '2 min ago',
      icon: Icons.login_rounded,
      color: Color(0xFF3B82F6),
    ),
    _LogEntry(
      event: 'Campaign "Winter Relief" created',
      time: '15 min ago',
      icon: Icons.add_circle_rounded,
      color: Color(0xFF10B981),
    ),
    _LogEntry(
      event: 'Donation of PKR 5,000 received',
      time: '32 min ago',
      icon: Icons.attach_money_rounded,
      color: Color(0xFFF59E0B),
    ),
    _LogEntry(
      event: 'NGO "Green Aid" submitted for review',
      time: '1 hr ago',
      icon: Icons.business_center_rounded,
      color: Color(0xFF8B5CF6),
    ),
    _LogEntry(
      event: 'Volunteer task accepted by Bilal',
      time: '2 hr ago',
      icon: Icons.assignment_turned_in_rounded,
      color: Color(0xFF10B981),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      drawer: _Drawer(
        selectedIndex: _selectedMenu,
        onSelect: (i) {
          setState(() => _selectedMenu = i);
          Navigator.of(context).pop();
          // TODO: Navigate to section
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(isDisasterMode: isDisasterMode),
            if (isDisasterMode) const _DisasterActiveBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPI Stats
                    const _SectionLabel(text: 'System Overview'),
                    const SizedBox(height: 10),
                    const _KpiRow(),
                    const SizedBox(height: 24),
                    // Disaster Control
                    _DisasterControlPanel(
                      isActive: isDisasterMode,
                      onToggle: () =>
                          setState(() => isDisasterMode = !isDisasterMode),
                    ),
                    const SizedBox(height: 24),
                    // Users
                    const _SectionLabel(text: 'Users Overview'),
                    const SizedBox(height: 10),
                    _UsersTable(users: _users),
                    const SizedBox(height: 24),
                    // NGOs
                    const _SectionLabel(text: 'NGO Overview'),
                    const SizedBox(height: 10),
                    _NgoList(ngos: _ngos),
                    const SizedBox(height: 24),
                    // Donations
                    const _SectionLabel(text: 'Donation Overview'),
                    const SizedBox(height: 10),
                    const _DonationOverview(),
                    const SizedBox(height: 24),
                    // Logs
                    const _SectionLabel(text: 'Recent System Activity'),
                    const SizedBox(height: 10),
                    _LogsList(logs: _logs),
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
// DRAWER / SIDEBAR
// ─────────────────────────────────────────────
class _Drawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _Drawer({required this.selectedIndex, required this.onSelect});

  static const _items = [
    {'label': 'Dashboard', 'icon': Icons.dashboard_rounded},
    {'label': 'Users', 'icon': Icons.people_rounded},
    {'label': 'NGOs', 'icon': Icons.business_center_rounded},
    {'label': 'Campaigns', 'icon': Icons.campaign_rounded},
    {'label': 'Donations', 'icon': Icons.volunteer_activism_rounded},
    {'label': 'Disaster Mode', 'icon': Icons.emergency_rounded},
    {'label': 'Reports', 'icon': Icons.bar_chart_rounded},
    {'label': 'System Logs', 'icon': Icons.receipt_long_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E293B),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ReliefNet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 1),
            const SizedBox(height: 8),
            // Menu items
            ...(_items as List<Map<String, dynamic>>).asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final bool selected = selectedIndex == i;
              return InkWell(
                onTap: () => onSelect(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1E40AF).withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isDisasterMode;
  const _TopBar({required this.isDisasterMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B)),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'Central control system',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Color(0xFF1E40AF),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DISASTER ACTIVE BANNER
// ─────────────────────────────────────────────
class _DisasterActiveBanner extends StatelessWidget {
  const _DisasterActiveBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: const Color(0xFFEF4444),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            '🚨 Disaster Mode ACTIVE — All units on high alert',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KPI STATS ROW
// ─────────────────────────────────────────────
class _KpiRow extends StatelessWidget {
  const _KpiRow();

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
        _KpiCard(
          label: 'Total Users',
          value: '2,840',
          icon: Icons.people_rounded,
          color: Color(0xFF3B82F6),
        ),
        _KpiCard(
          label: 'Total NGOs',
          value: '85',
          icon: Icons.domain_rounded,
          color: Color(0xFF8B5CF6),
        ),
        _KpiCard(
          label: 'Total Donations',
          value: 'PKR 8.2M',
          icon: Icons.attach_money_rounded,
          color: Color(0xFF10B981),
        ),
        _KpiCard(
          label: 'Active Campaigns',
          value: '34',
          icon: Icons.campaign_rounded,
          color: Color(0xFFF59E0B),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard({
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
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
// DISASTER CONTROL PANEL
// ─────────────────────────────────────────────
class _DisasterControlPanel extends StatelessWidget {
  final bool isActive;
  final VoidCallback onToggle;
  const _DisasterControlPanel({required this.isActive, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFFB91C1C), const Color(0xFFEF4444)]
              : [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emergency_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'Disaster Control Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isActive
                ? '🚨 Disaster Mode is currently ACTIVE. All volunteers and NGOs are on alert.'
                : 'System is in normal operation. Activate only during emergency events.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                onToggle();
                // TODO: Toggle disaster mode state (UI only)
              },
              icon: Icon(
                isActive
                    ? Icons.power_settings_new_rounded
                    : Icons.warning_amber_rounded,
                size: 18,
              ),
              label: Text(
                isActive
                    ? 'Deactivate Disaster Mode'
                    : 'Activate Disaster Mode',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isActive
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF1E40AF),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// USERS TABLE
// ─────────────────────────────────────────────
class _UsersTable extends StatelessWidget {
  final List<_User> users;
  const _UsersTable({required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: users.asMap().entries.map((e) {
          final user = e.value;
          final bool last = e.key == users.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
                      child: Text(
                        user.name[0],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            user.role,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: user.status == UserStatus.active
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.status == UserStatus.active
                            ? 'Active'
                            : 'Suspended',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: user.status == UserStatus.active
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!last)
                const Divider(
                  color: Color(0xFFF1F5F9),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NGO LIST
// ─────────────────────────────────────────────
class _NgoList extends StatelessWidget {
  final List<_Ngo> ngos;
  const _NgoList({required this.ngos});

  Color _color(NgoVerification v) {
    switch (v) {
      case NgoVerification.verified:
        return const Color(0xFF10B981);
      case NgoVerification.pending:
        return const Color(0xFFF59E0B);
      case NgoVerification.rejected:
        return const Color(0xFFEF4444);
    }
  }

  String _label(NgoVerification v) {
    switch (v) {
      case NgoVerification.verified:
        return 'VERIFIED';
      case NgoVerification.pending:
        return 'PENDING';
      case NgoVerification.rejected:
        return 'REJECTED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: ngos.asMap().entries.map((e) {
          final ngo = e.value;
          final bool last = e.key == ngos.length - 1;
          final Color c = _color(ngo.verification);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.domain_rounded,
                        color: Color(0xFF8B5CF6),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ngo.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: c.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: c.withOpacity(0.3)),
                      ),
                      child: Text(
                        _label(ngo.verification),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: c,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!last)
                const Divider(
                  color: Color(0xFFF1F5F9),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DONATION OVERVIEW
// ─────────────────────────────────────────────
class _DonationOverview extends StatelessWidget {
  const _DonationOverview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _DonationRow(
            label: 'Total Donations Received',
            value: 'PKR 8,240,000',
            color: const Color(0xFF10B981),
            progress: 1.0,
          ),
          const SizedBox(height: 12),
          _DonationRow(
            label: 'Completed Donations',
            value: 'PKR 6,100,000',
            color: const Color(0xFF3B82F6),
            progress: 0.74,
          ),
          const SizedBox(height: 12),
          _DonationRow(
            label: 'Pending Donations',
            value: 'PKR 2,140,000',
            color: const Color(0xFFF59E0B),
            progress: 0.26,
          ),
        ],
      ),
    );
  }
}

class _DonationRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double progress;
  const _DonationRow({
    required this.label,
    required this.value,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SYSTEM LOGS
// ─────────────────────────────────────────────
class _LogsList extends StatelessWidget {
  final List<_LogEntry> logs;
  const _LogsList({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: logs.asMap().entries.map((e) {
          final log = e.value;
          final bool last = e.key == logs.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: log.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(log.icon, color: log.color, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        log.event,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      log.time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              if (!last)
                const Divider(
                  color: Color(0xFFF1F5F9),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E293B),
      ),
    );
  }
}
