import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/old_trips/cubit/old_trip_cubit.dart';
import 'package:mishwar/presentation/old_trips/cubit/old_trip_state.dart';
import 'package:mishwar/presentation/old_trips/page/widget/old_trip_page_card.dart';

class OldTripPage extends StatelessWidget {
  final int driverId;
  const OldTripPage({super.key, required this.driverId});
  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return BlocProvider(
      create: (_) =>
          OldTripCubit(repository: ApiTripRepository())
            ..fetchDriverOldTrips(driverId),
      child: Scaffold(
        backgroundColor: appColors.primary,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Text(
                S.of(context).OldTrips,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.secondary,
                ),
              ),
              Expanded(
                child: BlocBuilder<OldTripCubit, OldTripState>(
                  builder: (context, state) {
                    if (state is OldTripLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is OldTripError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is OldTripLoaded) {
                      final trips = state.trips.data.trips;
                      return GridView.builder(
                        itemCount: trips.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1.9,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            color: appColors.white,
                            child: OldTripPageCard(trip: trips[index]),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
