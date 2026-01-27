import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final ApiTripRepository repository;

  ExchangeCubit({required this.repository}) : super(ExchangeInitial()) {
    print("[ExchangeCubit] Initialized with initial state: $state");
  }

  Future<void> fetchExchange() async {
    print("[ExchangeCubit] fetchExchange() called");
    emit(ExchangeLoading());
    print("[ExchangeCubit] State changed to ExchangeLoading");

    try {
      final response = await repository.getExchange();
      print("[ExchangeCubit] Repository response: $response");

      if (response.successful == true && response.data?.exchange != null) {
        print("[ExchangeCubit] Exchange data found: ${response.data!.exchange}");
        emit(ExchangeSuccess(exchange: response.data!.exchange!));
        print("[ExchangeCubit] State changed to ExchangeSuccess");
      } else {
        print("[ExchangeCubit] Exchange data missing or response unsuccessful");
        emit(ExchangeError(message: "Failed to fetch exchange data"));
        print("[ExchangeCubit] State changed to ExchangeError with message: Failed to fetch exchange data");
      }
    } catch (e, stackTrace) {
      print("[ExchangeCubit] Exception caught: $e");
      print("[ExchangeCubit] Stack trace: $stackTrace");
      emit(ExchangeError(message: "Something went wrong"));
      print("[ExchangeCubit] State changed to ExchangeError with message: Something went wrong");
    }
  }
}
