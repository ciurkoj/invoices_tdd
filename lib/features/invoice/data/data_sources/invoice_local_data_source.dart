import 'dart:async';
import 'dart:convert';

import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class InvoiceLocalDataSource{
  /// Gets the cached [InvoiceModel] which was gotten the last time
  /// user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<InvoiceDTO>? getLastInvoice();
  Future<void>? cacheInvoice(InvoiceDTO invoiceModel);
  Future<List<InvoiceDTO>>? getAllCachedInvoices();
  Future<void>? cacheInvoiceList(List<InvoiceDTO> invoiceModelList);
}


// ignore: constant_identifier_names
const CACHED_LAST_INVOICE = 'CACHED_LAST_INVOICE';
// ignore: constant_identifier_names
const CACHED_INVOICES = 'CACHED_INVOICES';

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  final SharedPreferences sharedPreferences;

  InvoiceLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cacheInvoice(InvoiceDTO invoiceModelToCache) {
    var x = sharedPreferences.setString("ASDF", "asdf");
    x;
    return sharedPreferences.setString(
        CACHED_LAST_INVOICE, json.encode(invoiceModelToCache.toJson()));
  }

  @override
  Future<InvoiceDTO>? getLastInvoice() {
    final jsonString = sharedPreferences.getString(CACHED_LAST_INVOICE);
    if (jsonString != null) {
      return Future.value(InvoiceDTO.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cacheInvoiceList(List<InvoiceDTO> invoiceModelList) {
    return sharedPreferences.setString(
        CACHED_INVOICES,json.encode(invoiceModelList));
  }

  @override
  Future<List<InvoiceDTO>>? getAllCachedInvoices() {
    final jsonString = sharedPreferences.getString(CACHED_INVOICES);
    if (jsonString != null) {
      return Future.value(json.decode(jsonString)[CACHED_INVOICES].map<InvoiceDTO>((json) => InvoiceDTO.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }
}
