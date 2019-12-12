// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bytebank/main.dart';

void main() {
  group('Dashboard', () {
    testWidgets('should display the main image', (WidgetTester tester) async {
      await tester.pumpWidget(BytebankApp());
      final image = find.byKey(Key('dashboardImage'));
      expect(image, findsOneWidget);
    });
    testWidgets('should display the transfer and transaction feed features',
        (tester) async {
      await tester.pumpWidget(BytebankApp());
      final transfer = find.byWidgetPredicate((widget) => _featureItemMatcher(
            widget,
            'Transfer',
            Icons.monetization_on,
          ));
      final transactionFeed = find.byWidgetPredicate(
        (widget) => _featureItemMatcher(
          widget,
          'Transaction Feed',
          Icons.description,
        ),
      );
      expect(transfer, findsOneWidget);
      expect(transactionFeed, findsOneWidget);
    });
  });
}

bool _featureItemMatcher(
  Widget widget,
  String name,
  IconData icon,
) {
  if (widget is FeatureItem) {
    return widget.name == name && widget.icon == icon;
  }
  return false;
}
