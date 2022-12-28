// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/core/util/input_converter.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_all_invoices.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_concrete_invoice.dart';

part 'invoices_event.dart';

part 'invoices_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a valid String';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final GetConcreteInvoice getConcreteInvoice;
  final GetAllInvoices getAllInvoices;
  final InputConverter inputConverter;

  InvoicesState get initialState => Empty();

  InvoicesBloc({required GetConcreteInvoice concrete, required GetAllInvoices all, required this.inputConverter})
      : assert(concrete != null),
        assert(all != null),
        assert(inputConverter != null),
        getConcreteInvoice = concrete,
        getAllInvoices = all,
        super(Empty()) {
    on<GetInvoiceForConcreteInvoiceId>((event, emit) async {
      final inputEither = inputConverter.inputToString(event.invoiceId);
      inputEither.fold((failure) {
        emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (invoiceId) async* {
        emit(Loading());
        final failureOrInvoice = await getConcreteInvoice(Params(invoiceId: invoiceId));
        yield* _eitherLoadedOrErrorState(failureOrInvoice!);
      });
    });
    on<GetAllInvoicesEvent>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getAllInvoices(NoParams());
      failureOrTrivia!.fold((failure) {
        emit(Error(message: _mapFailureToMessage(failure)));
      }, (invoices) {
        emit(Loaded( invoice:invoices ));
      });
    });
  }

  Stream<InvoicesState> _eitherLoadedOrErrorState(Either<Failure, InvoiceEntity> failureOrInvoice) async* {
    yield failureOrInvoice.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)), (invoice) => Loaded(invoice: [invoice]));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
