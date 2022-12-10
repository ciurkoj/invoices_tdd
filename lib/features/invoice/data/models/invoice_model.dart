import 'package:invoices_tdd/features/invoice/domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  const InvoiceModel({required super.invoiceId, required super.vat});

  // const InvoiceModel({
  //   required String invoiceId,
  //   required int vat,
  // }) : super(
  //         invoiceId: invoiceId,
  //         vat: vat,
  //       );

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceId: json['invoiceId'],
      vat: (json['vat'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "invoiceId": invoiceId,
      "vat": vat
    };
  }

}
