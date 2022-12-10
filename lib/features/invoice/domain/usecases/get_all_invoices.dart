import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/usecases/use_case.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';

class GetAllInvoices implements UseCase<List<Invoice>, NoParams>{
  final InvoiceRepository repository;

  GetAllInvoices(this.repository);

  @override
  Future<Either<Failure, List<Invoice>>> call(NoParams params) async {
    return await repository.getAllInvoices();
  }

}