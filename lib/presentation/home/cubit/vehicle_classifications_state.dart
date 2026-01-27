import 'package:mishwar/presentation/home/model/vehicle_model.dart';

abstract class VehicleClassificationsState {}

class VehicleClassificationsInitial extends VehicleClassificationsState {}

class VehicleClassificationsLoading extends VehicleClassificationsState {}

class VehicleClassificationsSuccess extends VehicleClassificationsState {
  final List<VehicleClassification> classifications;
  VehicleClassificationsSuccess({required this.classifications});
}

class VehicleClassificationsError extends VehicleClassificationsState {
  final String message;
  VehicleClassificationsError({required this.message});
}