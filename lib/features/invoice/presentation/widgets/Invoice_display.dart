import 'package:flutter/material.dart';
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';

class InvoiceDisplay extends StatelessWidget {
  final List<InvoiceEntity> invoices;

  const InvoiceDisplay({
    Key? key,
    required this.invoices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildInvoices(invoices: invoices);
  }
  Widget buildInvoices({required List<InvoiceEntity> invoices}) =>
      ListView.builder(
        shrinkWrap:true,
    itemCount: invoices.length,
    itemBuilder: (BuildContext context, int index) {
      return InvoiceCardWidget(
        invoiceId: invoices[index].invoiceId,

        vat: invoices[index].vat.toString(),
      );
    },
  );

}

class InvoiceCardWidget extends StatelessWidget {
  final String invoiceId;
  final String vat;
  const InvoiceCardWidget({Key? key, required this.invoiceId, required this.vat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/invoices_background_logo.png",
                  height: 40,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Invoice Id:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                        Text(invoiceId,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("VAT:", style: TextStyle(color: Colors.black54, fontSize: 20)),
                        Text(vat, style: const TextStyle(color: Colors.black54, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

