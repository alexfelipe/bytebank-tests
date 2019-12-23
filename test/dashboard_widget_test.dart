import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matcher.dart';

void main() {
  group('Dashboard', () {
    testWidgets('should show the main image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Dashboard()),
      );
      final mainImage = find.byType(Image);
      expect(mainImage, findsOneWidget);
    });
    testWidgets('should sow the transfer feature',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Dashboard()),
      );
      final transferFeature = find.byWidgetPredicate(
          (Widget widget) => featureItemMatcher(
                widget,
                'Transfer',
                Icons.monetization_on,
              ));
      expect(transferFeature, findsOneWidget);
    });
    testWidgets('should show the transaction feed feature', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Dashboard()),
      );
      final transferFeature = find.byWidgetPredicate(
          (Widget widget) => featureItemMatcher(
                widget,
                'Transaction Feed',
                Icons.description,
              ));
      expect(transferFeature, findsOneWidget);
    });
  });
}
