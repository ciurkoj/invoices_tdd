import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';

void main() {
  late GetInvoiceForConcreteInvoiceId tGetInvoiceForConcreteInvoiceId;
  late GetAllInvoicesEvent tGetAllInvoicesEvent;
  late InvoiceEntity tInvoiceEntity;
  setUp(() {
    tInvoiceEntity = const InvoiceEntity(invoiceId: 'test', vat: 0);
    tGetInvoiceForConcreteInvoiceId = const GetInvoiceForConcreteInvoiceId("test");
    tGetAllInvoicesEvent = GetAllInvoicesEvent([tInvoiceEntity]);
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
        expect(tGetAllInvoicesEvent.getInvoices, [tInvoiceEntity]);
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
