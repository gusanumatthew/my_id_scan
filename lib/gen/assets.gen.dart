/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/card.png
  AssetGenImage get card => const AssetGenImage('assets/images/card.png');

  /// File path: assets/images/temp_1.png
  AssetGenImage get temp1 => const AssetGenImage('assets/images/temp_1.png');

  /// File path: assets/images/temp_2.png
  AssetGenImage get temp2 => const AssetGenImage('assets/images/temp_2.png');

  /// File path: assets/images/temp_3.png
  AssetGenImage get temp3 => const AssetGenImage('assets/images/temp_3.png');

  /// File path: assets/images/temp_4.png
  AssetGenImage get temp4 => const AssetGenImage('assets/images/temp_4.png');

  /// File path: assets/images/temp_back_1.png
  AssetGenImage get tempBack1 =>
      const AssetGenImage('assets/images/temp_back_1.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    card,
    temp1,
    temp2,
    temp3,
    temp4,
    tempBack1,
  ];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/add.svg
  String get add => 'assets/svgs/add.svg';

  /// File path: assets/svgs/back.svg
  String get back => 'assets/svgs/back.svg';

  /// File path: assets/svgs/camera.svg
  String get camera => 'assets/svgs/camera.svg';

  /// File path: assets/svgs/cancel.svg
  String get cancel => 'assets/svgs/cancel.svg';

  /// File path: assets/svgs/check.svg
  String get check => 'assets/svgs/check.svg';

  /// File path: assets/svgs/create_card.svg
  String get createCard => 'assets/svgs/create_card.svg';

  /// File path: assets/svgs/crop.svg
  String get crop => 'assets/svgs/crop.svg';

  /// File path: assets/svgs/current_route.svg
  String get currentRoute => 'assets/svgs/current_route.svg';

  /// File path: assets/svgs/delete.svg
  String get delete => 'assets/svgs/delete.svg';

  /// File path: assets/svgs/download.svg
  String get download => 'assets/svgs/download.svg';

  /// File path: assets/svgs/drag.svg
  String get drag => 'assets/svgs/drag.svg';

  /// File path: assets/svgs/drawer.svg
  String get drawer => 'assets/svgs/drawer.svg';

  /// File path: assets/svgs/error.svg
  String get error => 'assets/svgs/error.svg';

  /// File path: assets/svgs/forward.svg
  String get forward => 'assets/svgs/forward.svg';

  /// File path: assets/svgs/location.svg
  String get location => 'assets/svgs/location.svg';

  /// File path: assets/svgs/map_provider.svg
  String get mapProvider => 'assets/svgs/map_provider.svg';

  /// File path: assets/svgs/photo.svg
  String get photo => 'assets/svgs/photo.svg';

  /// File path: assets/svgs/profile.svg
  String get profile => 'assets/svgs/profile.svg';

  /// File path: assets/svgs/reset.svg
  String get reset => 'assets/svgs/reset.svg';

  /// File path: assets/svgs/retake.svg
  String get retake => 'assets/svgs/retake.svg';

  /// File path: assets/svgs/scan.svg
  String get scan => 'assets/svgs/scan.svg';

  /// File path: assets/svgs/search.svg
  String get search => 'assets/svgs/search.svg';

  /// File path: assets/svgs/settings.svg
  String get settings => 'assets/svgs/settings.svg';

  /// File path: assets/svgs/shield.svg
  String get shield => 'assets/svgs/shield.svg';

  /// File path: assets/svgs/stage.svg
  String get stage => 'assets/svgs/stage.svg';

  /// File path: assets/svgs/start_up.svg
  String get startUp => 'assets/svgs/start_up.svg';

  /// File path: assets/svgs/success.svg
  String get success => 'assets/svgs/success.svg';

  /// File path: assets/svgs/tabler_scan.svg
  String get tablerScan => 'assets/svgs/tabler_scan.svg';

  /// File path: assets/svgs/tick-circle.svg
  String get tickCircle => 'assets/svgs/tick-circle.svg';

  /// File path: assets/svgs/view-saved.svg
  String get viewSaved => 'assets/svgs/view-saved.svg';

  /// List of all assets
  List<String> get values => [
    add,
    back,
    camera,
    cancel,
    check,
    createCard,
    crop,
    currentRoute,
    delete,
    download,
    drag,
    drawer,
    error,
    forward,
    location,
    mapProvider,
    photo,
    profile,
    reset,
    retake,
    scan,
    search,
    settings,
    shield,
    stage,
    startUp,
    success,
    tablerScan,
    tickCircle,
    viewSaved,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
