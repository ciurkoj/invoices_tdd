import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';

void main() {
  late GetInvoiceForConcreteInvoiceId tGetInvoiceForConcreteInvoiceId;
  late GetAllInvoicesEvent tGetAllInvoicesEvent;

  setUp(() {
    tGetInvoiceForConcreteInvoiceId = const GetInvoiceForConcreteInvoiceId("test");
    tGetAllInvoicesEvent = GetAllInvoicesEvent();
  });

  group('NoParams() test', () {
    test(
      'should return a valid invoiceId',
          () async {
        expect(tGetInvoiceForConcreteInvoiceId.getInvoiceId, 'test');
      },
    );

    test(
      'should return a valid invoiceId',
          () async {
        expect(tGetAllInvoicesEvent.props, []);
      },
    );
  });
}
