import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:invoices_tdd/features/app/app.dart';

import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

// service locator
final slq = GetIt.instance;

Future<void> init() async {
  //! Features - NumberTrivia

  slq.registerFactory(() => AppBloc(authenticationRepository: slq()));

  // Use cases
  slq.registerLazySingleton(() => CacheClient());
  slq.registerLazySingleton(() => FirebaseAuth.instance);
  slq.registerLazySingleton(() => GoogleSignIn());

  slq.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepository(
        cache: slq(),
        firebaseAuth: slq(),
        googleSignIn: slq(),
      ));

}
