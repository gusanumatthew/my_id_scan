
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/view/general_widgets/app_sheet.dart';

class SelectImage extends StatelessWidget {
  const SelectImage({super.key, required this.onPickFile});
  final Function(ImageSource) onPickFile;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      canExit: true,
      content: Column(children: [
        Text('Choose', style: context.textTheme.s21w700),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onPickFile(ImageSource.camera);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             Icon(Icons.camera_enhance),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  'Camera',
                  style: context.textTheme.s15w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onPickFile(ImageSource.gallery);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.picture_in_picture),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  'Gallery',
                  style: context.textTheme.s15w500,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
