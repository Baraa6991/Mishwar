import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/generated/l10n.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return Scaffold(
      backgroundColor: appColors.primary,
      appBar: AppBar(
        backgroundColor: appColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).PrivacyPolicy,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: appColors.secondary,
          ),
        ),
        iconTheme: IconThemeData(color: appColors.secondary),
      ),
      body: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          child: Text(
           S.of(context).PrivacyPolicyText,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.6,
              color: appColors.black,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  
}
