import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/main_widget/costom_textfield.dart';
import 'package:mishwar/main_widget/image_picker_cubit.dart';
import 'package:mishwar/presentation/forget_password/page/forget_password_page.dart';
import 'package:mishwar/presentation/home/cubit/trip_cubit.dart';
import 'package:mishwar/presentation/home/page/trip_page.dart';
import 'package:mishwar/presentation/login/cubit/login_cubit.dart';
import 'package:mishwar/presentation/register/page/register_page.dart';
import 'package:mishwar/main_widget/snackbar.dart';
import 'package:mishwar/services/map_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return BlocProvider(
      create: (_) => LoginCubit(repository: ApiRepository()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            AppSnackBar.show(context, state.message, success: true);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => TripCubit(mapService: MapService()),
                  child: const HomeMapPage(),
                ),
              ),
            );
          } else if (state is LoginError) {
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
                    SizedBox(height: 20.h),
                    Image.asset(
                      'assets/مشوار.png',
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                      color: appColors.secondary,
                    ),
                    SizedBox(height: 80.h),
                    CustomTextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      hint: S.of(context).LoginTextFieldPhone,
                      prefixIcon: const Icon(Icons.phone),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: passwordController,
                      hint: S.of(context).LoginPassword,
                      prefixIcon: const Icon(Icons.lock),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgetPasswordPage(),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          S.of(context).ForgetPassword,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: appColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
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
                              context.read<LoginCubit>().login(
                                phone: phoneController.text,
                                password: passwordController.text,
                              );
                            },
                            child: Text(
                              S.of(context).LoginTitle,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).LoginRegister,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w300,
                            color: appColors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => ImageCubit(),
                                  child: RegisterPage(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            S.of(context).LoginRegisterGo,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.secondary,
                            ),
                          ),
                        ),
                      ],
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
