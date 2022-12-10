import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_all_invoices.dart';
import 'package:mockito/mockito.dart';

class MockInvoiceRepository extends Mock implements InvoiceRepository{

  @override
  Future<Either<Failure, List<Invoice>>> getAllInvoices() async {
    return await getAllInvoices() ;

  }
}

void main(){
  MockInvoiceRepository mockInvoiceRepository = MockInvoiceRepository();
  GetAllInvoices useCase = GetAllInvoices(mockInvoiceRepository);

  setUp(() {
    mockInvoiceRepository = MockInvoiceRepository();
    useCase = GetAllInvoices(mockInvoiceRepository);
  });

  const tInvoiceList = [Invoice(invoiceId: "1", vat: 0),Invoice(invoiceId: "2", vat: 7)];

  test(
    'should get all invoices from the repository',
        () async {
      // arrange
      when(mockInvoiceRepository.getAllInvoices()).thenAnswer((_) async => const Right(tInvoiceList));
      // act
      final result = await useCase.call(NoParams());
      // assert
      expect(result, const Right(tInvoiceList));
      verify(mockInvoiceRepository.getAllInvoices());
      verifyNoMoreInteractions(mockInvoiceRepository);
    },
  );
}