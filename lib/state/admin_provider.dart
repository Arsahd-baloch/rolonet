import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/auth/auth_provider.dart';
import 'package:reliefnet/features/admin/domain/admin_api.dart';
import 'package:reliefnet/features/admin/domain/admin_stats_model.dart';

// ── Admin State ──
class AdminState {
  final bool isLoading;
  final String? error;
  final AdminStatsModel? stats;
  final List<PendingDonationModel> pendingDonations;
  final List<PendingNgoModel> pendingNgos;
  final List<RecentActionModel> recentActions;

  const AdminState({
    this.isLoading = false,
    this.error,
    this.stats,
    this.pendingDonations = const [],
    this.pendingNgos = const [],
    this.recentActions = const [],
  });

  AdminState copyWith({
    bool? isLoading,
    String? error,
    AdminStatsModel? stats,
    List<PendingDonationModel>? pendingDonations,
    List<PendingNgoModel>? pendingNgos,
    List<RecentActionModel>? recentActions,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
      pendingDonations: pendingDonations ?? this.pendingDonations,
      pendingNgos: pendingNgos ?? this.pendingNgos,
      recentActions: recentActions ?? this.recentActions,
    );
  }
}

// ── Admin Notifier ──
class AdminNotifier extends Notifier<AdminState> {
  @override
  AdminState build() {
    // auto load on first access
    Future.microtask(() => loadAll());
    return const AdminState();
  }

  String _getToken() {
    final token = ref.read(authProvider).token;
    if (token == null) throw Exception('Not authenticated');
    return token;
  }

  // ── Load Everything ──
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = _getToken();

      final results = await Future.wait([
        AdminApi.getDashboardStats(token),
        AdminApi.getPendingVerifications(token),
        AdminApi.getRecentActivity(token),
      ]);

      final stats = results[0] as AdminStatsModel;
      final pending = results[1] as Map<String, dynamic>;
      final actions = results[2] as List<RecentActionModel>;

      state = state.copyWith(
        isLoading: false,
        stats: stats,
        pendingDonations:
            pending['pending_donations'] as List<PendingDonationModel>,
        pendingNgos: pending['pending_ngos'] as List<PendingNgoModel>,
        recentActions: actions,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Verify Donation ──
  Future<bool> verifyDonation(int id) async {
    try {
      final token = _getToken();
      final success = await AdminApi.verifyDonation(id, token);
      if (success) {
        // remove from pending list
        state = state.copyWith(
          pendingDonations: state.pendingDonations
              .where((d) => d.id != id)
              .toList(),
        );
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  // ── Cancel Donation ──
  Future<bool> cancelDonation(int id) async {
    try {
      final token = _getToken();
      final success = await AdminApi.cancelDonation(id, token);
      if (success) {
        state = state.copyWith(
          pendingDonations: state.pendingDonations
              .where((d) => d.id != id)
              .toList(),
        );
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

// ── Provider ──
final adminProvider = NotifierProvider<AdminNotifier, AdminState>(
  AdminNotifier.new,
);
