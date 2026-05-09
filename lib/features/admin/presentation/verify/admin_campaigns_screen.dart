import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reliefnet/features/admin/state/admin_provider.dart';

// ── Model ──
class _CampaignItem {
  final int id;
  final String title;
  final String status;
  final double goalAmount;
  final double totalAmount;
  final String? donationType;
  final String? ngoName;

  _CampaignItem({
    required this.id,
    required this.title,
    required this.status,
    required this.goalAmount,
    required this.totalAmount,
    this.donationType,
    this.ngoName,
  });

  factory _CampaignItem.fromJson(Map<String, dynamic> json) {
    return _CampaignItem(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? 'Untitled',
      status: json['status'] ?? 'DRAFT',
      goalAmount: double.tryParse(json['goal_amount']?.toString() ?? '0') ?? 0,
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      donationType: json['donation_type'],
      ngoName: json['ngo_name'],
    );
  }

  double get progress =>
      goalAmount > 0 ? (totalAmount / goalAmount).clamp(0.0, 1.0) : 0;
}

// ── Provider ──
final _adminCampaignsProvider = FutureProvider.autoDispose<List<_CampaignItem>>(
  (ref) async {
    final baseUrl = kIsWeb
        ? 'http://localhost:3000/api'
        : 'http://10.109.20.26:3000/api';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final res = await http.get(
      Uri.parse('$baseUrl/campaigns'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List list = body['data'] ?? body ?? [];
      return list.map((e) => _CampaignItem.fromJson(e)).toList();
    }
    throw Exception('Failed to load campaigns: ${res.statusCode}');
  },
);

// ── Screen ──
class AdminCampaignsScreen extends ConsumerStatefulWidget {
  const AdminCampaignsScreen({super.key});

  @override
  ConsumerState<AdminCampaignsScreen> createState() =>
      _AdminCampaignsScreenState();
}

class _AdminCampaignsScreenState extends ConsumerState<AdminCampaignsScreen> {
  String _filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final campaignsAsync = ref.watch(_adminCampaignsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('All Campaigns'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(_adminCampaignsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter tabs ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ALL', 'ACTIVE', 'DRAFT', 'CLOSED'].map((f) {
                  final selected = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1E40AF)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── List ──
          Expanded(
            child: campaignsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(e.toString(), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(_adminCampaignsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (campaigns) {
                final filtered = _filter == 'ALL'
                    ? campaigns
                    : campaigns
                          .where((c) => c.status.toUpperCase() == _filter)
                          .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${_filter == 'ALL' ? '' : _filter} campaigns',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(_adminCampaignsProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => _CampaignCard(
                      campaign: filtered[i],
                      onActionDone: () =>
                          ref.invalidate(_adminCampaignsProvider),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Campaign Card with Actions ──
class _CampaignCard extends ConsumerWidget {
  final _CampaignItem campaign;
  final VoidCallback onActionDone;

  const _CampaignCard({required this.campaign, required this.onActionDone});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFF10B981);
      case 'DRAFT':
        return const Color(0xFFF59E0B);
      case 'CLOSED':
        return const Color(0xFF94A3B8);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  Future<void> _showActions(BuildContext context, WidgetRef ref) async {
    final status = campaign.status.toUpperCase();

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Text(
                  campaign.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(height: 1),

              // Activate — only for DRAFT
              if (status == 'DRAFT')
                ListTile(
                  leading: const Icon(
                    Icons.play_circle_outline,
                    color: Color(0xFF10B981),
                  ),
                  title: const Text('Activate Campaign'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _confirm(
                      context,
                      title: 'Activate Campaign',
                      message: 'Make this campaign live and visible to donors?',
                      confirmLabel: 'Activate',
                      confirmColor: const Color(0xFF10B981),
                      onConfirm: () async {
                        final ok = await ref
                            .read(adminProvider.notifier)
                            .activateCampaign(campaign.id);
                        _showResult(
                          context,
                          ok,
                          'Campaign activated',
                          'Failed to activate',
                        );
                        if (ok) onActionDone();
                      },
                    );
                  },
                ),

              // Close — only for ACTIVE
              if (status == 'ACTIVE')
                ListTile(
                  leading: const Icon(
                    Icons.stop_circle_outlined,
                    color: Color(0xFFF59E0B),
                  ),
                  title: const Text('Close Campaign'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _confirm(
                      context,
                      title: 'Close Campaign',
                      message:
                          'This will stop accepting donations. This cannot be undone.',
                      confirmLabel: 'Close',
                      confirmColor: const Color(0xFFF59E0B),
                      onConfirm: () async {
                        final ok = await ref
                            .read(adminProvider.notifier)
                            .closeCampaign(campaign.id);
                        _showResult(
                          context,
                          ok,
                          'Campaign closed',
                          'Failed to close',
                        );
                        if (ok) onActionDone();
                      },
                    );
                  },
                ),

              // Delete — only for DRAFT or CLOSED
              if (status == 'DRAFT' || status == 'CLOSED')
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444),
                  ),
                  title: const Text(
                    'Delete Campaign',
                    style: TextStyle(color: Color(0xFFEF4444)),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _confirm(
                      context,
                      title: 'Delete Campaign',
                      message:
                          'This will permanently delete the campaign. Are you sure?',
                      confirmLabel: 'Delete',
                      confirmColor: const Color(0xFFEF4444),
                      onConfirm: () async {
                        final ok = await ref
                            .read(adminProvider.notifier)
                            .deleteCampaign(campaign.id);
                        _showResult(
                          context,
                          ok,
                          'Campaign deleted',
                          'Failed to delete',
                        );
                        if (ok) onActionDone();
                      },
                    );
                  },
                ),

              // If ACTIVE: no delete allowed
              if (status == 'ACTIVE')
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Active campaigns cannot be deleted. Close it first.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ),

              ListTile(
                leading: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required Future<void> Function() onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (confirmed == true) await onConfirm();
  }

  void _showResult(BuildContext context, bool ok, String success, String fail) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? success : fail),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(campaign.status);

    return GestureDetector(
      onTap: () => _showActions(context, ref),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title + status ──
            Row(
              children: [
                Expanded(
                  child: Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    campaign.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),

            // ── NGO name if available ──
            if (campaign.ngoName != null) ...[
              const SizedBox(height: 4),
              Text(
                campaign.ngoName!,
                style: const TextStyle(fontSize: 11, color: Color(0xFF3B82F6)),
              ),
            ],

            const SizedBox(height: 10),

            // ── Type + goal ──
            Row(
              children: [
                if (campaign.donationType != null) ...[
                  const Icon(
                    Icons.category_outlined,
                    size: 13,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    campaign.donationType!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                const Icon(
                  Icons.attach_money,
                  size: 13,
                  color: Color(0xFF94A3B8),
                ),
                Text(
                  'PKR ${campaign.goalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Progress ──
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: campaign.progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Raised: PKR ${campaign.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  '${(campaign.progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),

            // ── Tap hint ──
            const SizedBox(height: 8),
            const Text(
              'Tap to manage',
              style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}
