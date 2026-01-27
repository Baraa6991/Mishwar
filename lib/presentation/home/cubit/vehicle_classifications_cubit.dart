import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/home/cubit/vehicle_classifications_state.dart';

class VehicleClassificationsCubit extends Cubit<VehicleClassificationsState> {
  final ApiTripRepository repository;

  VehicleClassificationsCubit({required this.repository})
    : super(VehicleClassificationsInitial());

  Future<void> fetchVehicleClassifications(BuildContext context) async {
    emit(VehicleClassificationsLoading());

    try {
      final languageCode =
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'ar';

     
      final response = await repository.getVehicleClassifications(
        languageCode: languageCode,
      );

      if (response.successful == true &&
          response.vehicleClassifications.isNotEmpty) {
        emit(
          VehicleClassificationsSuccess(
            classifications: response.vehicleClassifications,
          ),
        );
      } else {
        emit(
          VehicleClassificationsError(message: S.of(context).ErrorFetchData),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching vehicle classifications: $e');
      debugPrintStack(stackTrace: stackTrace);
      emit(VehicleClassificationsError(message: S.of(context).ErrorFetchData));
    }
  }
}
