import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoices_tdd/features/app/bloc/app_bloc.dart';
import 'package:invoices_tdd/features/home/widgets/avatar.dart';
import 'package:invoices_tdd/features/invoice/presentation/pages/invoices_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          )
        ],
      ),
      // body:NumberTriviaPage()
      body: ListView(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(child: Avatar(photo: user.photo)),
          const SizedBox(height: 4),
          Text(user.email ?? '', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(user.name ?? '', style: textTheme.headlineMedium),
          const NumberTriviaPage()
        ],
      ),
    );
  }
}
