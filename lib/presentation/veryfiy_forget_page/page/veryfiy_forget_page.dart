import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/main_widget/snackbar.dart';
import 'package:mishwar/presentation/login/page/login_page.dart';
import 'package:mishwar/presentation/viryFicition_code/cubit/veryfiy_cubit.dart';
import 'package:mishwar/presentation/viryFicition_code/cubit/viryfiy_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VeryfiyForgetPage extends StatelessWidget {
  final String phoneNumber;

  const VeryfiyForgetPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    final codeController = TextEditingController();

    return BlocProvider(
      create: (_) => VerificationCubit(repository: ApiRepository()),
      child: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            _saveUserData(state.userData);

            AppSnackBar.show(context, state.message, success: true);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          } else if (state is VerificationError) {
            AppSnackBar.show(context, state.message, success: false);
          } else if (state is ResendCodeSuccess) {
            AppSnackBar.show(context, state.message, success: true);
          }
        },
        child: Scaffold(
          backgroundColor: appColors.primary,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 80.h),

                  Text(
                    '${S.of(context).Verification} - $phoneNumber',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),

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
                  SizedBox(height: 40.h),

                  BlocBuilder<VerificationCubit, VerificationState>(
                    builder: (context, state) {
                      if (state is VerificationLoading) {
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
                            if (codeController.text.length == 6) {
                              context.read<VerificationCubit>().verifyPhone(
                                phoneNumber: phoneNumber,
                                code: codeController.text,
                                fcmToken: 'hhhhh',
                              );
                            } else {
                              AppSnackBar.show(
                                context,
                                S.of(context).VerificationCodeRequired,
                                success: false,
                              );
                            }
                          },
                          child: Text(
                            S.of(context).Verification,
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

                  BlocBuilder<VerificationCubit, VerificationState>(
                    builder: (context, state) {
                      if (state is ResendCodeLoading) {
                        return SpinKitThreeBounce(
                          color: appColors.secondary,
                          size: 40.sp,
                        );
                      }
                      return InkWell(
                        onTap: state is VerificationLoading
                            ? null
                            : () {
                                context.read<VerificationCubit>().resendCode(
                                  phoneNumber: phoneNumber,
                                );
                              },
                        child: Text(
                          S.of(context).ReSendCode,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: state is VerificationLoading
                                ? appColors.black
                                : appColors.secondary,
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
    );
  }

  void _saveUserData(Map<String, dynamic> userData) async {
    await CacheHelper.saveData(key: "user_id", value: userData['id']);
    await CacheHelper.saveData(key: "user_name", value: userData['name']);
    await CacheHelper.saveData(key: "user_phone", value: userData['phone']);
    if (userData['photo'] != null) {
      await CacheHelper.saveData(key: "user_photo", value: userData['photo']);
    }
  }
}
