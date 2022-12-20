import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/network/network_info.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_local_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_remote_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/models/invoice_model.dart';
import 'package:invoices_tdd/features/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'invoice_repository_impl_test.mocks.dart';

@GenerateMocks([NetworkInfo])
@GenerateMocks([
  InvoiceRemoteDataSource,
  InvoiceLocalDataSource
], customMocks: [
  MockSpec<InvoiceRemoteDataSource>(as: #MockRemoteDataSource, onMissingStub: OnMissingStub.returnDefault),
  MockSpec<InvoiceLocalDataSource>(as: #MockLocalDataSource, onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  late InvoiceRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = InvoiceRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteInvoice', () {
    const tInvoiceId = "1";
    const tInvoiceModel = InvoiceModel(invoiceId: tInvoiceId, vat: 0);
    const Invoice tInvoice = tInvoiceModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repositoryImpl.getConcreteInvoice(tInvoiceId);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        //arrange
        when(mockRemoteDataSource.getConcreteInvoice(any)).thenAnswer((_) async => tInvoiceModel);
        //act
        final result = await repositoryImpl.getConcreteInvoice(tInvoiceId);
        //assert
        verify(mockRemoteDataSource.getConcreteInvoice(tInvoiceId));
        expect(result, equals(const Right(tInvoice)));
      });
      test('should cache the data locally when the call to remote data source is successful', () async {
        //arrange
        when(mockRemoteDataSource.getConcreteInvoice(any)).thenAnswer((_) async => tInvoiceModel);
        //act
        await repositoryImpl.getConcreteInvoice(tInvoiceId);
        //assert
        verify(mockRemoteDataSource.getConcreteInvoice(tInvoiceId));
        verify(mockLocalDataSource.cacheInvoice(tInvoiceModel));
      });
      test('should return serverfailure when the call to remote data source is successful', () async {
        //arrange
        when(mockRemoteDataSource.getConcreteInvoice(any)).thenThrow(ServerException());
        //act
        final result = await repositoryImpl.getConcreteInvoice(tInvoiceId);
        //assert
        verify(mockRemoteDataSource.getConcreteInvoice(tInvoiceId));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        //arrange
        when(mockLocalDataSource.getLastInvoice()).thenAnswer((_) async => tInvoiceModel);
        //act
        final result = await repositoryImpl.getConcreteInvoice(tInvoiceId);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastInvoice());
        expect(result, equals(const Right(tInvoice)));
      });
      test('should return CacheFailure when there is no cached data present', () async {
        //arrange
        when(mockLocalDataSource.getLastInvoice()).thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getConcreteInvoice(tInvoiceId);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastInvoice());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getALLInvoices', () {
    const tInvoiceId = "1";
    const tInvoiceModelList = [
      InvoiceModel(invoiceId: tInvoiceId, vat: 0),
      InvoiceModel(invoiceId: tInvoiceId, vat: 0)
    ];
    const List<Invoice> tInvoice = tInvoiceModelList;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repositoryImpl.getAllInvoices();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        //arrange
        when(mockRemoteDataSource.getAllInvoices()).thenAnswer((_) async => tInvoiceModelList);
        //act
        final result = await repositoryImpl.getAllInvoices();
        //assert
        verify(mockRemoteDataSource.getAllInvoices());
        expect(result, equals(const Right(tInvoice)));
      });
      test('should cache the data locally when the call to remote data source is successful', () async {
        //arrange
        when(mockRemoteDataSource.getAllInvoices()).thenAnswer((_) async => tInvoiceModelList);
        //act
        await repositoryImpl.getAllInvoices();
        //assert
        verify(mockRemoteDataSource.getAllInvoices());
        verify(mockLocalDataSource.cacheInvoiceList(tInvoiceModelList));
      });
      test('should return serverfailure when the call to remote data source is successful', () async {
        //arrange
        when(mockRemoteDataSource.getAllInvoices()).thenThrow(ServerException());
        //act
        final result = await repositoryImpl.getAllInvoices();
        //assert
        verify(mockRemoteDataSource.getAllInvoices());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached invoices when the cached invoices is present', () async {
        //arrange
        when(mockLocalDataSource.getAllCachedInvoices()).thenAnswer((_) async => tInvoiceModelList);
        //act
        final result = await repositoryImpl.getAllInvoices();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getAllCachedInvoices());
        expect(result, equals(const Right(tInvoiceModelList)));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        //arrange
        when(mockLocalDataSource.getAllCachedInvoices()).thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getAllInvoices();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getAllCachedInvoices());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
