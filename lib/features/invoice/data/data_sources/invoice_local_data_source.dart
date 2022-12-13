import 'dart:async';
import 'dart:convert';

import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/features/invoice/data/models/invoice_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class InvoiceLocalDataSource{
  /// Gets the cached [InvoiceModel] which was gotten the last time
  /// user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<InvoiceModel>? getLastInvoice();
  Future<void>? cacheInvoice(InvoiceModel invoiceModel);
  Future<List<InvoiceModel>>? getAllCachedInvoices();
  Future<void>? cacheInvoiceList(List<InvoiceModel> invoiceModelList);
}


// ignore: constant_identifier_names
const CACHED_LAST_INVOICE = 'CACHED_LAST_INVOICE';
// ignore: constant_identifier_names
const CACHED_INVOICES = 'CACHED_INVOICES';

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  late final SharedPreferences sharedPreferences;

  InvoiceLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cacheInvoice(InvoiceModel invoiceModelToCache) {
    return sharedPreferences.setString(
        CACHED_LAST_INVOICE, json.encode(invoiceModelToCache.toJson()));
  }

  @override
  Future<InvoiceModel>? getLastInvoice() {
    final jsonString = sharedPreferences.getString(CACHED_LAST_INVOICE);
    if (jsonString != null) {
      return Future.value(InvoiceModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cacheInvoiceList(List<InvoiceModel> invoiceModelList) {
    return sharedPreferences.setString(
        CACHED_INVOICES,json.encode(invoiceModelList));
  }

  @override
  Future<List<InvoiceModel>>? getAllCachedInvoices() {
    final jsonString = sharedPreferences.getString(CACHED_INVOICES);
    if (jsonString != null) {
      return Future.value(json.decode(jsonString).map<InvoiceModel>((json) => InvoiceModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }
}
