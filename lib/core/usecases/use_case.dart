import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:invoices_tdd/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class Params extends Equatable {
  final String invoiceId;

  const Params({required this.invoiceId});

  @override
  List<String> get props => [invoiceId];

  String get getInvoiceId => invoiceId;
}