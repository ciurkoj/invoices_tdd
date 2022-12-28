import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String invoiceId;
  final int vat;

  const InvoiceEntity({required this.invoiceId, required this.vat});

  @override
  List<Object?> get props => [invoiceId, vat];
}
