import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoices_tdd/features/app/app.dart';
import 'package:invoices_tdd/features/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invoices_tdd/injection_container.dart' as ic;

import '../../app/view/firebase_test.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  const logoutButtonKey = Key('homePage_logout_iconButton');
  group('HomePage', () {
    late AppBloc appBloc;
    late User user;

    setUp(() {
      appBloc = MockAppBloc();
      user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    group('calls', () {

      testWidgets('AppLogoutRequested when logout is pressed', (tester) async {
        SharedPreferences.setMockInitialValues({});
        await ic.init();
        setupFirebaseAuthMocks();
        await Firebase.initializeApp();
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        await tester.tap(find.byKey(logoutButtonKey));
        verify(() => appBloc.add(const AppLogoutRequested())).called(1);
      });
    });

    /// temporarily disabled due to design changes
    // group('renders', () {
    //   testWidgets('avatar widget', (tester) async {
    //     await tester.pumpWidget(
    //       BlocProvider.value(
    //         value: appBloc,
    //         child: const MaterialApp(home: HomePage()),
    //       ),
    //     );
    //     expect(find.byType(Avatar), findsOneWidget);
    //   });
    //
    //   testWidgets('email address', (tester) async {
    //     await tester.pumpWidget(
    //       BlocProvider.value(
    //         value: appBloc,
    //         child: const MaterialApp(home: HomePage()),
    //       ),
    //     );
    //     expect(find.text('test@gmail.com'), findsOneWidget);
    //   });
    //
    //   testWidgets('name', (tester) async {
    //     when(() => user.name).thenReturn('Joe');
    //     await tester.pumpWidget(
    //       BlocProvider.value(
    //         value: appBloc,
    //         child: const MaterialApp(home: HomePage()),
    //       ),
    //     );
    //     expect(find.text('Joe'), findsOneWidget);
    //   });
    // });
  });
}
