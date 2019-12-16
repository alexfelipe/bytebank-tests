import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'matchers.dart';
import 'mocks/navigator.dart';

void main() {
  testWidgets('Should save the new contact', (tester) async {
    final mockNavigator = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      navigatorObservers: [mockNavigator],
      home: Dashboard(),
    ));

    final transferFeature = find.byWidgetPredicate(
      (widget) => featureItemMatcher(
        widget,
        'Transfer',
        Icons.monetization_on,
      ),
    );
    expect(transferFeature, findsOneWidget);
    await tester.tap(transferFeature);
    await tester.pump();

    verify(mockNavigator.didPush(
      any,
      any,
    ));

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pump();

    final nameTextField = find
        .byWidgetPredicate((widget) => textFieldMatcher(widget, 'Full name'));
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Alex');
    await tester.pump();

    final accountNumberTextField = find.byWidgetPredicate(
        (widget) => textFieldMatcher(widget, 'Account number'));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');
    await tester.pump();

    final createButton = find.widgetWithText(RaisedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pump();

    //todo verify if the save method from dao was called
    verify(mockNavigator.didPop(
      any,
      any,
    ));
  });
}
