part of 'invoices_bloc.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object> get props => [];
}

class GetInvoiceForConcreteInvoiceId extends InvoicesEvent{
  final String invoiceId;
  String get getInvoiceId => invoiceId;

  const GetInvoiceForConcreteInvoiceId(this.invoiceId);
}

class GetAllInvoicesEvent extends InvoicesEvent{}

class _InvoicesLoaded extends InvoicesEvent {
  const _InvoicesLoaded(this.loadedState);

  /// The current tick count.
  final InvoicesState loadedState;

  @override
  List<Object> get props => [loadedState];
}
