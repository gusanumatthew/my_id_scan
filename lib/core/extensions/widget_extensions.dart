import 'package:flutter/material.dart';
import 'package:myid_scan/core/utils/colors.dart';

extension WidgetExtension on Widget {
  Widget withGradient({
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    BoxShape shape = BoxShape.rectangle,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      alignment: alignment,
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: const [
            AppColors.secondaryColor,
            AppColors.primaryColor,
          ],
        ),
      ),
      child: this,
    );
  }

  Widget withContainer({
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxShape shape = BoxShape.rectangle,
    Color? color,
    BoxBorder? border,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      alignment: alignment,
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        border: border,
        color: color,
        shape: shape,
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  Widget withLoadingWidget({
    required bool isLoading,
    double height = 30,
    double width = 100,
    Color? color,
    EdgeInsetsGeometry? margin,
    Widget? loadingWidget,
  }) {
    return isLoading
        ? loadingWidget ??
            Container(
              margin: margin,
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: color ?? AppColors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            )
        : this;
  }

  Widget withLoadingList({
    required bool isLoading,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ),
          ),
          child: child,
        );
      },
      child: isLoading
          ? ListView.separated(
              key: const ValueKey('loading'),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const CircleAvatar(radius: 25),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(height: 40, color: Colors.red),
                    ),
                  ],
                );
              },
            )
          : this,
    );
  }
}