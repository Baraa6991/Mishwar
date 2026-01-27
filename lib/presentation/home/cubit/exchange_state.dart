import 'package:mishwar/presentation/home/model/exchange_model.dart';

abstract class ExchangeState {}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangeSuccess extends ExchangeState {
  final Exchange exchange;
  ExchangeSuccess({required this.exchange});
}

class ExchangeError extends ExchangeState {
  final String message;
  ExchangeError({required this.message});
}
