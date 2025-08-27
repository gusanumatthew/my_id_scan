import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myid_scan/gen/assets.gen.dart';

class CachedNetworkDisplay extends StatelessWidget {
  const CachedNetworkDisplay({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.height,
    this.width,
    this.borderRadiusGeometry,
    this.loadinHeight,
  });
  final String imageUrl;
  final BoxFit boxFit;
  final double? height, width, loadinHeight;
  final BorderRadiusGeometry? borderRadiusGeometry;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadiusGeometry ?? BorderRadius.circular(10),
      child: switch (imageUrl.isEmpty) {
        true => Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
          ),
        _ => CachedNetworkImage(
            memCacheHeight: height?.round(),
            memCacheWidth: width?.round(),
            progressIndicatorBuilder: (context, url, progress) {
              return AnimatedOpacity(
                  opacity: 0.1,
                  duration: const Duration(milliseconds: 300),
                  child: Assets.images.card.image(height: loadinHeight));
            },
            errorWidget: (context, url, error) {
              return AnimatedOpacity(
                opacity: 0.1,
                duration: const Duration(milliseconds: 300),
                child: Assets.images.card.image(height: loadinHeight),
              );
            },
            height: height,
            width: width,
            fit: boxFit,
            imageUrl: imageUrl,
          ),
      },
    );
  }
}
