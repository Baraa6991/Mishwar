import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Theme/Localization/localization.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/main_widget/SnackBar.dart';
import 'package:mishwar/main_widget/dialog.dart';
import 'package:mishwar/presentation/login/page/login_page.dart';
import 'package:mishwar/presentation/privacy_policy/privacy_policy_page.dart';
import 'package:mishwar/presentation/setting_page/cubit/delete_account_cubit.dart';
import 'package:mishwar/presentation/setting_page/cubit/logout_cubit.dart';
import 'package:mishwar/presentation/setting_page/widget/setting_widget.dart';
import 'package:mishwar/presentation/terms_of_use/terms_of_use_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    void showLoadingDialog(Color color) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: SpinKitThreeBounce(color: color, size: 40.sp),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appColors.primary,
      body: ListView(
        children: [
          SizedBox(height: 20.h),
          SettingItem(
            icon: Icons.rule,
            title: S.of(context).TermsOfUse,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TermsOfUsePage()),
              );
            },
          ),
          SettingItem(
            icon: Icons.privacy_tip,
            title: S.of(context).PrivacyPolicy,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
              );
            },
          ),
          SettingItem(
            icon: Icons.brightness_6,
            title: S.of(context).ChangeMode,
            onTap: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          SettingItem(
            icon: Icons.language,
            title: S.of(context).ChangeLanguage,
            onTap: () {
              context.read<LocaleCubit>().toggleLocale();
            },
          ),
          SettingItem(
            icon: Icons.logout,
            title: S.of(context).Logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CustomDialog(
                  title: S.of(context).Logout,
                  description: S.of(context).LogoutConfirm,
                  confirmText: S.of(context).Save,
                  onConfirm: () async {
                    Navigator.pop(context);
                    showLoadingDialog(appColors.primary);

                    final cubit = LogoutCubit(repository: ApiRepository());
                    await cubit.logout();

                    Navigator.pop(context);

                    if (cubit.state is LogoutSuccess) {
                      AppSnackBar.show(
                        context,
                        S.of(context).LogoutSuccess,
                        success: true,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    } else if (cubit.state is LogoutError) {
                      AppSnackBar.show(
                        context,
                        (cubit.state as LogoutError).message,
                        success: false,
                      );
                    }
                  },
                ),
              );
            },
          ),
          SettingItem(
            icon: Icons.delete_forever,
            title: S.of(context).DeleteAccount,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CustomDialog(
                  title: S.of(context).DeleteAccount,
                  description: S.of(context).DeleteConfirm,
                  confirmText: S.of(context).Save,
                  onConfirm: () async {
                    Navigator.pop(context);
                    showLoadingDialog(appColors.primary);

                    final cubit = DeleteAccountCubit(
                      repository: ApiRepository(),
                    );
                    await cubit.deleteAccount();

                    Navigator.pop(context);

                    if (cubit.state is DeleteAccountSuccess) {
                      AppSnackBar.show(
                        context,
                        S.of(context).DeleteSuccess,
                        success: true,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    } else if (cubit.state is DeleteAccountError) {
                      AppSnackBar.show(
                        context,
                        S.of(context).DeleteFailed,
                        success: false,
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
