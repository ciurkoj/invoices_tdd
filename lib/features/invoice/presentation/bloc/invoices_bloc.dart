import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';

part 'invoices_event.dart';
part 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  InvoicesBloc(super.initialState);
}
