import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/campaigns/domain/campaign_api.dart';
import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';

final campaignProvider = AsyncNotifierProvider<CampaignNotifier, void>(() {
  return CampaignNotifier();
});

class CampaignNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<bool> createCampaign(CampaignModel campaign) async {
    state = const AsyncValue.loading();

    try {
      await CampaignApi.createCampaign(campaign);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}