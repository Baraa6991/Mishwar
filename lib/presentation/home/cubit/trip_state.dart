import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripState {
  final LatLng? currentLocation;
  final LatLng? destination;
  final Set<Polyline> polylines;
  final bool isLoading;
  final bool isRequestingRide;
  final String? selectedCar;
  final double? tripPrice; // لم نعد نحتاجه لاحقًا لكن نبقيه إن أردت
  final Map<String, double> carsPrices;
  final List<Map<String, dynamic>> predictions;
  final String? errorMessage;

  TripState({
    required this.currentLocation,
    required this.destination,
    required this.polylines,
    required this.isLoading,
    required this.isRequestingRide,
    required this.selectedCar,
    required this.tripPrice,
    required this.carsPrices,
    required this.predictions,
    required this.errorMessage,
  });

  factory TripState.initial() {
    return TripState(
      currentLocation: null,
      destination: null,
      polylines: {},
      isLoading: false,
      isRequestingRide: false,
      selectedCar: null,
      tripPrice: null,
      carsPrices: {},
      predictions: [],
      errorMessage: null,
    );
  }

  TripState copyWith({
    LatLng? currentLocation,
    LatLng? destination,
    Set<Polyline>? polylines,
    bool? isLoading,
    bool? isRequestingRide,
    String? selectedCar,
    double? tripPrice,
    Map<String, double>? carsPrices,
    List<Map<String, dynamic>>? predictions,
    String? errorMessage,
  }) {
    return TripState(
      currentLocation: currentLocation ?? this.currentLocation,
      destination: destination ?? this.destination,
      polylines: polylines ?? this.polylines,
      isLoading: isLoading ?? this.isLoading,
      isRequestingRide: isRequestingRide ?? this.isRequestingRide,
      selectedCar: selectedCar ?? this.selectedCar,
      tripPrice: tripPrice ?? this.tripPrice,
      carsPrices: carsPrices ?? this.carsPrices,
      predictions: predictions ?? this.predictions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
