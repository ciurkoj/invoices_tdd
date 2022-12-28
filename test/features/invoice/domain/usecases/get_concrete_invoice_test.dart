import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
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
  late InvoiceEntity tNumberTrivia;
  late Params tParams;

  setUp(() {
    mockNumberTriviaRepository = MockInvoiceRepository();
    usecase = GetConcreteInvoice(mockNumberTriviaRepository);
    tNumberTrivia = const InvoiceEntity(vat: 1, invoiceId: 'test');
    tNumber = "1";
    tParams = const Params(invoiceId: 'test');
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      //arange

      when(mockNumberTriviaRepository.getConcreteInvoice(tNumber)).thenAnswer((e) async {
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
}
