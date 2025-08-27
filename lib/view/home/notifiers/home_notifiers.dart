import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myid_scan/core/data/services/text_recognition_service.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/core/utils/logger.dart';
import 'package:myid_scan/view/home/notifiers/home_state.dart';

class HomeNotifier extends AutoDisposeNotifier<HomeState> {
  late TextRecognitionService _textRecognitionService;
  HomeNotifier();

  @override
  HomeState build() {
    _textRecognitionService = TextRecognitionService();

    ref.onDispose(() {
      _textRecognitionService.dispose();
    });
    return HomeState.initial();
  }

  Future<void> scanCard({
    required String imagePath,
    required void Function(String) onError,
    required void Function() onSuccess,
  }) async {
    state = state.copyWith(scanLoadState: LoadState.loading);

    try {
      final result = await _textRecognitionService.scanBusinessCard(imagePath);
      state = state.copyWith(
        scanLoadState: LoadState.success,
        scanResult: result,
      );
      onSuccess();
      debugLog(result.address);
    } catch (e) {
      onError(e.toString());
      state = state.copyWith(
        scanLoadState: LoadState.error,
      );
      debugLog(e.toString());
    }
  }

  resetState() {
    state = HomeState(
      addCarLoadState: state.addCarLoadState,
      scanLoadState: LoadState.idle,
      scanResult: null,
    );
  }
}

final homeNotifierProvider =
    NotifierProvider.autoDispose<HomeNotifier, HomeState>(HomeNotifier.new);
