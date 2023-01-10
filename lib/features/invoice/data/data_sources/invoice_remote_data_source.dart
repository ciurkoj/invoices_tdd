import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

abstract class InvoiceRemoteDataSource {
  /// Calls the  {...} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<InvoiceDTO>> getConcreteInvoice(String invoiceId);

  /// Calls the  {...} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<InvoiceDTO>> getAllInvoices();
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  late final http.Client client;
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("invoices");

  InvoiceRemoteDataSourceImpl({required this.client});

  @override
  Future<List<InvoiceDTO>> getAllInvoices() async {
    QuerySnapshot querySnapshot = await collection.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData.map((e) => InvoiceDTO.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<InvoiceDTO>> getConcreteInvoice(String invoiceId) async {
    var invoice =
        await collection.where("invoiceId", isEqualTo: invoiceId).get().then((value) => value);

    final allData = invoice.docs.map((doc) => doc.data()).toList();

    return allData.map((e) => InvoiceDTO.fromJson(e)).toList();
  }
}
