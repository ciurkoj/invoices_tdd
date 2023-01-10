import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_local_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/data_sources/invoice_remote_data_source.dart';
import 'package:invoices_tdd/features/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_all_invoices.dart';
import 'package:invoices_tdd/features/invoice/domain/usecases/get_concrete_invoice.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';

import 'core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/input_converter.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// service locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - NumberTrivia
  sl.registerFactory(() => InvoicesBloc(
        concrete: sl(),
        all: sl(),
        inputConverter: sl(),
      ));


  // Use cases
  sl.registerLazySingleton(() => GetConcreteInvoice(sl()));
  sl.registerLazySingleton(() => GetAllInvoices(sl()));

  // Repository
  sl.registerLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<InvoiceRemoteDataSource>(
      () => InvoiceRemoteDataSourceImpl());

  sl.registerLazySingleton<InvoiceLocalDataSource>(
      () => InvoiceLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
