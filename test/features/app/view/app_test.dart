import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoices_tdd/features/app/app.dart';
import 'package:invoices_tdd/features/home/home.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';
import 'package:invoices_tdd/features/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/injection_container.dart' as ic;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_test.dart';

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockInvoicesBloc extends MockBloc<InvoicesEvent, InvoicesState> implements InvoicesBloc {}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late User user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    testWidgets('renders AppView', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await ic.init();
      setupFirebaseAuthMocks();
      await Firebase.initializeApp();
      await tester.pumpWidget(
        App(authenticationRepository: authenticationRepository),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AuthenticationRepository authenticationRepository;
    late AppBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
