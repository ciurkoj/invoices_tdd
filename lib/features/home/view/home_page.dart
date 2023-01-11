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
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Drawer(
            key: const Key('homePage_drawer'),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent[700],
                    ),
                    accountName: Text(user.name ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 24)),
                    accountEmail: Text(user.email ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 24)),
                    currentAccountPicture: Center(child: Avatar(photo: user.photo)),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        key: const Key('homePage_logout_iconButton'),
                        onPressed: () => context.read<AppBloc>().add(const AppLogoutRequested()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "Sign out",
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.exit_to_app)
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        // body:NumberTriviaPage()
        body: Column(
          children: [
            Text("test"),
            InvoicesPage(),
          ],
        ));
  }
}
