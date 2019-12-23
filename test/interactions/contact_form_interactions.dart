import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matcher.dart';

Future clickOnCreateButton(WidgetTester tester) async {
  final createButton = find.widgetWithText(RaisedButton, 'Create');
  expect(createButton, findsOneWidget);
  await tester.tap(createButton);
}

Future fillTheTextFieldWithLabelText(
    WidgetTester tester, {
      @required String text,
      @required String labelText,
    }) async {
  final textField = find.byWidgetPredicate((widget) {
    return textFieldMatcher(widget, labelText);
  });
  expect(textField, findsOneWidget);
  await tester.enterText(textField, text);
}

