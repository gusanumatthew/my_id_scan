
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myid_scan/core/utils/colors.dart';


class AppLoader extends StatefulWidget {
  const AppLoader(
      {super.key, this.color = AppColors.primaryColor, this.size = 30});
  final Color color;
  final double size;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: widget.color,
      size: widget.size,
    );
  }
}
