import 'package:flutter/material.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';

class InvoiceDisplay extends StatelessWidget {
  final InvoiceEntity invoice;

  const InvoiceDisplay({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            invoice.vat.toString(),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  invoice.invoiceId,
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
