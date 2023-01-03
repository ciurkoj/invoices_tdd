import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoiceRepository{
  Future<Either<Failure, List<InvoiceEntity>>>? getConcreteInvoice(String invoiceId);
  Future<Either<Failure, List<InvoiceEntity>>>? getAllInvoices();
}