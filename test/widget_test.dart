import 'package:flutter_test/flutter_test.dart';
import 'package:reliefnet/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ReliefNetApp()));

    // Verify that the app name is present (on Splash or Landing)
    expect(find.text('ReliefNet'), findsOneWidget);
  });
}
