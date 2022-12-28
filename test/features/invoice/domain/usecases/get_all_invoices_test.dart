import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_all_invoices.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_invoices_test.mocks.dart';

@GenerateMocks([InvoiceRepository])
void main() {
  late MockInvoiceRepository mockNumberTriviaRepository;
  late GetAllInvoices usecase;
  late List<InvoiceEntity> tNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockInvoiceRepository();
    usecase = GetAllInvoices(mockNumberTriviaRepository);
    tNumberTrivia = [const InvoiceEntity(vat: 0, invoiceId: '1'), const InvoiceEntity(vat: 0, invoiceId: '1')];
  });

  test(
    'should get trivia from the repository',
    () async {
      //arange

      when(mockNumberTriviaRepository.getAllInvoices()).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      final result = await usecase(NoParams());
      //assert
      expect(result, equals(Right(tNumberTrivia)));
      verify(mockNumberTriviaRepository.getAllInvoices());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
