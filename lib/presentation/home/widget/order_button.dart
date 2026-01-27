import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/generated/l10n.dart';

class OrderButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const OrderButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.primary,
        minimumSize: Size(double.infinity, 55.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      ),
      onPressed: enabled ? onPressed : null,
      icon: Icon(Icons.local_taxi, color: appColors.secondary),
      label: Text(
        S.of(context).OrderNow,
        style: TextStyle(fontSize: 18.sp, color: appColors.secondary),
      ),
    );
  }
}
