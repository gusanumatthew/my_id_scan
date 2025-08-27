import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/gen/assets.gen.dart';
import 'package:myid_scan/view/general_widgets/app_button.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.card.image(),
            54.verticalSpace,
            Text(
              'Create & Share Business Cards Instantly',
              style: context.textTheme.s40w600,
            ),
            99.verticalSpace,
            AppButton(
              text: 'Get Started',
              onTap: () => context.pushNamed(AppRouter.signUp),
            ),
            16.verticalSpace,
            AppButton(
              text: 'Sign In',
              onTap: () => context.pushNamed(AppRouter.login),
            )
          ],
        ),
      ),
    );
  }
}
