import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/campaign_model.dart';
import '../../state/campaign_provider.dart';
import '../edit_campaign_screen.dart';

class CampaignCard extends ConsumerWidget {
  final CampaignModel campaign;
  final VoidCallback? onTap;

  const CampaignCard({super.key, required this.campaign, this.onTap});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'DRAFT':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _safeType(String? type) {
    if (type == null || type.isEmpty) return "Unknown";
    return type;
  }

  // ✅ DELETE CONFIRMATION DIALOG
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Campaign"),
        content: Text("Are you sure you want to delete '${campaign.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(campaignProvider.notifier)
          .deleteCampaign(campaign.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? "Campaign deleted" : "Failed to delete campaign",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE + ACTIONS ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TITLE
                Expanded(
                  child: Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ✅ EDIT BUTTON
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCampaignScreen(campaign: campaign),
                      ),
                    );
                  },
                ),

                // ✅ DELETE BUTTON
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // DESCRIPTION
            Text(
              campaign.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // MONEY ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Raised: ${campaign.totalAmount.toInt()}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Goal: ${campaign.goalAmount.toInt()}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // PROGRESS BAR
            LinearProgressIndicator(
              value: campaign.progress.clamp(0.0, 1.0),
              minHeight: 6,
            ),

            const SizedBox(height: 12),

            // STATUS + DONORS + TYPE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(
                      campaign.status,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    campaign.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(campaign.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text("${campaign.donorCount} donors"),
                Text(_safeType(campaign.donationType)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
