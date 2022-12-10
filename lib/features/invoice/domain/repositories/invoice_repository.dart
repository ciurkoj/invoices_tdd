import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';

abstract class InvoiceRepository{
  Future<Either<Failure, Invoice>> getInvoice(String invoiceId);
  Future<Either<Failure, List<Invoice>>> getAllInvoices();
}