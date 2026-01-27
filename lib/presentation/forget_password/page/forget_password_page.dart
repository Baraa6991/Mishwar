import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/main_widget/costom_textfield.dart';
import 'package:mishwar/main_widget/snackbar.dart';
import 'package:mishwar/presentation/Reset_Password/page/reset_password_page.dart';
import 'package:mishwar/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:mishwar/presentation/forget_password/cubit/forget_password_state.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({super.key});

  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return BlocProvider(
      create: (_) =>
          ForgetPasswordCubit(repository: ApiRepository()),
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetSuccess) {
            AppSnackBar.show(context, state.message, success: true);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ResetPasswordPage(phoneNumber: phoneController.text),
              ),
            );
          } else if (state is ForgetError) {
            AppSnackBar.show(context, state.message, success: false);
          }
        },
        child: Scaffold(
          backgroundColor: appColors.primary,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/مشوار.png',
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                      color: appColors.secondary,
                    ),
                    SizedBox(height: 50.h),

                    CustomTextField(
                      controller: phoneController,
                      hint: S.of(context).LoginTextFieldPhone,
                      prefixIcon: Icon(Icons.phone, color: appColors.secondary),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 30.h),

                    BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                      builder: (context, state) {
                        if (state is ForgetLoading) {
                          return SpinKitThreeBounce(
                            color: appColors.secondary,
                            size: 40.sp,
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          height: 55.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            onPressed: () {
                              final phone = phoneController.text.trim();

                              if (phone.isEmpty) {
                                AppSnackBar.show(
                                  context,
                                  S.of(context).LoginTextFieldPhone,
                                  success: false,
                                );
                                return;
                              }

                              context.read<ForgetPasswordCubit>().register(
                                phone: phone,
                              );
                            },
                            child: Text(
                              S.of(context).Save,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: appColors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
