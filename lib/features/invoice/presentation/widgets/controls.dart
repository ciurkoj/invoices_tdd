import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoices_tdd/features/invoice/presentation/bloc/invoices_bloc.dart';

class Controls extends StatefulWidget {
  const Controls({
    Key? key,
  }) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onTapOutside: (_){
            FocusScope.of(context).requestFocus(FocusNode());
            } ,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor:  Theme.of(context).primaryColor,
                ),
                onPressed: dispatchConcrete,
                child: const Text('Search by invoiceId'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: const Text('Get all invoices'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<InvoicesBloc>(context)
        .add(GetInvoiceForConcreteInvoiceId(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<InvoicesBloc>(context).add(GetAllInvoicesEvent());
  }
}
