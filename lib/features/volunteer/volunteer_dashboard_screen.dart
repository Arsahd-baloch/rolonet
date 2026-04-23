import 'package:flutter/material.dart';

// ─── Mock Data Model ────────────────────────
enum TaskStatus { pending, inProgress, completed, rejected }

enum TaskPriority { low, medium, high }

class _Task {
  final String id;
  final String title;
  final String description;
  final String location;
  final TaskPriority priority;
  TaskStatus status;

  _Task({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.priority,
    this.status = TaskStatus.pending,
  });
}

// ─────────────────────────────────────────────
// VOLUNTEER DASHBOARD SCREEN
// ─────────────────────────────────────────────
class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  State<VolunteerDashboardScreen> createState() =>
      _VolunteerDashboardScreenState();
}

class _VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> {
  // Disaster mode flag
  bool isDisasterMode = true;

  // Availability toggle
  bool isAvailable = true;

  // Mock task list
  final List<_Task> _tasks = [
    _Task(
      id: '1',
      title: 'Food Package Delivery',
      description:
          'Deliver 50 food packages to displaced families at the relief camp.',
      location: 'Karachi Relief Camp, Sindh',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
    ),
    _Task(
      id: '2',
      title: 'Blanket Distribution',
      description:
          'Distribute blankets and warm clothing to flood victims in Zone 3.',
      location: 'Sukkur Flood Zone, Sindh',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
    ),
    _Task(
      id: '3',
      title: 'Medical Camp Assistance',
      description:
          'Assist the medical team in registering patients and managing crowd.',
      location: 'Quetta Medical Camp, Balochistan',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
    ),
    _Task(
      id: '4',
      title: 'Shelter Setup Support',
      description: 'Help set up temporary shelters for 30 affected families.',
      location: 'Nowshera, KPK',
      priority: TaskPriority.low,
      status: TaskStatus.pending,
    ),
  ];

  // Stats computed from task list
  int get assignedCount => _tasks.length;
  int get completedCount =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get pendingCount =>
      _tasks.where((t) => t.status == TaskStatus.pending).length;

  void _acceptTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.status = TaskStatus.inProgress;
      // TODO: Mark task as accepted (UI state only)
    });
  }

  void _rejectTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.status = TaskStatus.rejected;
      // TODO: Mark task as rejected (UI state only)
    });
  }

  void _completeTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.status = TaskStatus.completed;
      // TODO: Mark task as completed (UI state only)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _Header(
              isAvailable: isAvailable,
              onToggle: (val) => setState(() => isAvailable = val),
            ),
            // Disaster banner
            if (isDisasterMode) const _DisasterBanner(),
            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick stats
                    _StatsRow(
                      assigned: assignedCount,
                      completed: completedCount,
                      pending: pendingCount,
                    ),
                    const SizedBox(height: 24),
                    // Tasks
                    const _SectionHeader(
                      title: 'Assigned Tasks',
                      subtitle: 'Your current mission list',
                    ),
                    const SizedBox(height: 12),
                    ..._tasks.map(
                      (task) => _TaskCard(
                        task: task,
                        onAccept: () => _acceptTask(task.id),
                        onReject: () => _rejectTask(task.id),
                        onComplete: () => _completeTask(task.id),
                      ),
                    ),
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
// DISASTER BANNER
// ─────────────────────────────────────────────
class _DisasterBanner extends StatelessWidget {
  const _DisasterBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB91C1C), Color(0xFFEF4444)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚨 Disaster Mode Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'High priority tasks available',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  final bool isAvailable;
  final ValueChanged<bool> onToggle;

  const _Header({required this.isAvailable, required this.onToggle});

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
                'Volunteer Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'Manage your missions',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const Spacer(),
          // Availability toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isAvailable ? 'Available' : 'Busy',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isAvailable
                      ? const Color(0xFF10B981)
                      : const Color(0xFF94A3B8),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isAvailable,
                  onChanged: onToggle,
                  activeColor: const Color(0xFF10B981),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// QUICK STATS
// ─────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int assigned;
  final int completed;
  final int pending;

  const _StatsRow({
    required this.assigned,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Assigned',
            value: '$assigned',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Completed',
            value: '$completed',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Pending',
            value: '$pending',
            icon: Icons.hourglass_empty_rounded,
            color: const Color(0xFFF59E0B),
          ),
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TASK CARD
// ─────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final _Task task;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onComplete;

  const _TaskCard({
    required this.task,
    required this.onAccept,
    required this.onReject,
    required this.onComplete,
  });

  Color get _statusColor {
    switch (task.status) {
      case TaskStatus.pending:
        return const Color(0xFF94A3B8);
      case TaskStatus.inProgress:
        return const Color(0xFF3B82F6);
      case TaskStatus.completed:
        return const Color(0xFF10B981);
      case TaskStatus.rejected:
        return const Color(0xFFEF4444);
    }
  }

  String get _statusLabel {
    switch (task.status) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
      case TaskStatus.rejected:
        return 'REJECTED';
    }
  }

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.low:
        return const Color(0xFF10B981);
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.high:
        return const Color(0xFFEF4444);
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRejectedOrCompleted =
        task.status == TaskStatus.rejected ||
        task.status == TaskStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRejectedOrCompleted
              ? _statusColor.withOpacity(0.3)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top strip for high priority
          if (task.priority == TaskPriority.high)
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _statusColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Location + Priority row
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Priority badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _priorityColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _priorityLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),

                // Action buttons — hide if done/rejected
                if (!isRejectedOrCompleted) ...[
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Accept / Mark Complete
                      if (task.status == TaskStatus.pending)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onAccept,
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Accept'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      if (task.status == TaskStatus.inProgress)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onComplete,
                            icon: const Icon(Icons.done_all_rounded, size: 16),
                            label: const Text('Mark Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      // Reject
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: const Text('Reject'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFEF4444)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Completion/Rejection message
                if (task.status == TaskStatus.completed) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Task completed successfully',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.status == TaskStatus.rejected) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.cancel_rounded,
                        color: Color(0xFFEF4444),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Task rejected',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
