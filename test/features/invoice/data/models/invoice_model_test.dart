import "dart:convert";

import "package:flutter_test/flutter_test.dart";

import "package:invoices_tdd/features/invoice/data/models/invoice_model.dart";

import "../../../../fixtures/fixture_reader.dart";

void main() {
  const tInvoiceModel = InvoiceModel(invoiceId: "1", vat: 1);

  test(
    'should be a subclass of Invoice entity ',
    () async {
      // assert
      expect(tInvoiceModel, isA<InvoiceModel>());
    },
  );

  group('fromJson', (){
    test(
      'should return a valid model when the vat number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            jsonDecode(fixture("invoice.json"));
        // act
        final result = InvoiceModel.fromJson(jsonMap);
        // assert
        expect(result, tInvoiceModel);
      },
    );

    test(
      'should return a valid model when the vat number is a double',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap =
        jsonDecode(fixture("invoice_double.json"));
        // act
        final result = InvoiceModel.fromJson(jsonMap);
        // assert
        expect(result, tInvoiceModel);
      },
    );
  });

  group('toJson', (){
    test(
      'should return a valid json map containing the proper data',
          () async {
        // act
        final result = tInvoiceModel.toJson();
        // assert
        final expectedMap = {
          "invoiceId": "1",
          "vat": 1
        };
        expect(result, expectedMap);
      },
    );

  });

}
