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
import 'package:mishwar/presentation/Reset_Password/cubit/reset_password_cubit.dart';
import 'package:mishwar/presentation/login/page/login_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordPage extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmationPassword = TextEditingController();

  ResetPasswordPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return BlocProvider(
      create: (_) => ResetPasswordCubit(repository: ApiRepository()),
      child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            AppSnackBar.show(context, state.message, success: true);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          } else if (state is ResetPasswordError) {
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
                    // SizedBox(height: 24.h),
                    PinCodeTextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10.r),
                        fieldHeight: 50.h,
                        fieldWidth: 40.w,
                        activeFillColor: appColors.white,
                        selectedColor: appColors.secondary,
                        selectedFillColor: appColors.white,
                        inactiveColor: appColors.black,
                        inactiveFillColor: appColors.white,
                        activeColor: appColors.secondary,
                      ),
                      backgroundColor: appColors.primary,
                      textStyle: TextStyle(
                        color: appColors.black,
                        fontSize: 18.sp,
                      ),
                      enableActiveFill: true,
                    ),
                    SizedBox(height: 30.h),
                    CustomTextField(
                      controller: newPassword,
                      hint: S.of(context).NewPassword,
                      prefixIcon: Icon(Icons.lock, color: appColors.secondary),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: confirmationPassword,
                      hint: S.of(context).ConfirmPassword,
                      prefixIcon: Icon(Icons.lock, color: appColors.secondary),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                      obscureText: true,
                    ),
                    SizedBox(height: 40.h),
                    BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                      builder: (context, state) {
                        if (state is ResetPasswordLoading) {
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
                              if (codeController.text.length == 6 &&
                                  newPassword.text.isNotEmpty &&
                                  confirmationPassword.text.isNotEmpty) {
                                context.read<ResetPasswordCubit>().resetPassword(
                                  phoneNumber: phoneNumber,
                                  otp: codeController.text,
                                  password: newPassword.text,
                                  passwordConfirmation: confirmationPassword.text,
                                );
                              } else {
                                AppSnackBar.show(
                                  context,
                                  S.of(context).PleaseFillAllFields,
                                  success: false,
                                );
                              }
                            },
                            child: Text(
                              S.of(context).ResetPassword,
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
