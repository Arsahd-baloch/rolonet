import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/auth/role_selection/role_selection_screen.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/donor/donor_dashboard_screen.dart';
import '../../features/volunteer/volunteer_dashboard_screen.dart';
import '../../features/ngo/ngo_dashboard_screen.dart';
import '../../features/beneficiary/beneficiary_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/donor/presentation/donor_campaign_list_screen.dart';
import '../../features/donor/presentation/donor_campaign_detail_screen.dart';
import '../../features/donor/presentation/donor_history_screen.dart';

String? currentUserRole;

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String landing = '/landing';
  static const String roleSelect = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String donorDash = '/dashboard/donor';
  static const String volunteerDash = '/dashboard/volunteer';
  static const String ngoDash = '/dashboard/ngo';
  static const String beneficiary = '/dashboard/beneficiary';
  static const String adminDash = '/dashboard/admin';

  static void toSplash(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (_) => false,
    );
  }

  static void toLanding(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  static void toRoleSelection(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
  }

  static void toLogin(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  static void toRegister(BuildContext context, {required String role}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => RegisterScreen(role: role)));
  }

  // ── Dashboards all use pushAndRemoveUntil ──
  // This clears back stack so user cannot go back to landing/login

  static void toDonorDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DonorDashboardScreen()),
      (_) => false,
    );
  }

  static void toVolunteerDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const VolunteerDashboardScreen()),
      (_) => false,
    );
  }

  static void toNgoDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const NgoDashboardScreen()),
      (_) => false,
    );
  }

  static void toBeneficiaryScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BeneficiaryScreen()),
      (_) => false,
    );
  }

  static void toAdminDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      (_) => false,
    );
  }

  static void toDonorCampaignList(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DonorCampaignListScreen()));
  }

  static void toDonorCampaignDetail(BuildContext context, int campaignId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DonorCampaignDetailScreen(campaignId: campaignId),
      ),
    );
  }

  static void toDonorHistory(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DonorHistoryScreen()));
  }

  // ── Role-based routing after login ──
  static void toRoleDashboard(BuildContext context, String role) {
    currentUserRole = role;
    switch (role) {
      case 'donor':
        toDonorDashboard(context);
        break;
      case 'ngo_admin':
        toNgoDashboard(context);
        break;
      case 'volunteer':
        toVolunteerDashboard(context);
        break;
      case 'beneficiary':
        toBeneficiaryScreen(context);
        break;
      case 'admin':
        toAdminDashboard(context);
        break;
      default:
        toLanding(context);
    }
  }

  // ── Logout — clears everything, goes to landing ──
  static void logout(BuildContext context) {
    currentUserRole = null;
    toLanding(context);
  }
}
