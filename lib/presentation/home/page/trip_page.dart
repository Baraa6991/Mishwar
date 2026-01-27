import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/Theme/Localization/localization.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/main_widget/SnackBar.dart';
import 'package:mishwar/presentation/home/cubit/check_end_cubit.dart';
import 'package:mishwar/presentation/home/cubit/exchange_cubit.dart';
import 'package:mishwar/presentation/home/cubit/exchange_state.dart';
import 'package:mishwar/presentation/home/cubit/trip_cubit.dart';
import 'package:mishwar/presentation/home/cubit/trip_state.dart';
import 'package:mishwar/presentation/home/widget/menu_bottom_sheet.dart';
import 'package:mishwar/presentation/home/widget/search_bar_with_menu.dart';
import 'package:mishwar/presentation/home/widget/car_selector_row.dart';
import 'package:mishwar/presentation/home/widget/order_button.dart';
import 'package:mishwar/presentation/home/widget/trip_dailog.dart';
import 'package:mishwar/presentation/login/cubit/TokenManager.dart';
import 'package:mishwar/presentation/old_trips/cubit/old_trip_cubit.dart';
import 'package:mishwar/presentation/old_trips/page/old_trip_page.dart';
import 'package:mishwar/presentation/profile/page/profile_page.dart';
import 'package:mishwar/presentation/setting_page/page/setting_page.dart';
import 'package:mishwar/services/map_service.dart';

import 'package:mishwar/presentation/home/cubit/vehicle_classifications_cubit.dart';
import 'package:mishwar/presentation/home/cubit/vehicle_classifications_state.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  @override
  void initState() {
    super.initState();
    // ✅ التأكد من أن TokenManager يعمل
    TokenManager.instance.startAutoRefresh(intervalMinutes: 20);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ExchangeCubit(repository: ApiTripRepository())..fetchExchange(),
        ),
        BlocProvider(create: (_) => CheckEndCubit(ApiTripRepository())),
        BlocProvider(
          create: (context) => TripCubit(
            mapService: MapService(),
            exchangeCubit: context.read<ExchangeCubit>(),
          )..initCurrentLocation(),
        ),
        BlocProvider(
          create: (_) =>
              VehicleClassificationsCubit(repository: ApiTripRepository())
                ..fetchVehicleClassifications(context),
        ),
      ],
      child: const _HomeMapContent(),
    );
  }
}

// =================== CONTENT WIDGET =====================
class _HomeMapContent extends StatefulWidget {
  const _HomeMapContent();

  @override
  State<_HomeMapContent> createState() => _HomeMapContentState();
}

class _HomeMapContentState extends State<_HomeMapContent> {
  final MapService mapService = MapService();
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  bool _locationInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_locationInitialized) {
      // استخدام addPostFrameCallback لتجنب مشاكل الـ build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<TripCubit>();
        dev.log(
          "[HomeMapPage] Initializing current location",
          name: "HomeMapPage",
        );
        cubit.initCurrentLocation().then((_) {
          dev.log(
            "[HomeMapPage] Current location initialized",
            name: "HomeMapPage",
          );
          _goToCurrentLocation();
        });
      });
      _locationInitialized = true;
    }
  }

  Future<void> _goToCurrentLocation() async {
    final cubit = context.read<TripCubit>();
    final loc = cubit.state.currentLocation;
    dev.log(
      "[HomeMapPage] Moving camera to current location: $loc",
      name: "HomeMapPage",
    );
    if (loc != null && _mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newLatLngZoom(loc, 15));
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<ThemeCubit>().state;

    return BlocListener<LocaleCubit, Locale>(
      listener: (context, locale) {
        dev.log("[HomeMapPage] Locale changed: $locale", name: "HomeMapPage");
        context.read<VehicleClassificationsCubit>().fetchVehicleClassifications(
          context,
        );
      },
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, state) {
          final cubit = context.read<TripCubit>();
          dev.log(
            "[HomeMapPage] Building HomeMapPage with state: $state",
            name: "HomeMapPage",
          );

          return Scaffold(
            backgroundColor: appColors.white,
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        state.currentLocation ??
                        const LatLng(31.963158, 35.930359),
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    dev.log(
                      "[HomeMapPage] GoogleMap created",
                      name: "HomeMapPage",
                    );
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onTap: (point) {
                    dev.log(
                      "[HomeMapPage] Map tapped at: $point",
                      name: "HomeMapPage",
                    );
                    cubit.setDestinationWithPrice(point);
                  },
                  polylines: state.polylines,
                  markers: {
                    if (state.currentLocation != null)
                      Marker(
                        markerId: const MarkerId('current'),
                        position: state.currentLocation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                        infoWindow: InfoWindow(
                          title: S.of(context).CurrentLocation,
                        ),
                      ),
                    if (state.destination != null)
                      Marker(
                        markerId: const MarkerId('dest'),
                        position: state.destination!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                        infoWindow: InfoWindow(
                          title: S.of(context).Destination,
                        ),
                      ),
                  },
                ),

                Positioned(
                  top: 50.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    children: [
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: appColors.primary,
                        onPressed: () {
                          dev.log(
                            "[HomeMapPage] Menu button pressed",
                            name: "HomeMapPage",
                          );
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: appColors.white,
                            builder: (_) => MenuBottomSheet(
                              onHistoryTap: () {
                                final userId = CacheHelper.getData(
                                  key: "user_id",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (_) => OldTripCubit(
                                            repository: ApiTripRepository(),
                                          ),
                                        ),
                                      ],
                                      child: OldTripPage(driverId: userId),
                                    ),
                                  ),
                                );
                              },
                              onProfileTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfilePage(),
                                  ),
                                ).then((_) {
                                  // إزالة setState - BLoC سيتولى التحديث تلقائياً
                                  context
                                      .read<VehicleClassificationsCubit>()
                                      .fetchVehicleClassifications(context);
                                  context
                                      .read<TripCubit>()
                                      .initCurrentLocation();
                                });
                              },
                              onSettingsTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SettingPage(),
                                  ),
                                ).then((_) {
                                  // إزالة setState - BLoC سيتولى التحديث تلقائياً
                                  context
                                      .read<VehicleClassificationsCubit>()
                                      .fetchVehicleClassifications(context);
                                  context
                                      .read<TripCubit>()
                                      .initCurrentLocation();
                                });
                              },
                            ),
                          );
                        },
                        child: Icon(Icons.menu, color: appColors.secondary),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: SearchBarWithMenu(
                          controller: _searchController,
                          onMenuTap: () {},
                          onSubmitted: (query) {
                            dev.log(
                              "[HomeMapPage] Search submitted: $query",
                              name: "HomeMapPage",
                            );
                            cubit.searchPlace(query, _mapController);
                          },
                          onSearchTap: () {
                            dev.log(
                              "[HomeMapPage] Search button tapped",
                              name: "HomeMapPage",
                            );
                            cubit.searchPlace(
                              _searchController.text,
                              _mapController,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= CURRENT LOCATION BUTTON =================
                Positioned(
                  bottom: 200.h,
                  left: 16.w,
                  child: FloatingActionButton(
                    heroTag: "loc",
                    mini: true,
                    onPressed: _goToCurrentLocation,
                    backgroundColor: appColors.primary,
                    child: Icon(Icons.my_location, color: appColors.secondary),
                  ),
                ),

                // ================= BOTTOM SHEET =================
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: appColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      boxShadow: [
                        BoxShadow(color: appColors.black, blurRadius: 8.r),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<
                          VehicleClassificationsCubit,
                          VehicleClassificationsState
                        >(
                          builder: (context, vState) {
                            dev.log(
                              "[HomeMapPage] VehicleClassifications state: $vState",
                              name: "HomeMapPage",
                            );

                            if (vState is VehicleClassificationsLoading) {
                              return Center(
                                child: SpinKitThreeBounce(
                                  color: appColors.secondary,
                                  size: 40.sp,
                                ),
                              );
                            }

                            if (vState is VehicleClassificationsError) {
                              dev.log(
                                "[HomeMapPage] VehicleClassificationsError: ${vState.message}",
                                name: "HomeMapPage",
                              );
                              return Center(child: Text(vState.message));
                            }

                            if (vState is VehicleClassificationsSuccess) {
                              return CarSelectorRow(
                                selectedCar: state.selectedCar,
                                cars: vState.classifications,
                                carsPrices: state.carsPrices,
                                onCarSelected: (car) {
                                  context.read<TripCubit>().selectCar(car);
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),

                        SizedBox(height: 20.h),

                        OrderButton(
                          enabled:
                              state.destination != null &&
                              !state.isRequestingRide,
                          onPressed: () async {
                            final trip = context.read<TripCubit>();
                            final exchange = context
                                .read<ExchangeCubit>()
                                .state;
                            final vehicle = context
                                .read<VehicleClassificationsCubit>()
                                .state;
                            final checkEndCubit = context.read<CheckEndCubit>();

                            final userId =
                                CacheHelper.getData(
                                  key: "user_id",
                                )?.toString() ??
                                "";
                            final token =
                                CacheHelper.getData(key: "token") ?? "";

                            if (exchange is! ExchangeSuccess ||
                                vehicle is! VehicleClassificationsSuccess) {
                              AppSnackBar.show(
                                context,
                                S.of(context).PleaseWaitForData,
                                success: true,
                              );
                              return;
                            }

                            const arabicToEnglish = {
                              'دراجة نارية': 'bike',
                              'سيارة بمكيف': 'car with ac',
                              'سيارة بدون مكيف': 'car without ac',
                              'سيارة فاخرة': 'luxury car',
                              'شاحنة صغيرة': 'mini truck',
                              'فان': 'van',
                            };

                            final selectedCar = trip.state.selectedCar;
                            final englishCarName =
                                arabicToEnglish[selectedCar] ?? selectedCar;
                            final carInfo = vehicle.classifications.firstWhere(
                              (e) =>
                                  e.vehicleType == selectedCar ||
                                  e.vehicleType == englishCarName,
                            );

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider<CheckEndCubit>.value(
                                      value: checkEndCubit,
                                    ),
                                  ],
                                  child: FindDriverDialog(
                                    params: {
                                      "repo": ApiTripRepository(),
                                      "tripCubit": trip,
                                      "sourceList": [
                                        trip.state.currentLocation!.latitude,
                                        trip.state.currentLocation!.longitude,
                                      ],
                                      "sourceIon": "source-location",
                                      "userId": userId,
                                      "vehicleId": carInfo.id.toString(),
                                      "destinationList": [
                                        trip.state.destination!.latitude,
                                        trip.state.destination!.longitude,
                                      ],
                                      "destinationIon": "destination-location",
                                      "dollarPrice":
                                          trip
                                              .state
                                              .carsPrices[englishCarName] ??
                                          1.0,
                                      "sysPrice": 1.0,
                                      "kmNumber":
                                          trip.mapService.estimatedDistanceKm ??
                                          0.0,
                                      "duration":
                                          trip
                                              .mapService
                                              .estimatedDurationMin ??
                                          0.0,
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
