import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  EdgeInsetsGeometry get bottomPaddingForTextField =>
      EdgeInsets.only(bottom: MediaQuery.of(this).viewInsets.bottom);
}
