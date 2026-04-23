class ApiConstants {
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator/desktop/web
  static const String baseUrl = 'http://localhost:3000/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
}
