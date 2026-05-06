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
      case 'CLOSED':
        return Colors.red;
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

  String _formatDate(DateTime? date) {
    if (date == null) return "Not set";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // ================= DELETE DIALOG =================
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
            content: Text(success ? "Campaign deleted" : "Failed to delete"),
          ),
        );
      }
    }
  }

  // ================= STATUS CHANGE DIALOG =================
  Future<void> _confirmStatusChange(
    BuildContext context,
    WidgetRef ref,
    String newStatus,
  ) async {
    final action = newStatus == 'ACTIVE' ? 'Activate' : 'Close';
    final color = newStatus == 'ACTIVE' ? Colors.green : Colors.red;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$action Campaign"),
        content: Text("Are you sure you want to $action '${campaign.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: color),
            child: Text(action),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = false;
      if (newStatus == 'ACTIVE') {
        success = await ref
            .read(campaignProvider.notifier)
            .activateCampaign(campaign.id);
      } else if (newStatus == 'CLOSED') {
        success = await ref
            .read(campaignProvider.notifier)
            .closeCampaign(campaign.id);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? "Campaign ${newStatus.toLowerCase()} successfully"
                  : "Failed to update status",
            ),
          ),
        );
      }
    }
  }

  // ================= STATUS BUTTON =================
  Widget _statusButton(BuildContext context, WidgetRef ref) {
    final status = campaign.status.toUpperCase();

    if (status == 'DRAFT') {
      return TextButton.icon(
        onPressed: () => _confirmStatusChange(context, ref, 'ACTIVE'),
        icon: const Icon(Icons.play_arrow, size: 16, color: Colors.green),
        label: const Text(
          "Activate",
          style: TextStyle(color: Colors.green, fontSize: 12),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    if (status == 'ACTIVE') {
      return TextButton.icon(
        onPressed: () => _confirmStatusChange(context, ref, 'CLOSED'),
        icon: const Icon(Icons.stop_circle, size: 16, color: Colors.red),
        label: const Text(
          "Close",
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Closed",
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  // ================= IMAGE WIDGET ✅ NEW =================
  Widget _buildImage() {
    final hasImage = campaign.imageUrl != null && campaign.imageUrl!.isNotEmpty;

    if (!hasImage) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.network(
        campaign.imageUrl!,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 160,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, _) => Container(
          height: 160,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            // ✅ IMAGE ON TOP
            _buildImage(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + EDIT + DELETE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          campaign.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditCampaignScreen(campaign: campaign),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () => _confirmDelete(context, ref),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // DESCRIPTION
                  Text(
                    campaign.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  // DATES ROW
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Start: ${_formatDate(campaign.startDate)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.event, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        "End: ${_formatDate(campaign.endDate)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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

                  const SizedBox(height: 8),

                  // PROGRESS BAR
                  LinearProgressIndicator(
                    value: campaign.progress.clamp(0.0, 1.0),
                    minHeight: 6,
                  ),

                  const SizedBox(height: 12),

                  // STATUS + DONORS + TYPE + STATUS BUTTON
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
                      _statusButton(context, ref),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
