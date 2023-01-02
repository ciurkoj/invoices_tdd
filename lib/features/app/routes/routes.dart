import 'package:flutter/widgets.dart';
import 'package:invoices_tdd/features/app/bloc/app_bloc.dart';
import 'package:invoices_tdd/features/home/view/home_page.dart';
import 'package:invoices_tdd/features/login/view/login_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
