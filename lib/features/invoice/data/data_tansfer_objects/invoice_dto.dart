import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart';

class InvoiceDTO extends InvoiceEntity {
  const InvoiceDTO({required super.invoiceId, required super.vat});

  // const InvoiceModel({
  //   required String invoiceId,
  //   required int vat,
  // }) : super(
  //         invoiceId: invoiceId,
  //         vat: vat,
  //       );

  factory InvoiceDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceDTO(
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
