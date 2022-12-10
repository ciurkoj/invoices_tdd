import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_concrete_invoice.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_invoice_test.mocks.dart';

@GenerateMocks([InvoiceRepository])
void main() {
  late MockInvoiceRepository mockNumberTriviaRepository;
  late GetConcreteInvoice usecase;
  late String tNumber;
  late Invoice tNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockInvoiceRepository();
    usecase = GetConcreteInvoice(mockNumberTriviaRepository);
    tNumberTrivia = const Invoice(vat: 1, invoiceId: 'test');
    tNumber = "1";
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      //arange

      when(mockNumberTriviaRepository.getConcreteInvoice(tNumber))
          .thenAnswer((e) async {
        return Right(tNumberTrivia);
      });
      //act
      final result = await usecase(Params(invoiceId: tNumber));
      //assert
      expect(result, equals(Right(tNumberTrivia)));
      verify(mockNumberTriviaRepository.getConcreteInvoice(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}