import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'matchers.dart';
import 'mocks/dao.dart';
import 'mocks/navigator.dart';
import 'mocks/webclient.dart';

void main() {
  testWidgets('Should save the new contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockWebClient = MockTransactionWebClient();

    await tester.pumpWidget(
      MaterialApp(
        home: BytebankApp(
          contactDao: mockContactDao,
          webClient: mockWebClient,
          home: Dashboard(),
        ),
      ),
    );

    final transferFeature = find.byWidgetPredicate(
      (widget) => featureItemMatcher(
        widget,
        'Transfer',
        Icons.monetization_on,
      ),
    );
    expect(transferFeature, findsOneWidget);
    await tester.tap(transferFeature);

    await tester.pumpAndSettle();

    verify(mockContactDao.findAll());

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final nameTextField = find
        .byWidgetPredicate((widget) => textFieldMatcher(widget, 'Full name'));
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Alex');
    await tester.pumpAndSettle();

    final accountNumberTextField = find.byWidgetPredicate(
        (widget) => textFieldMatcher(widget, 'Account number'));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');
    await tester.pumpAndSettle();

    final createButton = find.widgetWithText(RaisedButton, 'Create');
    expect(createButton, findsOneWidget);

    when(mockContactDao.save(any)).thenAnswer((_) async => 1);

    await tester.tap(createButton);

    verify(mockContactDao.save(any));

    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);
  });
}
