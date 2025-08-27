import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/views/widgets/temps_type.dart';

class CardReceipt extends StatelessWidget {
  const CardReceipt({
    super.key,
    required this.args,
  });
  final CardParams args;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Container(
            height: 700.h,
            color: AppColors.white,
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                switch (args.cardId) {
                  '1' => Template1Front(args: args),
                  '2' => Template2Front(args: args),
                  _ => Template3Front(args: args),
                },
                12.verticalSpace,
                TemplateBack(args: args),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
