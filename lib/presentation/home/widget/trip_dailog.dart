import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/main_widget/SnackBar.dart';
import 'package:mishwar/presentation/home/cubit/cansel_trip_cubit.dart';
import 'package:mishwar/presentation/home/cubit/cansel_trip_state.dart';
import 'package:mishwar/presentation/home/cubit/check_end_cubit.dart';
import 'package:mishwar/presentation/home/cubit/check_end_state.dart';
import 'package:mishwar/presentation/home/cubit/exprition_trip_cubit.dart';
import 'package:mishwar/presentation/home/cubit/exprition_trip_state.dart';
import 'package:mishwar/presentation/home/cubit/find_driver_cubit.dart';
import 'package:mishwar/presentation/home/cubit/find_driver_state.dart';
import 'package:mishwar/presentation/home/cubit/trip_cubit.dart';

class FindDriverDialog extends StatelessWidget {
  final Map<String, dynamic> params;

  const FindDriverDialog({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> waitingText = ValueNotifier(
      S.of(context).SearchingForDriver,
    );

    final theme = Theme.of(context);

    dev.log("[FindDriverDialog] Dialog opened with params: $params");

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CheckEndCubit(params['repo'])),
        BlocProvider(create: (_) => CancelTripCubit(params['repo'])),
        BlocProvider(create: (_) => CheckTripStatusCubit(params['repo'])),
        BlocProvider<RateTripCubit>.value(value: RateTripCubit(params['repo'])),

        BlocProvider(
          create: (context) {
            final cubit = FindDriversCubit(
              repository: params['repo'],
              checkEndCubit: context.read<CheckEndCubit>(),
            );

            cubit.findDrivers(
              sourceList: params['sourceList'],
              sourceIon: params['sourceIon'],
              userId: params['userId'],
              vehicleClassificationsId: params['vehicleId'],
              destinationList: params['destinationList'],
              destinationIon: params['destinationIon'],
              dollarPrice: params['dollarPrice'],
              sysPrice: params['sysPrice'],
              kmNumber: params['kmNumber'],
              duration: params['duration'],
            );

            return cubit;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<FindDriversCubit, FindDriversState>(
                listener: (context, state) {
                  dev.log(
                    "[FindDriverDialog] FindDriversState changed: $state",
                  );

                  if (state is FindDriversSuccess) {
                    final userId = params['userId'];
                    context.read<CheckTripStatusCubit>().startCheckingStatus(
                      userId,
                    );
                  }

                  if (state is FindDriversError) {
                    Navigator.pop(context);
                    AppSnackBar.show(context, state.message, success: false);
                  }
                },
              ),
              BlocListener<CheckTripStatusCubit, CheckTripStatusState>(
                listener: (context, checkState) {
                  if (checkState is CheckTripAccepted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      waitingText.value = S.of(context).DriverFound;
                    });

                    params['driver'] = checkState.driverData;
                    final tripId = checkState.tripId;
                    params['tripId'] = tripId;

                    // ✅ احصل على جميع البيانات المطلوبة
                    final driverId = checkState.driverData['id'];
                    final userId = int.parse(params['userId'].toString());

                    // ✅ احفظ في الكاش
                    CacheHelper.saveData(key: "driver_id", value: driverId);
                    CacheHelper.saveData(key: "trip_id", value: tripId);

                    // ✅ عين جميع البيانات في RateTripCubit
                    context.read<RateTripCubit>().setTripData(
                      driverId: driverId,
                      userId: userId,
                      tripId: tripId,
                    );

                    dev.log(
                      "[FindDriverDialog] Set trip data - driverId: $driverId, userId: $userId, tripId: $tripId",
                    );

                    context.read<CheckEndCubit>().startCheckingTrip(tripId);
                  }
                },
              ),
              BlocListener<CheckEndCubit, CheckEndState>(
                listener: (context, endState) {
                  dev.log(
                    "[FindDriverDialog] CheckEndState changed: $endState",
                  );

                  if (endState is CheckEndSuccess) {
                    final trip = endState.checkEndData;
                    dev.log(
                      "[FindDriverDialog] Trip status: ${trip['trip_status']}",
                    );
                    if (trip["trip_status"] == "cancelled") {
                      context.read<CheckEndCubit>().stopChecking();
                      context.read<CheckTripStatusCubit>().stopChecking();

                      Navigator.pop(context);
                      AppSnackBar.show(
                        context,
                        S.of(context).TripCancelled,
                        success: true,
                      );
                      (params['tripCubit'] as TripCubit).resetTrip();
                      return;
                    }

                    if (trip["trip_status"] == "completed") {
                      final rateCubit = context.read<RateTripCubit>();

                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) {
                          double rating = 0;
                          final commentController = TextEditingController();

                          return BlocProvider.value(
                            value: rateCubit,
                            child: BlocConsumer<RateTripCubit, RateTripState>(
                              listener: (context, state) {
                                if (state is RateTripSuccess) {
                                  Navigator.pop(dialogContext);
                                  AppSnackBar.show(
                                    context,
                                    state.message,
                                    success: true,
                                  );
                                  (params['tripCubit'] as TripCubit)
                                      .resetTrip();
                                } else if (state is RateTripError) {
                                  AppSnackBar.show(
                                    context,
                                    state.message,
                                    success: false,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  title: Text(
                                    S.of(context).RateTrip,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        S.of(context).HowWasYourExperience,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20.h),
                                      RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 1,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 40.sp,
                                        glowColor: Colors.amber,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          rating = value;
                                        },
                                      ),
                                      SizedBox(height: 20.h),
                                      TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintText: S.of(context).AddComment,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: state is RateTripLoading
                                          ? null
                                          : () => Navigator.pop(dialogContext),
                                      child: Text(S.of(context).Skip),
                                    ),
                                    ElevatedButton(
                                      onPressed: state is RateTripLoading
                                          ? null
                                          : () async {
                                              if (rating == 0) {
                                                AppSnackBar.show(
                                                  context,
                                                  S
                                                      .of(context)
                                                      .PleaseSelectRating,
                                                  success: true,
                                                );
                                                return;
                                              }

                                              await context
                                                  .read<RateTripCubit>()
                                                  .rateTrip(
                                                    rating,
                                                    comment:
                                                        commentController
                                                            .text
                                                            .isEmpty
                                                        ? null
                                                        : commentController
                                                              .text,
                                                  );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                      ),
                                      child: state is RateTripLoading
                                          ? SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: SpinKitThreeBounce(
                                                color: Colors.yellow,
                                                size: 10.sp,
                                              ),
                                            )
                                          : Text(
                                              S.of(context).Send,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      );
                      context.read<CheckEndCubit>().stopChecking();
                      context.read<CheckTripStatusCubit>().stopChecking();
                    }
                  }
                },
              ),
            ],
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: waitingText,
                        builder: (_, value, __) {
                          return Text(
                            value,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColorDark,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      BlocBuilder<CheckTripStatusCubit, CheckTripStatusState>(
                        builder: (context, state) {
                          if (state is CheckTripWaiting ||
                              state is CheckTripLoading ||
                              state is CheckTripInitial) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: LinearProgressIndicator(
                                minHeight: 6.h,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.primaryColor,
                                ),
                              ),
                            );
                          }

                          if (state is CheckTripAccepted) {
                            return Column(
                              children: [
                                SizedBox(height: 20.h),
                                _driverInfoCard(state.driverData),
                                SizedBox(height: 20.h),
                              ],
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                      SizedBox(height: 30.h),
                      BlocConsumer<CancelTripCubit, CancelTripState>(
                        listener: (context, state) {
                          if (state is CancelTripSuccess) {
                            context.read<CheckTripStatusCubit>().stopChecking();
                            context.read<CheckEndCubit>().stopChecking();

                            Navigator.pop(context);
                            AppSnackBar.show(
                              context,
                              state.message,
                              success: true,
                            );
                            (params['tripCubit'] as TripCubit).resetTrip();
                          } else if (state is CancelTripError) {
                            AppSnackBar.show(
                              context,
                              state.message,
                              success: false,
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state is CancelTripLoading
                                  ? null
                                  : () {
                                      final tripId = params['tripId']
                                          ?.toString();
                                      context
                                          .read<CancelTripCubit>()
                                          .cancelTrip(tripId: tripId);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                              child: state is CancelTripLoading
                                  ? SpinKitThreeBounce(
                                      color: Colors.red,
                                      size: 40.sp,
                                    )
                                  : Text(
                                      S.of(context).Cancel,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _driverInfoCard(Map<String, dynamic> driver) {
  return Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.grey.shade200,
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: SizedBox(
            width: 60.w,
            height: 60.h,
            child: Image.network(
              driver["photo"] ?? "",
              errorBuilder: (_, __, ___) => Image.asset("assets/مشوار.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver["name"],
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              Text("📞 ${driver["phone"]}"),
              Text("🚗 ${driver["vehicle_Details"]["type"]}"),
              Text("🔢 رقم السيارة: ${driver["vehicle_Details"]["number"]}"),
            ],
          ),
        ),
      ],
    ),
  );
}
