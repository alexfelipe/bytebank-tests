import 'package:bytebank/main.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  group('Dashboard', () {
    testWidgets('should display the main image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Dashboard()),
      );
      final image = find.byKey(Key('dashboardImage'));
      expect(image, findsOneWidget);
    });
    testWidgets('should display the transfer feature', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Dashboard(),
      ));
      final Finder transfer = find.byWidgetPredicate(
        (widget) {
          return featureItemMatcher(widget, 'Transfer', Icons.monetization_on);
        },
      );
      debugPrint('transfer $transfer');
      expect(transfer, findsOneWidget);
    });
    testWidgets('should display the transaction feed feature', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Dashboard(),
      ));
      final transactionFeed = find.byWidgetPredicate(
        (widget) => featureItemMatcher(
          widget,
          'Transaction Feed',
          Icons.description,
        ),
      );
      expect(transactionFeed, findsOneWidget);
    });
  });
}
