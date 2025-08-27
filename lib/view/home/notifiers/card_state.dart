import 'package:myid_scan/core/utils/enums.dart';

class CardState {
  final LoadState addCarLoadState;
  final LoadState loadState;


  CardState({
    required this.addCarLoadState,
    required this.loadState,
  
  });
  factory CardState.initial() {
    return CardState(
      addCarLoadState: LoadState.idle,
      loadState: LoadState.idle,
    );
  }
  CardState copyWith({
    LoadState? addCarLoadState,
    LoadState? loadState,

  }) {
    return CardState(
      addCarLoadState: addCarLoadState ?? this.addCarLoadState,
      loadState: loadState ?? this.loadState,
      
    );
  }
}
