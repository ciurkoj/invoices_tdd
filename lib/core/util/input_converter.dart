import 'package:dartz/dartz.dart';
import 'package:invoices_tdd/core/error/failure.dart';

class InputConverter {
  Either<Failure, String> inputToString(String str) {
    try {
      if(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(str)){
        final string = str.toString();
        if (string.runtimeType != String) throw const FormatException();
        return Right(string);
      }else{
        throw const FormatException();
      }

    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
