import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../interactions/dashboard_interactions.dart';
import '../matchers/matcher.dart';
import '../mocks/mocks.dart';

void main() {
  testWidgets('Transfer to a contact', (tester) async {
    final MockContactDao mockContactDao = MockContactDao();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final contact = Contact(0, 'Alex', 1000);

    when(mockContactDao.findAll()).thenAnswer((_) async => [contact]);

    await clickOnTheTransferFeature(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    final contactItem = find.byWidgetPredicate((widget) => contactItemMatcher(
          widget,
          'Alex',
          1000,
        ));
    expect(contactItem, findsOneWidget);
    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final nameText = find.text('Alex');
    expect(nameText, findsOneWidget);
    final accountNumberText = find.text('1000');
    expect(accountNumberText, findsOneWidget);

    final valueField =
        find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Value'));
    expect(valueField, findsOneWidget);
    await tester.enterText(valueField, '200');
    
    final transferButton = find.widgetWithText(RaisedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
  });
}
