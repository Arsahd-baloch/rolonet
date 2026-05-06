import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/campaigns/state/campaign_provider.dart';
import 'package:reliefnet/features/campaigns/presentation/campaign_list_screen.dart';
import 'package:reliefnet/features/campaigns/presentation/create_campaign_screen.dart';

class NgoDashboardScreen extends ConsumerWidget {
  const NgoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text("Error: $e")),

        data: (campaigns) {
          final totalRaised = campaigns.fold(
            0.0,
            (sum, c) => sum + c.totalAmount,
          );

          final activeCount = campaigns
              .where((c) => c.status == 'ACTIVE')
              .length;

          return CustomScrollView(
            slivers: [
              // 🔥 HEADER
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    "NGO Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?q=80&w=1200",
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withValues(alpha: 0.4)),
                    ],
                  ),
                ),
              ),

              // 🔥 STATS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _statCard(
                        "Active",
                        activeCount.toString(),
                        Icons.bolt,
                        Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        "Raised",
                        "${totalRaised.toInt()}",
                        Icons.favorite,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ),

              // 🔥 ACTIONS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _actionCard(
                        title: "View Campaigns",
                        icon: Icons.campaign,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CampaignListScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      _actionCard(
                        title: "Create Campaign",
                        icon: Icons.add,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateCampaignScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  // 🔹 STAT CARD
  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // 🔹 ACTION CARD
  Widget _actionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
