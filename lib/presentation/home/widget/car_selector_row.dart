import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/presentation/home/model/vehicle_model.dart';

class CarSelectorRow extends StatelessWidget {
  final String? selectedCar;
  final ValueChanged<String> onCarSelected;
  final List<VehicleClassification> cars;
  final Map<String, double> carsPrices;

  const CarSelectorRow({
    super.key,
    required this.selectedCar,
    required this.onCarSelected,
    required this.cars,
    required this.carsPrices,
  });

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          final selected = selectedCar == car.vehicleType;
          final price = carsPrices[car.priceKey];

          return GestureDetector(
            onTap: () => onCarSelected(car.vehicleType),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              width: 140.w,
              decoration: BoxDecoration(
                color: selected ? Colors.grey : appColors.primary,
                borderRadius: BorderRadius.circular(16.r),
                border: selected
                    ? Border.all(color: appColors.secondary, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        car.vehicleImage,
                        width: 45.w,
                        height: 45.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          car.displayName,
                          style: TextStyle(
                            color: appColors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    price != null ? "${price.toStringAsFixed(0)} ل.س" : "-",
                    style: TextStyle(
                      color: appColors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}