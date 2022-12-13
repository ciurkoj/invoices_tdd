import 'dart:async';

import 'package:invoices_tdd/features/invoice/data/models/invoice_model.dart';

abstract class InvoiceRemoteDataSource{
  /// Calls the  {...} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<InvoiceModel> getConcreteInvoice(String invoiceId);

  /// Calls the  {...} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<InvoiceModel>> getAllInvoices();
}
