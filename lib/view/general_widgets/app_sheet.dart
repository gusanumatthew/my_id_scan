import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/utils/colors.dart';

/// [AppBottomSheet] is a bottomsheet widget built
/// with flutter widgets.
/// ### Params:
/// * [title] - An optional title of the view.
/// * [width] - Optional preferred width of the view
/// * [height] - Optional preferred height of the view
/// * [content] - required body for the sheet where all your custom views
/// goes in.
///
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.content,
    super.key,
    this.title,
    this.height,
    this.width,
    this.subtitle,
    this.onExitTap,
    this.cancelPadding,
    this.titleWidget,
    this.padding,
    this.canExit = true,
    this.hasHeaders = true,
  });
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget content;
  final double? height;
  final double? width;
  final GestureTapCallback? onExitTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? cancelPadding;
  final bool canExit;
  final bool hasHeaders;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.2),
        BlendMode.srcOver,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .95,
          minHeight: 100,
          minWidth: width ?? MediaQuery.of(context).size.width,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          color: Colors.white,
        ),
        padding: padding ?? const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canExit)
                  Padding(
                    padding: cancelPadding ?? EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Text(title ?? '', style: context.textTheme.s18w700),
                        GestureDetector(
                          onTap: onExitTap ?? () => Navigator.pop(context),
                          child: Container(
                            height: 32.h,
                            width: 32.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardGrey,
                            ),
                            child: Icon(
                              Icons.cancel,
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
