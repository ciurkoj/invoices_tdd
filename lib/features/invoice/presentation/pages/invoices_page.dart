import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';
import 'package:invoices_tdd/features/invoice/presentation/widgets/Invoice_display.dart';
import 'package:invoices_tdd/features/invoice/presentation/widgets/loading_widget.dart';
import 'package:invoices_tdd/features/invoice/presentation/widgets/message_display.dart';
import 'package:invoices_tdd/features/invoice/presentation/widgets/controls.dart';
import 'package:invoices_tdd/injection_container.dart';

class InvoicesPage extends StatelessWidget {
  InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InvoicesBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              // Top half
              BlocBuilder<InvoicesBloc, InvoicesState>(
                builder: (context, state) {
                  if (state is Empty) {
                    context.read<InvoicesBloc>().add(GetAllInvoicesEvent());
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is LoadedSuccess) {
                    return InvoiceDisplay(invoices: state.invoice);
                  } else if (state is Loaded) {
                    return InvoiceDisplay(invoices: state.invoice);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                  return const MessageDisplay(
                    message: 'Start searching!',
                  );
                },
              ),
              const SizedBox(height: 20),
              const Controls()
              // Bottom half
            ],
          ),
        ),
      ),
    );
  }
}
