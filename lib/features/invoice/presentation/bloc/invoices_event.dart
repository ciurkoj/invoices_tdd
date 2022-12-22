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

class GetAllInvoicesEvent extends InvoicesEvent{
  final List<Invoice> invoices;
  List<Invoice> get getInvoices => invoices;

  const GetAllInvoicesEvent(this.invoices);
}