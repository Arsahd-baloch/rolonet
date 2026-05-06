// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reliefnet/features/campaigns/domain/campaign_api.dart';
// import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';
// import 'package:reliefnet/features/auth/auth_provider.dart';

// final campaignProvider =
//     AsyncNotifierProvider<CampaignNotifier, List<CampaignModel>>(
//   CampaignNotifier.new,
// );

// class CampaignNotifier extends AsyncNotifier<List<CampaignModel>> {

//   // ================= INITIAL LOAD =================
//   @override
//   Future<List<CampaignModel>> build() async {
//     return await CampaignApi.getCampaigns();
//   }

//   // ================= GET TOKEN HELPER =================
//   String _getToken() {
//     final token = ref.read(authProvider).token;
//     if (token == null) throw Exception('User not authenticated');
//     return token;
//   }

//   // ================= REFRESH =================
//   Future<void> loadCampaigns() async {
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(() => CampaignApi.getCampaigns());
//   }

//   // ================= CREATE =================
//   Future<bool> createCampaign(CampaignModel campaign) async {
//     final token = _getToken();

//     print("TOKEN FROM PROVIDER: $token");

//     state = const AsyncLoading();

//     final result = await AsyncValue.guard(() async {
//       await CampaignApi.createCampaign(campaign, token);
//       return await CampaignApi.getCampaigns(); // ✅ refresh after create
//     });

//     state = result;
//     return !result.hasError;
//   }

//   // ================= UPDATE ✅ NEW =================
//   Future<bool> updateCampaign(int id, CampaignModel campaign) async {
//     final token = _getToken();

//     // ✅ optimistic update — update locally first, no loading flash
//     state.whenData((campaigns) {
//       state = AsyncData(
//         campaigns.map((c) => c.id == id ? campaign : c).toList(),
//       );
//     });

//     final result = await AsyncValue.guard(() async {
//       await CampaignApi.updateCampaign(id, campaign, token);
//       return await CampaignApi.getCampaigns(); // ✅ sync with backend
//     });

//     state = result;
//     return !result.hasError;
//   }

//   // ================= DELETE ✅ NEW =================
//   Future<bool> deleteCampaign(int id) async {
//     final token = _getToken();

//     // ✅ optimistic delete — remove locally immediately
//     state.whenData((campaigns) {
//       state = AsyncData(
//         campaigns.where((c) => c.id != id).toList(),
//       );
//     });

//     final result = await AsyncValue.guard(() async {
//       await CampaignApi.deleteCampaign(id, token);
//       return await CampaignApi.getCampaigns(); // ✅ sync with backend
//     });

//     state = result;
//     return !result.hasError;
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/campaigns/domain/campaign_api.dart';
import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';
import 'package:reliefnet/features/auth/auth_provider.dart';

final campaignProvider =
    AsyncNotifierProvider<CampaignNotifier, List<CampaignModel>>(
      CampaignNotifier.new,
    );

class CampaignNotifier extends AsyncNotifier<List<CampaignModel>> {
  // ================= INITIAL LOAD =================
  @override
  Future<List<CampaignModel>> build() async {
    return await CampaignApi.getCampaigns();
  }

  // ================= TOKEN HELPER =================
  String _getToken() {
    final token = ref.read(authProvider).token;
    if (token == null) throw Exception('User not authenticated');
    return token;
  }

  // ================= REFRESH =================
  Future<void> loadCampaigns() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => CampaignApi.getCampaigns());
  }

  // ================= CREATE =================
  Future<bool> createCampaign(CampaignModel campaign) async {
    final token = _getToken();

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await CampaignApi.createCampaign(campaign, token);
      return await CampaignApi.getCampaigns();
    });

    state = result;
    return !result.hasError;
  }

  // ================= UPDATE =================
  Future<bool> updateCampaign(int id, CampaignModel campaign) async {
    final token = _getToken();

    // optimistic update
    state.whenData((campaigns) {
      state = AsyncData(
        campaigns.map((c) => c.id == id ? campaign : c).toList(),
      );
    });

    final result = await AsyncValue.guard(() async {
      await CampaignApi.updateCampaign(id, campaign, token);
      return await CampaignApi.getCampaigns();
    });

    state = result;
    return !result.hasError;
  }

  // ================= DELETE =================
  Future<bool> deleteCampaign(int id) async {
    final token = _getToken();

    // optimistic delete
    state.whenData((campaigns) {
      state = AsyncData(campaigns.where((c) => c.id != id).toList());
    });

    final result = await AsyncValue.guard(() async {
      await CampaignApi.deleteCampaign(id, token);
      return await CampaignApi.getCampaigns();
    });

    state = result;
    return !result.hasError;
  }

  // ================= ACTIVATE ✅ NEW =================
  Future<bool> activateCampaign(int id) async {
    final token = _getToken();

    // optimistic update — show ACTIVE immediately
    state.whenData((campaigns) {
      state = AsyncData(
        campaigns
            .map((c) => c.id == id ? c.copyWith(status: 'ACTIVE') : c)
            .toList(),
      );
    });

    final result = await AsyncValue.guard(() async {
      await CampaignApi.activateCampaign(id, token);
      return await CampaignApi.getCampaigns(); // sync with backend
    });

    state = result;
    return !result.hasError;
  }

  // ================= CLOSE ✅ NEW =================
  Future<bool> closeCampaign(int id) async {
    final token = _getToken();

    // optimistic update — show CLOSED immediately
    state.whenData((campaigns) {
      state = AsyncData(
        campaigns
            .map((c) => c.id == id ? c.copyWith(status: 'CLOSED') : c)
            .toList(),
      );
    });

    final result = await AsyncValue.guard(() async {
      await CampaignApi.closeCampaign(id, token);
      return await CampaignApi.getCampaigns(); // sync with backend
    });

    state = result;
    return !result.hasError;
  }
}
