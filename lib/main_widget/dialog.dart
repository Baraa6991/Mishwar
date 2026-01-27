import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/generated/l10n.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;
  final bool showCancelButton;

   const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: appColors.white,
      child: Padding(
        padding:  EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style:  TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 15),
            Text(
              description,
              style:  TextStyle(fontSize: 16, color: appColors.secondary),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (showCancelButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child:  Text(
                      S.of(context).Cansel,
                      style: TextStyle(color: appColors.black),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: onConfirm,
                  child: Text(
                    confirmText,
                    style:  TextStyle(color: appColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
