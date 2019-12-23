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

    await _clickOnTheTransferFeature(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll());

    await _clickOnTheFabNewContact(tester);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    await _fillTheTextFieldWithLabelText(
      tester,
      text: 'Alex',
      labelText: 'Full name',
    );

    await _fillTheTextFieldWithLabelText(
      tester,
      text: '1000',
      labelText: 'Account number',
    );

    //if the save call use `then` instead of async await
    //when(mockContactDao.save(any)).thenAnswer((_) async => 0);

    final newContact = Contact(0, 'Alex', 1000);

    when(mockContactDao.findAll()).thenAnswer((_) async => [newContact]);

    await _clickOnCreateButton(tester);
    await tester.pumpAndSettle();

    verify(mockContactDao.save(newContact));

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDao.findAll());

    final newContactItem = find.byWidgetPredicate((widget) {
      return contactItemMatcher(widget, 'Alex', 1000);
    });
    expect(newContactItem, findsOneWidget);
  });
}

Future _clickOnCreateButton(WidgetTester tester) async {
  final createButton = find.widgetWithText(RaisedButton, 'Create');
  expect(createButton, findsOneWidget);
  await tester.tap(createButton);
}

Future _fillTheTextFieldWithLabelText(
  WidgetTester tester, {
  @required String text,
  @required String labelText,
}) async {
  final textField = find.byWidgetPredicate((widget) {
    return contactFormTextFieldMatcher(widget, labelText);
  });
  expect(textField, findsOneWidget);
  await tester.enterText(textField, text);
}

Future _clickOnTheFabNewContact(WidgetTester tester) async {
  final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
  expect(fabNewContact, findsOneWidget);
  await tester.tap(fabNewContact);
}

Future _clickOnTheTransferFeature(WidgetTester tester) async {
  final transferFeature = find.byWidgetPredicate(
    (widget) => featureItemMatcher(widget, 'Transfer', Icons.monetization_on),
  );

  expect(transferFeature, findsOneWidget);
  await tester.tap(transferFeature);
}
