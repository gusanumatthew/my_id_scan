// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myid_scan/core/data/repository/auth_repository.dart';
import 'package:myid_scan/core/data/repository/user_repository.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/core/utils/colors.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    decideNavigation();
    super.initState();
  }

  void decideNavigation(){
    Future.delayed(const Duration(seconds: 3), () async{
      final user = ref.watch(authenticationRepository).currentUser;
      if (user == null) {
        context.replaceNamed(AppRouter.getStarted);
      } else {
        final appUser = await ref.watch(userRepository).getFutureUser(user.uid);
        context.replaceNamed(AppRouter.home, arguments: appUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'My',
            style: context.textTheme.s25w600.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'ID',
                textStyle: context.textTheme.s25w600.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 27,
                ),
                speed: const Duration(milliseconds: 200),
              ),
            ],
            totalRepeatCount: 1,
          )
        ],
      ),
    ));
  }
}
