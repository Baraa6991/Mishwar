import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/home/cubit/trip_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar/presentation/home/cubit/trip_state.dart';

class SearchBarWithMenu extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onMenuTap;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchTap;
  final GoogleMapController? mapController;

  const SearchBarWithMenu({
    super.key,
    required this.controller,
    required this.onMenuTap,
    required this.onSubmitted,
    required this.onSearchTap,
    this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<ThemeCubit>().state;
    final cubit = context.read<TripCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(25.r),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              if (value.isEmpty) {
                // ✅ إعادة تعيين كل شيء عند الحذف
                cubit.resetSearch();
                if (cubit.state.currentLocation != null && mapController != null) {
                  mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      cubit.state.currentLocation!,
                      15,
                    ),
                  );
                }
              } else {
                // ✅ البحث مع Debounce
                cubit.fetchPlaceSuggestionsWithDebounce(value);
              }
            },
            onSubmitted: (query) async {
              await cubit.searchPlace(query, mapController);
              onSubmitted(query);
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: S.of(context).search,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 14.h,
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ زر الحذف
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            controller.clear();
                            cubit.resetSearch();
                            if (cubit.state.currentLocation != null &&
                                mapController != null) {
                              mapController!.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  cubit.state.currentLocation!,
                                  15,
                                ),
                              );
                            }
                          },
                        ),
                        // ✅ زر البحث
                        IconButton(
                          icon: Icon(Icons.search, color: appColors.secondary),
                          onPressed: () async {
                            await cubit.searchPlace(controller.text, mapController);
                            onSearchTap();
                          },
                        ),
                      ],
                    )
                  : IconButton(
                      icon: Icon(Icons.search, color: appColors.secondary),
                      onPressed: () async {
                        await cubit.searchPlace(controller.text, mapController);
                        onSearchTap();
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        BlocBuilder<TripCubit, TripState>(
          builder: (context, state) {
            if (state.predictions.isEmpty) return const SizedBox();
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.r)],
              ),
              constraints: BoxConstraints(maxHeight: 200.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: state.predictions.length,
                separatorBuilder: (_, __) => Divider(height: 1.h),
                itemBuilder: (context, index) {
                  final suggestion = state.predictions[index]['description'];
                  return ListTile(
                    leading: Icon(Icons.location_on, color: appColors.secondary),
                    title: Text(suggestion),
                    onTap: () async {
                      controller.text = suggestion;
                      await cubit.searchPlace(suggestion, mapController);
                      cubit.resetSearch();
                      onSearchTap();
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}