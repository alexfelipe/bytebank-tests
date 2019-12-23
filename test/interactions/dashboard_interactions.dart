import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matcher.dart';

Future clickOnTheTransferFeature(WidgetTester tester) async {
  final transferFeature = find.byWidgetPredicate(
        (widget) => featureItemMatcher(widget, 'Transfer', Icons.monetization_on),
  );

  expect(transferFeature, findsOneWidget);
  await tester.tap(transferFeature);
}
