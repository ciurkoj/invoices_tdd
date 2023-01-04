part of 'invoices_bloc.dart';

abstract class InvoicesState extends Equatable {
  const InvoicesState();

  @override
  List<Object> get props => [];
}

class Empty extends InvoicesState {}

class Loading extends InvoicesState {}

class Loaded extends InvoicesState {
  final List<InvoiceEntity> invoice;

   const Loaded({required this.invoice}) : super();
}

class Error extends InvoicesState {
  final String message;

   const Error({required this.message}) : super();
}

class LoadedSuccess extends InvoicesState {
  /// {@macro ticker_tick_success}
  const LoadedSuccess(this.invoice);

  /// The current tick count.
  final List<InvoiceEntity> invoice;

  @override
  List<Object> get props => [invoice];
}

class TickerComplete extends InvoicesState {
  /// {@macro ticker_complete}
  const TickerComplete();
}
