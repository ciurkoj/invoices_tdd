import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final String invoiceId;
  final int vat;

  const Invoice({required this.invoiceId, required this.vat});

  @override
  List<Object?> get props => [invoiceId, vat];
}
