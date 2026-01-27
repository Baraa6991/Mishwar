import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar/presentation/home/cubit/exchange_cubit.dart';
import 'package:mishwar/presentation/home/cubit/exchange_state.dart';
import 'package:mishwar/services/map_service.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final MapService mapService;
  final ExchangeCubit? exchangeCubit;

  Timer? tripTimer;
  int tripSeconds = 0;
  double remainingDistanceKm = 0;
  String remainingDuration = "0 دقيقة";
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  // ✅ Debounce Timer للبحث
  Timer? _debounceTimer;

  TripCubit({required this.mapService, this.exchangeCubit})
    : super(TripState.initial()) {
    dev.log("[TripCubit] Initialized", name: "TripCubit");
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    tripTimer?.cancel();
    return super.close();
  }

  Future<void> initCurrentLocation() async {
    dev.log("[TripCubit] initCurrentLocation called", name: "TripCubit");
    emit(state.copyWith(isLoading: true));
    final location = await mapService.getCurrentLocation();
    if (location != null) {
      dev.log(
        "[TripCubit] Current location obtained: $location",
        name: "TripCubit",
      );
      emit(state.copyWith(currentLocation: location, isLoading: false));
    } else {
      dev.log(
        "[TripCubit] Failed to get location",
        name: "TripCubit",
        level: 1000,
      );
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'فشل في الحصول على الموقع',
        ),
      );
    }
  }

  void setDestination(LatLng dest) async {
    mapService.setDestination(dest);
    emit(state.copyWith(destination: dest));
    await drawRoute();
    _calculateTripPrice();
  }

  void setDestinationWithPrice(LatLng dest) {
    setDestination(dest);
    dev.log(
      "[TripCubit] Calculating price after setting destination",
      name: "TripCubit",
    );
    _calculateTripPrice();
  }

  Future<void> drawRoute() async {
    if (state.currentLocation == null || state.destination == null) {
      dev.log(
        "[TripCubit] Cannot draw route: missing location",
        name: "TripCubit",
      );
      return;
    }
    try {
      dev.log("[TripCubit] drawRoute called", name: "TripCubit");
      await mapService.drawRoute();

      dev.log(
        "[TripCubit] Route drawn. Distance: ${mapService.estimatedDistanceKm ?? 0.0} km",
        name: "TripCubit",
      );

      emit(state.copyWith(polylines: mapService.polylines));
      _calculateTripPrice();
    } catch (e, st) {
      dev.log(
        "[TripCubit] Error drawing route: $e",
        name: "TripCubit",
        error: e,
        stackTrace: st,
      );
    }
  }

  /// ✅ البحث مع Debounce - تحسين الأداء
  void fetchPlaceSuggestionsWithDebounce(String input) {
    _debounceTimer?.cancel();

    if (input.isEmpty) {
      emit(state.copyWith(predictions: []));
      return;
    }

    // انتظار 500ms قبل البحث (تقليل الطلبات)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final suggestions = await mapService.getPlaceSuggestions(input);
      emit(
        state.copyWith(
          predictions: suggestions.map((e) => {'description': e}).toList(),
        ),
      );
    });
  }

  /// ✅ إعادة تعيين البحث والعودة للموقع الحالي
  void resetSearch() {
    _debounceTimer?.cancel();
    mapService.reset();

    emit(
      state.copyWith(
        destination: null,
        polylines: {},
        predictions: [],
        carsPrices: {},
        selectedCar: null,
      ),
    );

    dev.log(
      "[TripCubit] Search reset - back to initial state",
      name: "TripCubit",
    );
  }

  Future<void> searchPlace(
    String query,
    GoogleMapController? controller,
  ) async {
    if (query.trim().isEmpty) return;
    try {
      final result = await mapService.searchPlace(query);
      if (result != null) {
        setDestinationWithPrice(result);
        if (controller != null) {
          await controller.animateCamera(
            CameraUpdate.newLatLngZoom(result, 15),
          );
        }
      }
    } catch (e) {
      dev.log('⚠️ Error searching place: $e', name: "TripCubit");
    }
  }

  void selectCar(String car) {
    dev.log("[TripCubit] Car selected: $car", name: "TripCubit");
    emit(state.copyWith(selectedCar: car));
  }

  void resetTrip() {
    dev.log("[TripCubit] Starting trip reset", name: "TripCubit");

    tripTimer?.cancel();
    tripTimer = null;
    _debounceTimer?.cancel();

    tripSeconds = 0;
    remainingDistanceKm = 0;
    remainingDuration = "0 دقيقة";

    markers.clear();
    polylines.clear();

    mapService.reset(); // ✅ مهم جداً

    emit(
      TripState(
        currentLocation: state.currentLocation, // ✅ نحتفظ بالموقع الحالي فقط
        destination: null, // ✅ نحذف الوجهة
        polylines: {}, // ✅ نحذف الخطوط
        isLoading: false,
        isRequestingRide: false,
        selectedCar: null, // ✅ نحذف السيارة المختارة
        tripPrice: null,
        carsPrices: {}, // ✅ نحذف الأسعار
        predictions: [],
        errorMessage: null,
      ),
    );

    dev.log("[TripCubit] Trip reset completed", name: "TripCubit");
  }

  void _calculateTripPrice() {
    final exchangeState = exchangeCubit?.state;
    if (exchangeState is! ExchangeSuccess) {
      emit(state.copyWith(carsPrices: {}));
      return;
    }

    if (state.currentLocation == null || state.destination == null) {
      return;
    }

    final exchange = exchangeState.exchange;

    final distanceKm = mapService.estimatedDistanceKm ?? 0.0;
    final durationMin = mapService.estimatedDurationMin ?? 0.0;

    final kmCost = exchange.kmCost;
    final minCost = exchange.minCost;

    final Map<String, double> allPrices = {};

    for (var i = 0; i < exchange.vehicleTypes.length; i++) {
      final vehicle = exchange.vehicleTypes[i];
      final String carType = vehicle.vehicleType;
      final vehicleTypePercentage = vehicle.vehicleTypePercentage;

      final distanceCost = distanceKm * kmCost;
      final timeCost = durationMin * minCost;

      final basicTotal = distanceCost + timeCost;

      final vehicleFee = basicTotal * (vehicleTypePercentage / 100);

      double finalPrice = basicTotal + vehicleFee;

      finalPrice = double.parse(finalPrice.toStringAsFixed(2));
      allPrices[carType] = finalPrice;
    }

    emit(state.copyWith(carsPrices: allPrices));

    dev.log("[TripCubit] Calculated prices: $allPrices", name: "TripCubit");
  }
}
