// Mocks generated by Mockito 5.3.2 from annotations
// in invoices_tdd/test/features/invoice/domain/usecases/get_concrete_invoice_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:dartz/dartz.dart' as _i4;
import 'package:invoices_tdd/core/error/failure.dart' as _i5;
import 'package:invoices_tdd/features/invoice/domain/entities/invoice_entity.dart'
    as _i6;
import 'package:invoices_tdd/features/invoice/domain/repositories/invoice_repository.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [InvoiceRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockInvoiceRepository extends _i1.Mock implements _i2.InvoiceRepository {
  MockInvoiceRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Either<_i5.Failure, _i6.InvoiceEntity>>? getConcreteInvoice(
          String? invoiceId) =>
      (super.noSuchMethod(Invocation.method(
        #getConcreteInvoice,
        [invoiceId],
      )) as _i3.Future<_i4.Either<_i5.Failure, _i6.InvoiceEntity>>?);
}
