import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/firebase_options.dart';
import 'package:myid_scan/gen/fonts.gen.dart';
import 'package:myid_scan/view/general_widgets/app_overlay.dart';
import 'package:myid_scan/view/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = OverLayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, c) {
          return DevicePreview(
              enabled: kDebugMode,
              builder: (context) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: AppOverLay(
                      controller: _controller,
                      child: MaterialApp(
                        title: 'Myid Scan',
                        theme: ThemeData(
                          fontFamily: FontFamily.manrope,
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: AppColors.primaryColor,
                          ),
                          useMaterial3: true,
                        ),
                        routes: AppRouter.routes,
                        home: Splash(),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
