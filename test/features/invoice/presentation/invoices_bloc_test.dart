import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/core/util/input_converter.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_all_invoices.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_concrete_invoice.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'invoices_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteInvoice, GetAllInvoices, InputConverter])

void main() {
  late InvoicesBloc bloc;
  late MockGetConcreteInvoice mockGetConcreteInvoice;
  late MockGetAllInvoices mockGetAllInvoices;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteInvoice = MockGetConcreteInvoice();
    mockGetAllInvoices = MockGetAllInvoices();
    mockInputConverter = MockInputConverter();

    bloc = InvoicesBloc(concrete: mockGetConcreteInvoice, all: mockGetAllInvoices, inputConverter: mockInputConverter);
  });

  test(
    'initialState should be Empty',
    () async {
      // assert
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tInvoiceIdString = '1';
    final tInvoiceIdParsed = "1";
    final tInvoice = const Invoice(invoiceId: 'test trivia', vat: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.inputToString(any)).thenReturn(Right(tInvoiceIdParsed));
    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetInvoiceForConcreteInvoiceId(tInvoiceIdString));
      await untilCalled(mockInputConverter.inputToString(any));
      //assert
      verify(mockInputConverter.inputToString(tInvoiceIdString));
    });

    test('should emit [Error] when the inpus is invalid.', () async* {
      //arrange
      when(mockInputConverter.inputToString(any)).thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      //assert later
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetInvoiceForConcreteInvoiceId(tInvoiceIdString));
    });

    test('should get data from the concrete usecase', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteInvoice(any))
          .thenAnswer((_) async => Right(tInvoice));
      //act
      bloc.add(GetInvoiceForConcreteInvoiceId(tInvoiceIdString));
      await untilCalled(mockGetConcreteInvoice(any));

      //assert
      verify(mockGetConcreteInvoice(Params(invoiceId: tInvoiceIdParsed)));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
            () async* {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteInvoice(any))
              .thenAnswer((_) async => Right(tInvoice));

          //assert later
          final expected = [Empty(), Loading(), Loaded(invoice: [tInvoice])];
          expectLater(bloc, emitsInOrder(expected));

          //act
          bloc.add(GetInvoiceForConcreteInvoiceId(tInvoiceIdString));
        });

    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteInvoice(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expeted = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetInvoiceForConcreteInvoiceId(tInvoiceIdString));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
            () async* {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteInvoice(any))
              .thenAnswer((_) async => Left(CacheFailure()));

          //assert later
          final expeted = [
            Empty(),
            Loading(),
            const Error(message: CACHE_FAILURE_MESSAGE)
          ];
          expectLater(bloc, emitsInOrder(expeted));
          //act
          bloc.add(GetInvoiceForConcreteInvoiceId(tInvoiceIdString));
        });
  });

  group('GetTriviaForAllInvoices', () {

    final tAllInvoices = const [Invoice(invoiceId: 'test trivia', vat: 1), Invoice(invoiceId: 'test trivia', vat: 1)];

    test('should get data from the concrete usecase', () async* {
      //arrange
      when(mockGetAllInvoices(any))
          .thenAnswer((_) async => Right(tAllInvoices));
      //act
      bloc.add(GetAllInvoicesEvent(tAllInvoices));
      await untilCalled(mockGetAllInvoices(any));

      //assert
      verify(mockGetAllInvoices(NoParams()));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
            () async* {
          //arrange
          when(mockGetAllInvoices(any))
              .thenAnswer((_) async => Right(tAllInvoices));

          //assert later
          final expeted = [Empty(), Loading(), Loaded(invoice: tAllInvoices)];
          expectLater(bloc, emitsInOrder(expeted));
          //act
          bloc.add(GetAllInvoicesEvent(tAllInvoices));
        });

    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      when(mockGetAllInvoices(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expeted = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetAllInvoicesEvent(tAllInvoices));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
            () async* {
          //arrange
          when(mockGetAllInvoices(any))
              .thenAnswer((_) async => Left(CacheFailure()));

          //assert later
          final expeted = [
            Empty(),
            Loading(),
            const Error(message: CACHE_FAILURE_MESSAGE)
          ];
          expectLater(bloc, emitsInOrder(expeted));
          //act
          bloc.add(GetAllInvoicesEvent(tAllInvoices));
        });
  });
}
