import 'dart:convert';

import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/core/util/constants.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_remote_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'invoice_remote_data_source_test.mocks.dart';

@GenerateMocks([InvoiceRemoteDataSourceImpl, http.Client])
void main() {
  late InvoiceRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = InvoiceRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('invoice.json'), 200));
  }
  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group('getConcreteInvoice', () {
    const tInvoiceId = "1";
    final tInvoiceModel = InvoiceDTO.fromJson(json.decode(fixture('invoice.json')));

    test('should perform a GET request on a URL with invoice id being the endpoint with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getConcreteInvoice(tInvoiceId);
      //assert
      verify(mockClient.get(Uri.parse("${Constants.URL}/$tInvoiceId"), headers: {'Content-Type': 'application/json'}));
    });

    test(
      'should return Imvoice when the response is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getConcreteInvoice(tInvoiceId);
        // assert
        expect(result, equals(tInvoiceModel));
      },
    );

    test(
      'should throw a Server Exception when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteInvoice;
        // assert
        expect(call(tInvoiceId), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getAllInvoices', () {
    test('should perform a GET request on a URL to get all invoices being the endpoint with application/json header',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('all_invoices_cached.json'), 200));
      //act
      dataSource.getAllInvoices();
      //assert
      verify(mockClient.get(Uri.parse("${Constants.URL}/random"), headers: {'Content-Type': 'application/json'}));
    });

    test(
      'should throw a Server Exception when the response code is 404 or other',
          () async {
        // arrange
            when(mockClient.get(any, headers: anyNamed('headers')))
                .thenAnswer((_) async => http.Response("Something went wrong", 404));
        // act
        final call = dataSource.getAllInvoices();
        // assert
        expect(call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
