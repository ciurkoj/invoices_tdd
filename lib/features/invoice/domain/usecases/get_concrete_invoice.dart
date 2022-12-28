import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';

class GetConcreteInvoice extends UseCase<InvoiceEntity, Params> {
  final InvoiceRepository repository;

  GetConcreteInvoice(this.repository);


  @override
  Future<Either<Failure, InvoiceEntity>?> call(Params params) async {
    return await repository.getConcreteInvoice(params.invoiceId);
  }

}

class Params extends Equatable {
  final String invoiceId;

  const Params({required this.invoiceId});

  @override
  List<String> get props => [invoiceId];

  String get getInvoiceId => invoiceId;
}
