import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/exceptions.dart';
import 'package:invoices_tdd/core/error/failure.dart';
import 'package:invoices_tdd/core/network/network_info.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_local_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_remote_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_tansfer_objects/invoice_dto.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository{
  late final InvoiceRemoteDataSource remoteDataSource;
  late final InvoiceLocalDataSource localDataSource ;
  late final NetworkInfo networkInfo;

  InvoiceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
});
  @override
  Future<Either<Failure, List<InvoiceEntity>>>? getAllInvoices() async {
    return await _getAllInvoices(() {
      return remoteDataSource.getAllInvoices();
    });
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>>? getConcreteInvoice(String invoiceId) async{
    return await _getConcreteInvoice(() {
      return remoteDataSource.getConcreteInvoice(invoiceId);
    });
  }

  Future<Either<Failure, List<InvoiceEntity>>> _getConcreteInvoice(
      _ConcreteFromRemoteOrCache getConcreteFromRemoteOrCache) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInvoice = await getConcreteFromRemoteOrCache();
        localDataSource.cacheInvoice(remoteInvoice);
        return Right(remoteInvoice);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final List<InvoiceDTO> localTrivia = await localDataSource.getLastInvoice() ?? [];
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  Future<Either<Failure, List<InvoiceEntity>>> _getAllInvoices(
      _AllFromRemoteOrCache getAllFromRemoteOrCache) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInvoices = await getAllFromRemoteOrCache();
        localDataSource.cacheInvoiceList(remoteInvoices);
        return Right(remoteInvoices);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localInvoices = await localDataSource.getAllCachedInvoices();
        return Right(localInvoices!);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

typedef _ConcreteFromRemoteOrCache = Future<List<InvoiceDTO>> Function();
typedef _AllFromRemoteOrCache = Future<List<InvoiceDTO>> Function();
