import 'dart:convert';

import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_local_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'invoice_local_data_soucre_test.mocks.dart';

@GenerateMocks([
  SharedPreferences,
  InvoiceLocalDataSourceImpl
])
void main() {
  late InvoiceLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = InvoiceLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastInvoice', () {
    final tInvoiceModel = InvoiceDTO.fromJson(json.decode(fixture('invoice_cached.json')));
    test('should return Invoice from SharedPreferences when there is one in the cache', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('invoice_cached.json'));
      //act
      final result = await dataSource.getLastInvoice();
      //assert
      verify(mockSharedPreferences.getString(CACHED_LAST_INVOICE));
      expect(result, equals(tInvoiceModel));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastInvoice;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('getAllInvoices', () {

    Map<String, dynamic> jsonDecoded = json.decode(fixture('all_invoices_cached.json'));
    final List<InvoiceDTO> tInvoiceModelList = (jsonDecoded['CACHED_INVOICES'] as List).map((element)=>InvoiceDTO.fromJson(element)).toList();//.map((element) => InvoiceDTO.fromJson(element)).toList();
    test('should return List of Invoices from SharedPreferences when there is one in the cache', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('all_invoices_cached.json'));
      //act
      final result = await dataSource.getAllCachedInvoices();
      //assert
      verify(mockSharedPreferences.getString(CACHED_INVOICES));
      expect(result, equals(tInvoiceModelList));
    });

    test('should throw a CacheException when there is no cached invoice list', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getAllCachedInvoices;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheInvoice', () {
    const tInvoiceModel = InvoiceDTO(vat: 1, invoiceId: "Test text");
    test('should call SharedPreferences to cache the data', () async {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      //act
      dataSource.cacheInvoice([tInvoiceModel]);
      //assert
      final expectedJsonString = json.encode(tInvoiceModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_LAST_INVOICE, expectedJsonString));
    });
  });

  group('cacheAllInvoices', () {
    const List<InvoiceDTO> tInvoiceModelList = [InvoiceDTO(vat: 1, invoiceId: "Test text"),InvoiceDTO(vat: 1, invoiceId: "Test text")];
    test('should call SharedPreferences to cache the data', () async {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      //act
      dataSource.cacheInvoiceList(tInvoiceModelList);
      //assert
      final expectedJsonString = json.encode(tInvoiceModelList);
      verify(mockSharedPreferences.setString(CACHED_INVOICES, expectedJsonString));
    });
  });
}
