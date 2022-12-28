import 'dart:async';

import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/core/util/constants.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:http/http.dart' as http;

abstract class InvoiceRemoteDataSource{
  /// Calls the  {...} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<InvoiceDTO> getConcreteInvoice(String invoiceId);

  /// Calls the  {...} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<InvoiceDTO>> getAllInvoices();
}


class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  late final http.Client client;

  InvoiceRemoteDataSourceImpl({required this.client});

  Future<InvoiceDTO> _getInvoiceFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return const InvoiceDTO(invoiceId: '1',vat:1);
    } else {
      throw ServerException();
    }
  }
  Future<List<InvoiceDTO>> _getAllInvoicesFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return [const InvoiceDTO(invoiceId: '1',vat:1),const InvoiceDTO(invoiceId: '1',vat:1)];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<InvoiceDTO>> getAllInvoices() {
    // TODO: implement getAllInvoices with the correct Url
    return _getAllInvoicesFromUrl('${Constants.URL}/random');
  }

  @override
  Future<InvoiceDTO> getConcreteInvoice(String invoiceId) {
    // TODO: implement getConcreteInvoice with the correct Url
    return _getInvoiceFromUrl('${Constants.URL}/$invoiceId');
  }
}
