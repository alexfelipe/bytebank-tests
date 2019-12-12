import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  testWidgets('Should save the new contact', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));

    final transferFeature = find.byWidgetPredicate(
      (widget) => featureItemMatcher(
        widget,
        'Transfer',
        Icons.monetization_on,
      ),
    );
    expect(transferFeature, findsOneWidget);
    await tester.tap(transferFeature);

    //todo verify if the navigator was called

    await tester.pumpWidget(MaterialApp(home: ContactsList()));
    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);

    await tester.pumpWidget(MaterialApp(home: ContactForm()));
    final nameTextField = find
        .byWidgetPredicate((widget) => textFieldMatcher(widget, 'Full name'));
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Alex');

    final accountNumberTextField = find.byWidgetPredicate(
        (widget) => textFieldMatcher(widget, 'Account number'));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(RaisedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);

    //todo verify if the save method from dao was called
  });
}
