import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';

void main() {
  late Params tParams;
  late NoParams tNoParams;

  setUp(() {
    tParams = const Params(invoiceId: 'test');
    tNoParams = NoParams();
  });


  group('Params() test', () {
    test(
      'should return a valid props',
          () async {
        expect(tParams.props, ['test']);
      },
    );

    test(
      'should return a valid invoiceId',
          () async {
        expect(tParams.getInvoiceId, 'test');
      },
    );
  });
  group('NoParams() test', () {
    test(
      'should return an empty list',
          () async {
        expect(tNoParams.props, []);
      },
    );

  });
}
