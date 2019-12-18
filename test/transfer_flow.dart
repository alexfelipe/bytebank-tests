import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'matchers.dart';
import 'mocks/dao.dart';
import 'mocks/webclient.dart';

void main() {
  testWidgets('Should transfer for a contact', (WidgetTester tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();

    await tester.pumpWidget(
      MaterialApp(
        home: BytebankApp(
          contactDao: mockContactDao,
          webClient: mockTransactionWebClient,
          home: Dashboard(),
        ),
      ),
    );
    final featureTransfer = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(featureTransfer, findsOneWidget);

    when(mockContactDao.findAll())
        .thenAnswer((_) async => [Contact(0, 'Alex', 1000)]);

    await tester.tap(featureTransfer);

    await tester.pumpAndSettle();

    final contact = find.byWidgetPredicate(
          (widget) =>
          ContactItemMatcher(
            widget,
            'Alex',
            1000,
          ),
    );
    expect(contact, findsOneWidget);
    await tester.tap(contact);

    await tester.pumpAndSettle();

    final contactName = find.byKey(transactionFormContactNameKey);
    expect(contactName, findsOneWidget);

    final contactAccountNumber =
    find.byKey(transactionFormContactAccountNumberKey);
    expect(contactAccountNumber, findsOneWidget);

    final valueField = find.byKey(transactionFormValueFieldKey);
    expect(valueField, findsOneWidget);
    await tester.enterText(valueField, '100');
    await tester.pumpAndSettle();

    final transferButton = find.byKey(transactionFormTransferButtonKey);
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final dialogTitle = find.text('Authenticate');
    expect(dialogTitle, findsOneWidget);

    final passwordField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.obscureText == true && widget.maxLength == 4;
      }
      return false;
    });
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, '1000');
    await tester.pumpAndSettle();

    final confirmButton = find.widgetWithText(FlatButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    final cancelButton = find.widgetWithText(FlatButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    when(mockTransactionWebClient.save(any, any)).thenAnswer((_) async => any);

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    verify(mockTransactionWebClient.save(any, any));
  });
}
