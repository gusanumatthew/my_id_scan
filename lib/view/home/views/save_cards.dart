import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/data/repository/user_repository.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/gen/assets.gen.dart';
import 'package:myid_scan/view/general_widgets/app_bar.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/views/widgets/temps_type.dart';

class SaveCards extends ConsumerStatefulWidget {
  const SaveCards({super.key});

  @override
  ConsumerState<SaveCards> createState() => _SaveCardsState();
}

class _SaveCardsState extends ConsumerState<SaveCards> {
  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardsProvider);
    return Scaffold(
      appBar: IdAppBar(
        title: 'Saved Cards',
      ),
      body: cards.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.card.image(
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Saved Cards Yet',
                      style: context.textTheme.s18w600.copyWith(),
                    ),
                    12.verticalSpace,
                    Text(
                      'You haven\'t saved any cards yet.\nCreate your first card to get started!',
                      textAlign: TextAlign.center,
                      style: context.textTheme.s14w600.copyWith(),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.separated(
              separatorBuilder: (context, index) => 12.verticalSpace,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final card = data[index];
                final params = CardParams(
                  fullName: card.fullName,
                  jobTitle: card.jobTitle,
                  businessName: card.businessName,
                  imageUrl: card.imageUrl,
                  address: card.address,
                  email: card.email,
                  phone: card.phone,
                  website: card.website,
                  cardId: card.cardId,
                  fromSaved: true,
                );
                return switch (card.cardId) {
                  '1' => Template1Front(
                      args: params,
                      onTap: () => context.pushNamed(
                        AppRouter.viewTemp,
                        arguments: params,
                      ),
                    ),
                  '2' => Template2Front(
                      args: params,
                      onTap: () => context.pushNamed(
                        AppRouter.viewTemp,
                        arguments: params,
                      ),
                    ),
                  _ => Template3Front(
                      args: params,
                      onTap: () => context.pushNamed(
                        AppRouter.viewTemp,
                        arguments: params,
                      ),
                    ),
                };
              },
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
