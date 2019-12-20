import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matcher.dart';

void main() {
  testWidgets('should save a contact', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Dashboard(),
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeature = find.byWidgetPredicate(
      (widget) => featureItemWithTextAndIconMatcher(
          widget, 'Transfer', Icons.monetization_on),
    );

    expect(transferFeature, findsOneWidget);
    await tester.tap(transferFeature);
    await tester.pump();
    await tester.pump();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pump();
    await tester.pump();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);
  });
}
