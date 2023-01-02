import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';
import 'package:invoices_tdd/features/invoice/presentation/widgets/message_display.dart';
import 'package:invoices_tdd/injection_container.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  InvoicesPageState createState() => InvoicesPageState();
}

class InvoicesPageState extends State<InvoicesPage> {
  bool isLoading = false;
  String? searchByValue;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<InvoicesBloc> buildBody(BuildContext context) {
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
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    // return LoadingWidget();
                  } else if (state is Loaded) {
                    // return InvoiceDisplay(invoice: state.invoice.first);
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
              // SizedBox(height: 20),
              // Bottom half
            ],
          ),
        ),
      ),
    );
  }
}
