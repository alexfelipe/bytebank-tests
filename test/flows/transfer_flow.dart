import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
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
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(BytebankApp(
      transactionWebClient: mockTransactionWebClient,
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
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final authenticationDialog = find.byType(TransactionAuthDialog);
    expect(authenticationDialog, findsOneWidget);

    final authenticationDialogTitle = find.text('Authenticate');
    expect(authenticationDialogTitle, findsOneWidget);

    final passwordField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.obscureText == true && widget.maxLength == 4;
      }
      return false;
    });
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, '1000');

    final confirmButton = find.widgetWithText(FlatButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    final cancelButton = find.widgetWithText(FlatButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    when(mockTransactionWebClient.save(any, any)).thenAnswer(
      (_) async => Transaction('', 200, contact),
    );

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    verify(
      mockTransactionWebClient.save(Transaction(null, 200, contact), '1000'),
    );

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);

    final okButton = find.widgetWithText(FlatButton, 'Ok');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
  });
}
