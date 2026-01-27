import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/generated/l10n.dart';

class MenuBottomSheet extends StatelessWidget {
  final VoidCallback? onHistoryTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;

  const MenuBottomSheet({
    super.key,
    this.onHistoryTap,
    this.onProfileTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),
        Container(
          width: 50.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        SizedBox(height: 15.h),
        ListTile(
          leading: Icon(Icons.history, color: appColors.primary),
          title: Text(S.of(context).OldTrips),
          onTap: onHistoryTap,
        ),
        ListTile(
          leading: Icon(Icons.account_circle, color: appColors.primary),
          title: Text(S.of(context).Profile),
          onTap: onProfileTap,
        ),
        ListTile(
          leading: Icon(Icons.settings, color: appColors.primary),
          title: Text(S.of(context).Settings),
          onTap: onSettingsTap,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
