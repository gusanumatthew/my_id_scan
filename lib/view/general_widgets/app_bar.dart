import 'package:flutter/material.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/gen/assets.gen.dart';
import 'package:myid_scan/view/general_widgets/app_svg_icon.dart';
import 'package:myid_scan/view/general_widgets/customizable_row.dart';

class IdAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IdAppBar({
    this.showBackButton = true,
    this.title,
    this.onTap,
    this.color,
    this.path,
    this.trailing,
    this.leading,
    super.key,
  });

  final bool showBackButton;
  final String? title;
  final String? path;
  final Widget? trailing, leading;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 0,
        right: 0,
        bottom: 0,
      ),
      decoration: const BoxDecoration(color: Colors.transparent),
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        children: [
          Expanded(
            child: CustomizableRow(
              flexValues: const [1, 4, 1],
              children: [
                switch (showBackButton == true) {
                  true => AppSvgIcon(
                      path: path ?? Assets.svgs.back,
                      fit: BoxFit.scaleDown,
                      onTap: onTap ?? () => context.pop(),
                    ),
                  _ => leading ?? SizedBox()
                },
                Center(
                  child: Text(title ?? '',
                      style: context.textTheme.s20w500.copyWith(
                        color: AppColors.textNew,
                      )),
                ),
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;
}
