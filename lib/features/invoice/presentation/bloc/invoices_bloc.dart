// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
const String NO_MATCHING_RESULTS_FOUND = 'No matching results found';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final GetConcreteInvoice getConcreteInvoice;
  final GetAllInvoices getAllInvoices;
  final InputConverter inputConverter;

  InvoicesState get initialState => Empty();

  InvoicesBloc(
      {required GetConcreteInvoice concrete,
      required GetAllInvoices all,
      required this.inputConverter})
      : assert(concrete != null),
        assert(all != null),
        assert(inputConverter != null),
        getConcreteInvoice = concrete,
        getAllInvoices = all,
        super(Empty()) {

    on<GetAllInvoicesEvent>((event, emit) async {
      emit(Loading());
      final failureOrAll = await getAllInvoices(NoParams());
      failureOrAll!.fold((failure) {
        emit(Error(message: mapFailureToMessage(failure)));
      }, (invoices) {
        emit(Loaded(invoice: invoices));
      });
    });

    on<GetInvoiceForConcreteInvoiceId>((event, emit)  async {
      emit(Loading());
      final inputEither = inputConverter.inputToString(event.invoiceId);
      if(inputEither.isRight()){
        final failureOrInvoice = await getConcreteInvoice(Params(invoiceId: event.invoiceId));
        await emit.onEach<InvoicesState>(eitherLoadedOrErrorState(failureOrInvoice!),
            onData: (invoice) async {
              emit(Loading());
              add(_InvoicesLoaded(invoice));
            });
      }else{
        emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }
    });
    on<_InvoicesLoaded>((event, emit) => emit(event.loadedState));
  }

  @visibleForTesting
  Stream<InvoicesState> eitherLoadedOrErrorState(
      Either<Failure, List<InvoiceEntity>> failureOrInvoice) async* {
    yield* failureOrInvoice.fold(
            (failure) => Stream.value(Error(message: mapFailureToMessage(failure))),
            (invoice) {
          if (invoice.isEmpty) {
            return Stream.value(const Error(message: NO_MATCHING_RESULTS_FOUND));
          }
          return Stream.value(Loaded(invoice: invoice));
        });
  }

  @visibleForTesting
  String mapFailureToMessage(Failure failure) {
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
