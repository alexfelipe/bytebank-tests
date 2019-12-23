import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../interactions/contact_form_interactions.dart';
import '../interactions/contacts_list_interactions.dart';
import '../interactions/dashboard_interactions.dart';
import '../matchers/matcher.dart';
import '../mocks/mocks.dart';

void main() {
  testWidgets('should save a contact', (tester) async {
    final MockContactDao mockContactDao = MockContactDao();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    await clickOnTheTransferFeature(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll());

    await clickOnTheFabNewContact(tester);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    await fillTheTextFieldWithLabelText(
      tester,
      text: 'Alex',
      labelText: 'Full name',
    );

    await fillTheTextFieldWithLabelText(
      tester,
      text: '1000',
      labelText: 'Account number',
    );

    //if the save call use `then` instead of async await
    //when(mockContactDao.save(any)).thenAnswer((_) async => 0);

    final newContact = Contact(0, 'Alex', 1000);

    when(mockContactDao.findAll()).thenAnswer((_) async => [newContact]);

    await clickOnCreateButton(tester);
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

