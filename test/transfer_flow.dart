import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'matchers.dart';
import 'mocks/dao.dart';
import 'mocks/navigator.dart';
import 'mocks/webclient.dart';

void main() {
  testWidgets('Should transfer for a contact', (WidgetTester tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();
    final mockNavigator = MockNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigator],
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

    verify(mockNavigator.didPush(any, any));

    await tester.pumpAndSettle();

    final contact = find.byWidgetPredicate(
      (widget) => ContactItemMatcher(
        widget,
        'Alex',
        1000,
      ),
    );
    expect(contact, findsOneWidget);
    await tester.tap(contact);
    await tester.pumpAndSettle();

    final contactName = find.byWidgetPredicate((widget) {
      if
    });
    expect(contactName, findsOneWidget);

    final contactAccountNumber = find.widgetWithText(Text, '1000');
    expect(contactAccountNumber, findsOneWidget);

  });
}
