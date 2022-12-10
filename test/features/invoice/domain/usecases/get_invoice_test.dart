import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_concrete_invoice.dart';
import 'package:mockito/mockito.dart';

class MockInvoiceRepository extends Mock implements InvoiceRepository{

  @override
  Future<Either<Failure, Invoice>> getInvoice(String invoiceId) async {
    return await getInvoice(invoiceId) ;

  }
}

void main(){
  MockInvoiceRepository mockInvoiceRepository = MockInvoiceRepository();
  GetConcreteInvoice usecase = GetConcreteInvoice(mockInvoiceRepository);

  setUp(() {
    mockInvoiceRepository = MockInvoiceRepository();
    usecase = GetConcreteInvoice(mockInvoiceRepository);
  });

  const tInvoiceId = "1";
  const tInvoice = Invoice(invoiceId: tInvoiceId, vat: 0);

  test(
    'should get invoice with invoice id from the repository',
    () async {
      // arrange
      when(mockInvoiceRepository.getInvoice(tInvoiceId)).thenAnswer((_) async => const Right(tInvoice));
      // act
      final result = await usecase.call(const Params(invoiceId: tInvoiceId));
      // assert
      expect(result, const Right(tInvoice));
      verify(mockInvoiceRepository.getInvoice(tInvoiceId));
      verifyNoMoreInteractions(mockInvoiceRepository);
    },
  );
}