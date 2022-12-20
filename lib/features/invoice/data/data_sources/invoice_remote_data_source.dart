import 'dart:async';

import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/core/util/constants.dart';
import 'package:invoices_tdd/features/invoice/data/models/invoice_model.dart';
import 'package:http/http.dart' as http;

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


class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  late final http.Client client;

  InvoiceRemoteDataSourceImpl({required this.client});

  Future<InvoiceModel> _getInvoiceFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return const InvoiceModel(invoiceId: '1',vat:1);
    } else {
      throw ServerException();
    }
  }
  Future<List<InvoiceModel>> _getAllInvoicesFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return [const InvoiceModel(invoiceId: '1',vat:1),const InvoiceModel(invoiceId: '1',vat:1)];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<InvoiceModel>> getAllInvoices() {
    // TODO: implement getAllInvoices with the correct Url
    return _getAllInvoicesFromUrl('${Constants.URL}/random');
  }

  @override
  Future<InvoiceModel> getConcreteInvoice(String invoiceId) {
    // TODO: implement getConcreteInvoice with the correct Url
    return _getInvoiceFromUrl('${Constants.URL}/$invoiceId');
  }
}
