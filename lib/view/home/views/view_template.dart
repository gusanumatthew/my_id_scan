import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/overlay_extensions.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/view/general_widgets/app_bar.dart';
import 'package:myid_scan/view/general_widgets/app_button.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/notifiers/card_notifiers.dart';
import 'package:myid_scan/view/home/views/widgets/share_card.dart';
import 'package:myid_scan/view/home/views/widgets/temps_type.dart';

class ViewTemplate extends ConsumerStatefulWidget {
  const ViewTemplate({super.key});

  @override
  ConsumerState<ViewTemplate> createState() => _ViewTemplateState();
}

class _ViewTemplateState extends ConsumerState<ViewTemplate> {
  saveCard(CardParams args) {
    ref.read(cardNotifierProvider.notifier).saveCards(
          params: args,
          onError: (p0) {
            context.showError(message: p0);
          },
          onCompleted: () {
            context.showSuccess(message: 'Card saved successfully');
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CardParams;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(color: Colors.transparent),
      ),
      child: Scaffold(
        appBar: IdAppBar(
          title: 'View Your Business Card',
        ),
        body: Padding(
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
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Column(
              children: [
                if (args.fromSaved == false) ...[
                  Consumer(builder: (context, r, c) {
                    final loadState = r.watch(
                        cardNotifierProvider.select((v) => v.addCarLoadState));
                    return AppButton(
                      text: 'Save Card',
                      onTap: () => saveCard(args),
                      isLoading: loadState.isLoading,
                    );
                  }),
                  12.verticalSpace,
                ],
                AppButton(
                    text: 'Download Card',
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ShareCard(
                            args: args,
                          );
                        },
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
