import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/gen/assets.gen.dart';
import 'package:myid_scan/view/general_widgets/cached_network.dart';
import 'package:myid_scan/view/home/model/card_model.dart';

class Template1Front extends StatelessWidget {
  const Template1Front({super.key, required this.args, this.onTap,});
  final CardParams args;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 169.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.temp1.provider(),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.only(top: 24.h, left: 37.w, right: 37.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args.fullName,
                    style: context.textTheme.s12w700.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    args.jobTitle,
                    style: context.textTheme.s12w700.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 69.h,
                    width: 69.w,
                    child: CachedNetworkDisplay(
                      imageUrl: args.imageUrl,
                      boxFit: BoxFit.cover,
                      borderRadiusGeometry: BorderRadius.circular(100.r),
                    ),
                  ),
                  14.horizontalSpace,
                  Text(
                    args.businessName,
                    style: context.textTheme.s20w700.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Template2Front extends StatelessWidget {
  const Template2Front({super.key, required this.args, this.onTap,});
  final CardParams args;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 169.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.temp2.provider(),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.only(top: 24.h, left: 60.w, right: 37.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args.fullName,
                    style: context.textTheme.s12w700.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    args.jobTitle,
                    style: context.textTheme.s12w700.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 69.h,
                    width: 69.w,
                    child: CachedNetworkDisplay(
                      imageUrl: args.imageUrl,
                      boxFit: BoxFit.cover,
                      borderRadiusGeometry: BorderRadius.circular(100.r),
                    ),
                  ),
                  Text(
                    args.businessName,
                    style: context.textTheme.s20w700.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Template3Front extends StatelessWidget {
  const Template3Front({super.key, required this.args, this.onTap,});
  final CardParams args;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 169.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.temp3.provider(),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.only(top: 24.h, left: 60.w, right: 37.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(right: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 69.h,
                      width: 69.w,
                      child: CachedNetworkDisplay(
                        imageUrl: args.imageUrl,
                        boxFit: BoxFit.cover,
                        borderRadiusGeometry: BorderRadius.circular(100.r),
                      ),
                    ),
                    Text(
                      args.businessName,
                      style: context.textTheme.s20w700.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args.fullName,
                    style: context.textTheme.s12w700.copyWith(
                      color: AppColors.red,
                    ),
                  ),
                  Text(
                    args.jobTitle,
                    style: context.textTheme.s12w700
                        .copyWith(color: AppColors.red),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TemplateBack extends StatelessWidget {
  const TemplateBack({super.key, required this.args});
  final CardParams args;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 169.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.tempBack1.provider(),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.only(top: 24.h, left: 60.w, right: 37.w),
      child: Column(
        spacing: 8.h,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.white, size: 16.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  args.address,
                  style: context.textTheme.s12w700.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.phone, color: AppColors.white, size: 16.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  args.phone,
                  style: context.textTheme.s12w700.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.email, color: AppColors.white, size: 16.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  args.email,
                  style: context.textTheme.s12w700.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.public, color: AppColors.white, size: 16.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  args.website,
                  style: context.textTheme.s12w700.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
