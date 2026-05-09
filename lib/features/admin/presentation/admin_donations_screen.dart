import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/admin/state/admin_provider.dart';
import 'package:reliefnet/features/admin/domain/admin_stats_model.dart';

class AdminDonationsScreen extends ConsumerStatefulWidget {
  const AdminDonationsScreen({super.key});

  @override
  ConsumerState<AdminDonationsScreen> createState() =>
      _AdminDonationsScreenState();
}

class _AdminDonationsScreenState extends ConsumerState<AdminDonationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Pending Donations'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(adminProvider.notifier).loadAll(),
          ),
        ],
      ),
      body: adminState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminState.error != null
          ? Center(child: Text('Error: ${adminState.error}'))
          : adminState.pendingDonations.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No pending donations',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => ref.read(adminProvider.notifier).loadAll(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: adminState.pendingDonations.length,
                itemBuilder: (context, index) {
                  final donation = adminState.pendingDonations[index];
                  return _PendingDonationCard(donation: donation);
                },
              ),
            ),
    );
  }
}

// class _PendingDonationCard extends ConsumerWidget {
//   final PendingDonationModel donation;
//   const _PendingDonationCard({required this.donation});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Donation #${donation.id}',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   'PENDING',
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFF59E0B),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               const Icon(Icons.campaign_outlined, size: 16, color: Colors.grey),
//               const SizedBox(width: 6),
//               Text(
//                 'Campaign ID: ${donation.campaignId}',
//                 style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
//               ),
//             ],
//           ),
//           if (donation.amount != null) ...[
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 const Icon(Icons.attach_money, size: 16, color: Colors.green),
//                 const SizedBox(width: 6),
//                 Text(
//                   'PKR ${donation.amount!.toStringAsFixed(0)}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF10B981),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               // Cancel
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () async {
//                     final confirm = await showDialog<bool>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text('Cancel Donation'),
//                         content: const Text(
//                           'Are you sure you want to cancel this donation?',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text('No'),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.red,
//                             ),
//                             child: const Text('Cancel'),
//                           ),
//                         ],
//                       ),
//                     );
//                     if (confirm == true && context.mounted) {
//                       final success = await ref
//                           .read(adminProvider.notifier)
//                           .cancelDonation(donation.id);
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               success
//                                   ? 'Donation cancelled'
//                                   : 'Failed to cancel',
//                             ),
//                             backgroundColor: success
//                                 ? Colors.orange
//                                 : Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   icon: const Icon(Icons.close, size: 16),
//                   label: const Text('Cancel'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.red,
//                     side: const BorderSide(color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Verify
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () async {
//                     final confirm = await showDialog<bool>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text('Verify Donation'),
//                         content: const Text(
//                           'Confirm that payment has been received?',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text('No'),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.green,
//                             ),
//                             child: const Text('Verify'),
//                           ),
//                         ],
//                       ),
//                     );
//                     if (confirm == true && context.mounted) {
//                       final success = await ref
//                           .read(adminProvider.notifier)
//                           .verifyDonation(donation.id);
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               success
//                                   ? 'Donation verified ✓'
//                                   : 'Failed to verify',
//                             ),
//                             backgroundColor: success
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   icon: const Icon(Icons.check, size: 16),
//                   label: const Text('Verify'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class _PendingDonationCard extends ConsumerWidget {
  final PendingDonationModel donation;
  const _PendingDonationCard({required this.donation});

  bool get _isItems =>
      donation.donationType == 'ITEMS' || donation.donationType == 'BOTH';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Donation #${donation.id}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Row(
                  children: [
                    if (donation.donationType != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isItems
                              ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
                              : const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          donation.donationType!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _isItems
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'PENDING',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Basic info ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.campaign_outlined,
                  text: 'Campaign ID: ${donation.campaignId}',
                ),
                if (donation.amount != null)
                  _InfoRow(
                    icon: Icons.attach_money,
                    text: 'PKR ${donation.amount!.toStringAsFixed(0)}',
                    color: const Color(0xFF10B981),
                    bold: true,
                  ),
                if (donation.quantity != null)
                  _InfoRow(
                    icon: Icons.inventory_2_outlined,
                    text: 'Quantity: ${donation.quantity}',
                  ),
              ],
            ),
          ),

          // ── Item-donation details ──
          if (_isItems) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Divider(height: 1, color: Color(0xFFE2E8F0)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item Donation Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Proof image
                  if (donation.proofImage != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Proof photo',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            donation.proofImage!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 160,
                              color: const Color(0xFFF1F5F9),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                  // Pickup location
                  if (donation.pickupLocation != null)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: donation.pickupLocation!,
                    ),

                  // Available datetime
                  if (donation.availableDatetime != null)
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      text:
                          'Available: ${_formatDatetime(donation.availableDatetime!)}',
                    ),
                ],
              ),
            ),
          ],

          // ── Actions ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Cancel Donation'),
                          content: const Text(
                            'Are you sure you want to cancel this donation?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        final success = await ref
                            .read(adminProvider.notifier)
                            .cancelDonation(donation.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Donation cancelled'
                                    : 'Failed to cancel',
                              ),
                              backgroundColor: success
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Verify Donation'),
                          content: Text(
                            _isItems
                                ? 'Confirm that items have been received and verified?'
                                : 'Confirm that payment has been received?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                              ),
                              child: const Text('Verify'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        final success = await ref
                            .read(adminProvider.notifier)
                            .verifyDonation(donation.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Donation verified ✓'
                                    : 'Failed to verify',
                              ),
                              backgroundColor: success
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Verify'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDatetime(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$date at $hour:$min';
  }
}

// ── Reusable info row ──
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final bool bold;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: bold ? 14 : 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
                color: color ?? const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
