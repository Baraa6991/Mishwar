import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/profile/cubit/profile_cubit.dart';
import 'package:mishwar/presentation/profile/cubit/profile_state.dart';
import 'package:mishwar/presentation/profile/cubit/update_profile_cubit.dart';
import 'package:mishwar/presentation/profile/cubit/update_profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    final int userId = int.parse(
      CacheHelper.getData(key: "user_id")?.toString() ?? "0"
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProfileCubit(repository: ApiRepository())..fetchProfile(userId),
        ),
        BlocProvider(
          create: (context) => UpdateProfileCubit(repository: ApiRepository()),
        ),
      ],
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(state.message),
              ),
            );
            // إعادة تحميل البروفايل بعد التحديث
            context.read<ProfileCubit>().fetchProfile(userId);
          } else if (state is UpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, updateState) {
          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Scaffold(
                  backgroundColor: appColors.primary,
                  body: Center(
                    child: SpinKitThreeBounce(
                      color: appColors.secondary,
                      size: 40.sp,
                    ),
                  ),
                );
              } else if (state is ProfileLoaded) {
                final profile = state.profile;
                final updateCubit = context.read<UpdateProfileCubit>();

                return Scaffold(
                  backgroundColor: appColors.primary,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 120.h),

                          /// ✅ صورة المستخدم مع إمكانية التعديل
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                backgroundColor: appColors.white,
                                radius: 80.r,
                                backgroundImage:
                                    profile.photo != null &&
                                        profile.photo!.isNotEmpty
                                    ? CachedNetworkImageProvider(profile.photo!)
                                    : const AssetImage('assets/no_photo.jpg')
                                          as ImageProvider,
                              ),
                              Positioned(
                                bottom: 5.h,
                                right: 5.w,
                                child: GestureDetector(
                                  onTap: () async {
                                    final picker = ImagePicker();
                                    final picked = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (picked != null) {
                                      await updateCubit.updateProfile(
                                        photo: File(picked.path),
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: appColors.white,
                                    child: Icon(
                                      Icons.edit,
                                      color: appColors.secondary,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 70.h),

                          /// ✅ الاسم مع إمكانية التعديل
                          _infoTile(
                            icon: Icons.person,
                            text: profile.name,
                            color: appColors.secondary,
                            appColors: appColors,
                            onEdit: () => _showElegantDialog(
                              context,
                              title: S.of(context).Name,
                              initialValue: profile.name,
                              onConfirm: (value) async {
                                await updateCubit.updateProfile(name: value);
                              },
                              appColors: appColors,
                            ),
                          ),

                          SizedBox(height: 20.h),

                          Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.r),
                              ),
                              color: appColors.white,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.phone,
                                  color: appColors.secondary,
                                  size: 28.sp,
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  profile.phone,
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.r),
                              ),
                              color: appColors.white,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.star,
                                  color: appColors.secondary,
                                  size: 28.sp,
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  '${profile.rating.toStringAsFixed(1)} ${S.of(context).star}',
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.secondary,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                RatingBarIndicator(
                                  rating: profile.rating,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: appColors.amber),
                                  itemCount: 5,
                                  itemSize: 25.sp,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                return Scaffold(
                  backgroundColor: appColors.primary,
                  body: Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: appColors.white, fontSize: 20.sp),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  /// 🔹 بلاطة المعلومات مع أيقونة التعديل
  Widget _infoTile({
    required IconData icon,
    required String text,
    required Color color,
    required ThemeState appColors,
    required VoidCallback onEdit,
  }) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        color: appColors.white,
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Icon(icon, color: color, size: 28.sp),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: color, size: 22.sp),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  /// ✨ دايالوج أنيق وجميل لتعديل البيانات
  void _showElegantDialog(
    BuildContext context, {
    required String title,
    required String initialValue,
    required Function(String) onConfirm,
    required ThemeState appColors,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final controller = TextEditingController(text: initialValue);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              width: 300.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '✏️ $title',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.secondary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      hintText: title,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide(color: appColors.secondary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide(
                          color: appColors.secondary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          onConfirm(controller.text.trim());
                          Navigator.pop(context);
                        },
                        child: Text(
                          S.of(context).Save,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          S.of(context).Cansel,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }
}
