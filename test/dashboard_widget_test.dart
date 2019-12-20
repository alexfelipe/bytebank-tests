import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

int counter = 1;

void main() {
  testWidgets('Should show the main image', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Dashboard()),
    );
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets('Should show the transfer feature', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Dashboard()),
    );
    final transferFeature = find.byWidgetPredicate((Widget widget) {
      if (widget is FeatureItem) {
        return widget.name == 'Transfer' &&
            widget.icon == Icons.monetization_on;
      }
      return false;
    }, description: 'FeatureItem with text and icon');
    expect(transferFeature, findsOneWidget);
  });
}
