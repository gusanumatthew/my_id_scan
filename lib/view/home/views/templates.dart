import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/view/general_widgets/app_bar.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/views/widgets/temps_type.dart';

class Templates extends StatefulWidget {
  const Templates({super.key});

  @override
  State<Templates> createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CardParams;
    return Scaffold(
      appBar: IdAppBar(
        title: 'Choose a Template',
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8.h,
            children: [
              Template1Front(
                args: args,
                onTap: () => context.pushNamed(
                  AppRouter.viewTemp,
                  arguments: CardParams(
                    fullName: args.fullName,
                    jobTitle: args.jobTitle,
                    businessName: args.businessName,
                    imageUrl: args.imageUrl,
                    address: args.address,
                    email: args.email,
                    phone: args.phone,
                    website: args.website,
                    cardId: '1',
                    fromSaved: false,
                  ),
                ),
              ),
              Template2Front(
                args: args,
                onTap: () => context.pushNamed(
                  AppRouter.viewTemp,
                  arguments: CardParams(
                    fullName: args.fullName,
                    jobTitle: args.jobTitle,
                    businessName: args.businessName,
                    imageUrl: args.imageUrl,
                    address: args.address,
                    email: args.email,
                    phone: args.phone,
                    website: args.website,
                    cardId: '2',
                    fromSaved: false,
                  ),
                ),
              ),
              Template3Front(
                args: args,
                onTap: () => context.pushNamed(
                  AppRouter.viewTemp,
                  arguments: CardParams(
                    fullName: args.fullName,
                    jobTitle: args.jobTitle,
                    businessName: args.businessName,
                    imageUrl: args.imageUrl,
                    address: args.address,
                    email: args.email,
                    phone: args.phone,
                    website: args.website,
                    cardId: '3',
                    fromSaved: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
