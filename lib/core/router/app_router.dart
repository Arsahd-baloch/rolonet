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

/// Mock current user role — set this after login (UI only, no backend).
/// Possible values: 'donor' | 'volunteer' | 'ngo' | 'beneficiary' | 'admin' | null
String? currentUserRole;

/// Central navigation helper for ReliefNet.
/// All navigation is done via [Navigator.push] + [MaterialPageRoute].
class AppRouter {
  AppRouter._();

  // ─── Route name constants ────────────────
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

  // ─── Navigation methods ──────────────────

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

  static void toDonorDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DonorDashboardScreen()));
  }

  static void toVolunteerDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const VolunteerDashboardScreen()));
  }

  static void toNgoDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NgoDashboardScreen()));
  }

  static void toBeneficiaryScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const BeneficiaryScreen()));
  }

  static void toAdminDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
  }

  /// Role-based routing after mock login.
  /// Pass a role string and the user is sent to the correct dashboard.
  static void toRoleDashboard(BuildContext context, String role) {
    currentUserRole = role;
    switch (role) {
      case 'donor':
        toDonorDashboard(context);
        break;
      case 'volunteer':
        toVolunteerDashboard(context);
        break;
      case 'ngo':
        toNgoDashboard(context);
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
}
