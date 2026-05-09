import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/auth/auth_provider.dart';
import 'package:reliefnet/features/donor/domain/donation_api.dart';
import 'package:reliefnet/features/donor/domain/donation_model.dart';

// ── State ──
class DonationState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const DonationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  DonationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return DonationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

// ── Notifier ──
class DonationNotifier extends Notifier<DonationState> {
  @override
  DonationState build() => const DonationState();

  String _getToken() {
    final token = ref.read(authProvider).token;
    if (token == null) throw Exception('User not authenticated');
    return token;
  }

  Future<bool> submitDonation({
    required int campaignId,
    required DonationModel donation,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final token = _getToken();

      await DonationApi.createDonation(
        campaignId: campaignId,
        donation: donation,
        token: token,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const DonationState();
  }
}

// ── Provider ──
final donationProvider = NotifierProvider<DonationNotifier, DonationState>(
  DonationNotifier.new,
);
