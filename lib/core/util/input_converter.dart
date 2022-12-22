import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/failure.dart';

class InputConverter {
  Either<Failure, String> inputToString(String str) {
    try {
      final string = str.toString();
      if (string.runtimeType != String) throw const FormatException();
      return Right(string);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
