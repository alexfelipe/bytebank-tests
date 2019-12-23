import 'package:bytebank/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the same value that was sent in transaction construtor',
      () {
    final transaction = Transaction('', 1000, null);
    expect(transaction.value, equals(1000));
  });
  test(
    'Should throw an assert error when create a transaction with value less than zero',
    () {
      final Transaction Function() transactionWithZeroValue =
          () => Transaction('', 0, null);
      expect(transactionWithZeroValue, throwsAssertionError);
    },
  );
}
