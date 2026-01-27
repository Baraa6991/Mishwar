import 'dart:io';
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
import 'package:mishwar/main_widget/snackbar.dart';
import 'package:mishwar/presentation/login/page/login_page.dart';
import 'package:mishwar/presentation/register/cubit/register_cubit.dart';
import 'package:mishwar/presentation/viryFicition_code/page/veryfiy_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ImageCubit()),
        BlocProvider(
          create: (_) => RegisterCubit(repository: ApiRepository()),
        ),
      ],
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            AppSnackBar.show(context, state.message, success: true);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VeryfiyPage(phoneNumber: phoneController.text.trim()),
              ),
            );
          } else if (state is RegisterError) {
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
                    SizedBox(height: 40.h),

                    SizedBox(height: 40.h),

                    BlocBuilder<ImageCubit, ImageState>(
                      builder: (context, state) {
                        File? imageFile;
                        if (state is ImagePicked) {
                          imageFile = state.image;
                        }

                        return GestureDetector(
                          onTap: () =>
                              context.read<ImageCubit>().pickImageFromGallery(),
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: appColors.white,
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile)
                                : null,
                            child: imageFile == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 40.sp,
                                    color: appColors.secondary,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40.h),

                    // حقل الاسم
                    CustomTextField(
                      controller: nameController,
                      hint: S.of(context).RegisterTextFieldName,
                      prefixIcon: Icon(
                        Icons.person,
                        color: appColors.secondary,
                      ),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                    ),
                    SizedBox(height: 20.h),

                    // حقل الهاتف
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
                    SizedBox(height: 20.h),

                    CustomTextField(
                      controller: passwordController,
                      hint: S.of(context).LoginPassword,
                      prefixIcon: Icon(Icons.lock, color: appColors.secondary),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.h),

                    CustomTextField(
                      controller: confirmPasswordController,
                      hint: S.of(context).RegisterConfirmPassword,
                      prefixIcon: Icon(Icons.lock, color: appColors.secondary),
                      fillColor: appColors.white,
                      borderColor: appColors.white,
                      borderRadius: 20.r,
                      iconColor: appColors.secondary,
                      obscureText: true,
                    ),

                    SizedBox(height: 40.h),

                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoading) {
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
                              final imageState = context
                                  .read<ImageCubit>()
                                  .state;
                              File? photo;
                              if (imageState is ImagePicked) {
                                photo = imageState.image;
                              }

                              context.read<RegisterCubit>().register(
                                name: nameController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                                passwordConfirmation:
                                    confirmPasswordController.text,
                                photo: photo,
                              );
                            },
                            child: Text(
                              S.of(context).LoginRegisterGo,
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
                          S.of(context).RegisterLogin,
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
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            S.of(context).LoginTitle,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
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
