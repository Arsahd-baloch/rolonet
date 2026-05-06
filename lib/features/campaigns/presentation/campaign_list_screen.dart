import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/campaigns/presentation/widgets/campaign_card.dart';
import 'package:reliefnet/features/campaigns/state/campaign_provider.dart';
import 'campaign_detail_screen.dart';

class CampaignListScreen extends ConsumerStatefulWidget {
  const CampaignListScreen({super.key});

  @override
  ConsumerState<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends ConsumerState<CampaignListScreen> {
  String selectedFilter = "ALL";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(campaignProvider.notifier).loadCampaigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Campaigns")),

      body: Column(
        children: [
          // 🔥 FILTER TABS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _filterButton("ALL"),
                _filterButton("ACTIVE"),
                _filterButton("DRAFT"),
              ],
            ),
          ),

          // 🔥 LIST
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),

              error: (e, _) => Center(child: Text("Error: $e")),

              data: (campaigns) {
                // ✅ APPLY FILTER
                final filtered = campaigns.where((c) {
                  if (selectedFilter == "ALL") return true;
                  return c.status == selectedFilter;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No campaigns found"));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final campaign = filtered[index];

                    return CampaignCard(
                      campaign: campaign,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CampaignDetailScreen(campaign: campaign),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 FILTER BUTTON WIDGET
  Widget _filterButton(String label) {
    final isSelected = selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),

          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
