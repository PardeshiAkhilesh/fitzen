import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const EliteFitApp());
    expect(find.byType(EliteFitApp), findsOneWidget);
  });
}