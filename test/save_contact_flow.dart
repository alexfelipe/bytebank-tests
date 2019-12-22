import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'matcher.dart';
import 'mocks.dart';

void main() {
  testWidgets('should save a contact', (tester) async {
    final MockContactDao mockContactDao = MockContactDao();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeature = find.byWidgetPredicate(
      (widget) => featureItemWithTextAndIconMatcher(
          widget, 'Transfer', Icons.monetization_on),
    );

    expect(transferFeature, findsOneWidget);
    await tester.tap(transferFeature);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll());

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.decoration.labelText == 'Full name';
      }
      return false;
    });
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, 'Alex');

    final accountNumberField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.decoration.labelText == 'Account number';
      }
      return false;
    });
    expect(accountNumberField, findsOneWidget);
    await tester.enterText(accountNumberField, '1000');

    final createButton = find.widgetWithText(RaisedButton, 'Create');
    expect(createButton, findsOneWidget);

//    when(mockContactDao.save(any)).thenAnswer((_) async => 0);

    final newContact = Contact(0, 'Alex', 1000);

    when(mockContactDao.findAll()).thenAnswer((_) async => [newContact]);

    await tester.tap(createButton);
    await tester.pumpAndSettle();

    verify(mockContactDao.save(newContact));

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDao.findAll());

    final newContactItem = find.byWidgetPredicate((widget) {
      if(widget is ContactItem){
        final contact = widget.contact;
        return contact.name == 'Alex' && contact.accountNumber == 1000;
      }
      return false;
    });
    expect(newContactItem, findsOneWidget);
  });
}
