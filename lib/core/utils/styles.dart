import 'package:flutter/material.dart';
import 'package:myid_scan/core/utils/colors.dart';

class AppButtonStyle {
  AppButtonStyle({
    required this.start,
    required this.end,
    required this.textColor,
    required this.borderColor,
    required this.disabledBackgroundColor,
    required this.disabledTextColor,
    this.textStyle,
  });

  factory AppButtonStyle.secondary() = AppButtonSecondary;

  factory AppButtonStyle.primary() = AppButtonPrimary;
  final Color start;
  final Color end;
  final Color textColor;
  final Color borderColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;
  final TextStyle? textStyle;

  ///Button default values
  static const double buttonDefaultHeight = 60;
  static const double buttonDefaultWidth = double.infinity;
  static const double badgeDefaultHeight = 20;
  static const double badgeDefaultWidth = 46;
  static const double buttonCornerRadius = 60;
  static const double badgeCornerRadius = 100;
  static const bool buttonIsEnable = true;
  static const bool buttonIsLoading = false;
}

class AppButtonPrimary extends AppButtonStyle {
  AppButtonPrimary()
      : super(
          start: AppColors.secondaryColor,
          end: AppColors.primaryColor,
          disabledBackgroundColor: AppColors.secondaryGrey,
          textColor: AppColors.white,
          disabledTextColor: AppColors.white,
          borderColor: Colors.transparent,
        );
}

class AppButtonSecondary extends AppButtonStyle {
  AppButtonSecondary()
      : super(
          start: AppColors.white,
          end: AppColors.white,
          disabledBackgroundColor: AppColors.grey,
          textColor: AppColors.primaryColor,
          disabledTextColor: AppColors.textNew,
          borderColor: AppColors.primaryColor,
        );
}
