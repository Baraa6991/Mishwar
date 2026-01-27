import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? appColors.secondary),
      title: Text(title, style: TextStyle(color: textColor ?? appColors.secondary)),
      trailing:  Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: onTap ?? () {},
    );
  }
}
