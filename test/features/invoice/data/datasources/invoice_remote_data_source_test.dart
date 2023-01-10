import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_remote_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import '../../../app/view/app_test.dart';
import 'invoice_remote_data_source_test.mocks.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}


@GenerateMocks([InvoiceRemoteDataSourceImpl, http.Client])
void main() {
  late InvoiceRemoteDataSourceImpl dataSource;

  setUp(() async {
    setupFirebaseAuthMocks();
    await Firebase.initializeApp();
    dataSource = MockInvoiceRemoteDataSourceImpl();
  });

  group('getConcreteInvoice', () {
    const tInvoiceId = "1";
    final tInvoiceModel = InvoiceDTO.fromJson(json.decode(fixture('invoice.json')));


    test(
      'should return Imvoice when the response is 200 (success)',
      () async {
        // arrange
        when(dataSource.getConcreteInvoice(tInvoiceId))
            .thenAnswer((_)=>Future.value([tInvoiceModel]));
        // act
        final result = await dataSource.getConcreteInvoice(tInvoiceId);
        // assert
        expect(result, equals([tInvoiceModel]));
      },
    );


  });

  group('getAllInvoices', () {
    final tInvoiceModel = InvoiceDTO.fromJson(json.decode(fixture('invoice.json')));
    test('should perform a GET request on a URL to get all invoices being the endpoint with application/json header',
        () async {
      //arrange
          when(dataSource.getAllInvoices())
              .thenAnswer((_)=>Future.value([tInvoiceModel]));
      //act
          final result = await dataSource.getAllInvoices();
      //assert
          expect(result, equals([tInvoiceModel]));
    });

  });
}
