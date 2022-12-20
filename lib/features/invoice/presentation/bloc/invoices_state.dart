part of 'invoices_bloc.dart';

abstract class InvoicesState extends Equatable {
  const InvoicesState();

  @override
  List<Object> get props => [];
}

class Empty extends InvoicesState {}

class Loading extends InvoicesState {}

class Loaded extends InvoicesState {
  final Invoice invoice;

  const Loaded({required this.invoice}) : super();
}

class Error extends InvoicesState {
  final String message;

  const Error({required this.message}) : super();
}
