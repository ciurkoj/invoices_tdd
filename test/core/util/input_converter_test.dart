import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoices_tdd/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        const str = '123';
        // act
        final result = inputConverter.inputToString(str);
        // assert
        expect(result, const Right("123"));
      },
    );
    test(
      'should return a valid string if the input contains numbers',
      () async {
        // arrange
        const str = '12asda3';
        // act
        final result = inputConverter.inputToString(str);
        // assert
        expect(result, const Right("12asda3"));
      },
    );

    test(
      'should throw an InvalidInputFailure if the given string is invalid and does not contain only numbers and letters',
      () async {
        // arrange
        const str = '12as!@da3';
        // act
        final result = inputConverter.inputToString(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

  });
}
