import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';

class GetConcreteInvoice extends UseCase<List<InvoiceEntity>, Params> {
  final InvoiceRepository repository;

  GetConcreteInvoice(this.repository);


  @override
  Future<Either<Failure, List<InvoiceEntity>>?> call(Params params) async {
    return await repository.getConcreteInvoice(params.invoiceId);
  }

}