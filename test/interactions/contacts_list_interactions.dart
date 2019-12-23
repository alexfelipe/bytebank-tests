import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future clickOnTheFabNewContact(WidgetTester tester) async {
  final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
  expect(fabNewContact, findsOneWidget);
  await tester.tap(fabNewContact);
}