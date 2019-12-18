import 'package:bytebank/main.dart';
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
    final mockNavigator = MockNavigatorObserver();
    final mockContactDao = MockContactDao();
    final mockWebClient = MockTransactionWebClient();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigator],
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

    verify(mockNavigator.didPush(
      any,
      any,
    ));

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

//    tava debugando aqui, e o materialApp que tá se livrando do mock observer, estranho... bom pode deixar sem essa validação, mas também tem outros jeitos de validar que deu o pop
//    verificar que elementos na tela sumiram (textos ou ícones)
//    ou verificar que elementos da tela anterior apareceram
//
//    verify(mockNavigator.didPop(
//      any,
//      any,
//    ));
  });
}
