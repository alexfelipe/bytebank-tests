import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should show the main image', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Dashboard()),
    );
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets('Should show the first feature', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Dashboard()),
    );
    final firstFeature = find.byType(FeatureItem);
    expect(firstFeature, findsWidgets);
  });
}
