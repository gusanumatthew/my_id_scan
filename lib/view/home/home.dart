import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/string_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/extensions/widget_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/gen/assets.gen.dart';
import 'package:myid_scan/view/authentication/model/app_user.dart';
import 'package:myid_scan/view/authentication/notifiers/login_notifier.dart';
import 'package:myid_scan/view/general_widgets/app_bar.dart';
import 'package:myid_scan/view/general_widgets/app_svg_icon.dart';
import 'package:myid_scan/view/general_widgets/profile_avatar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  _signOut() {
    ref.read(loginNotifierProvider.notifier).logOut();
    context.replaceAll(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as AppUser;
    return Scaffold(
      appBar: IdAppBar(
        showBackButton: false,
        leading: ProfileAvatar(
          imageUrl: '',
          initials: user.userName.initials,
        ),
        title: 'Business Card',
        trailing: IconButton(
          onPressed: _signOut,
          icon: const Icon(Icons.logout),
          color: AppColors.red,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pushNamed(AppRouter.createCard),
                    child: Column(
                      children: [
                        AppSvgIcon(path: Assets.svgs.createCard),
                        31.verticalSpace,
                        Text(
                          'Create Card',
                          style: context.textTheme.s16w500,
                        )
                      ],
                    ).withContainer(
                      color: Color(0XFFFDFFCC),
                      borderRadius: BorderRadius.circular(16.r),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pushNamed(AppRouter.savedCards),
                    child: Column(
                      children: [
                        AppSvgIcon(path: Assets.svgs.viewSaved),
                        31.verticalSpace,
                        Text(
                          'Saved Cards',
                          style: context.textTheme.s16w500,
                        )
                      ],
                    ).withContainer(
                      color: Color(0XFFFFF3F3),
                      borderRadius: BorderRadius.circular(16.r),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                ),
              ],
            ),
            40.verticalSpace,
            GestureDetector(
              onTap: () => context.pushNamed(AppRouter.scan),
              child: Row(
                children: [
                  AppSvgIcon(
                    path: Assets.svgs.scan,
                    color: AppColors.white,
                  ),
                  25.horizontalSpace,
                  Text(
                    'Scan a card',
                    style: context.textTheme.s24w900.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  )
                ],
              ).withGradient(
                end: Alignment.centerLeft,
                begin: Alignment.centerRight,
                borderRadius: BorderRadius.circular(16.r),
                padding: EdgeInsets.all(40),
              ),
            ),
            const Spacer(),
            Text(
                      'Adu Boluwatife Tolani \n2018707010070',
                      style: context.textTheme.s25w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
          ],
        ),
      ),
    );
  }
}
