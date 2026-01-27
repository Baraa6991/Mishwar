import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/presentation/old_trips/model/old_trip_model.dart';
import 'package:mishwar/services/map_service.dart';

class OldTripPageCard extends StatefulWidget {
  final TripItem trip;

  const OldTripPageCard({super.key, required this.trip});

  @override
  State<OldTripPageCard> createState() => _OldTripPageCardState();
}

class _OldTripPageCardState extends State<OldTripPageCard> {
  final MapService _mapService = MapService();

  String sourceArea = "جاري التحميل...";
  String destinationArea = "جاري التحميل...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    try {
      final sourceLat = double.tryParse(widget.trip.sourceLat) ?? 0.0;
      final sourceLon = double.tryParse(widget.trip.sourceLon) ?? 0.0;
      final destLat = double.tryParse(widget.trip.destinationLat) ?? 0.0;
      final destLon = double.tryParse(widget.trip.destinationLon) ?? 0.0;

      final sourceAreaResult = await _mapService.getAreaFromLatLng(
        sourceLat,
        sourceLon,
      );
      final destAreaResult = await _mapService.getAreaFromLatLng(
        destLat,
        destLon,
      );

      if (mounted) {
        setState(() {
          sourceArea = sourceAreaResult;
          destinationArea = destAreaResult;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          sourceArea = "خطأ في التحميل";
          destinationArea = "خطأ في التحميل";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: appColors.green, size: 12.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            isLoading ? sourceArea : sourceArea,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.circle, color: appColors.black, size: 12.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            isLoading ? destinationArea : destinationArea,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: appColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 20.sp,
                        color: appColors.black,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${widget.trip.duration} دقيقة",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: appColors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "${widget.trip.sypPrice} SYP",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Divider(height: 20.h, thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    widget.trip.driver.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    widget.trip.driver.phone,
                    style: TextStyle(fontSize: 18.sp, color: appColors.black),
                  ),
                ],
              ),
            ],
          ),

          Divider(height: 20.h, thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.timeline, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    widget.trip.tripStatus,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
              RatingBarIndicator(
                rating: double.tryParse(widget.trip.tripRating) ?? 0.0,

                itemBuilder: (context, index) =>
                    Icon(Icons.star, color: appColors.amber),
                itemCount: 5,
                itemSize: 25.sp,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
