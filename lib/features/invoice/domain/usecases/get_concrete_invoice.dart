import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';

class GetConcreteInvoice extends UseCase<Invoice, Params> {
  final InvoiceRepository repository;

  GetConcreteInvoice(this.repository);

  @override
  Future<Either<Failure, Invoice>> call(Params params) async {
    return await repository.getInvoice(params.invoiceId);
  }
}

class Params extends Equatable {
  final String invoiceId;

  const Params({required this.invoiceId}) : super();

  @override
  List<Object?> get props => [invoiceId];
}
