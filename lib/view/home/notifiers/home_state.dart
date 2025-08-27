import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/view/home/model/business_card_model.dart';

class HomeState {
  final LoadState addCarLoadState;
  final LoadState scanLoadState;
  final BusinessCardData? scanResult;

  HomeState({
    required this.addCarLoadState,
    required this.scanLoadState,
    this.scanResult,
  });
  factory HomeState.initial() {
    return HomeState(
      addCarLoadState: LoadState.idle,
      scanLoadState: LoadState.idle,
    );
  }
  HomeState copyWith({
    LoadState? addCarLoadState,
    LoadState? scanLoadState,
    BusinessCardData? scanResult,
  }) {
    return HomeState(
      addCarLoadState: addCarLoadState ?? this.addCarLoadState,
      scanLoadState: scanLoadState ?? this.scanLoadState,
      scanResult: scanResult ?? this.scanResult,
    );
  }
}
