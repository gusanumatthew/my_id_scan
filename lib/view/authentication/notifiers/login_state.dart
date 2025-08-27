import 'package:myid_scan/core/utils/enums.dart';

class LoginState {
  final LoadState loadState;
  final LoadState registerLoadState;
  final LoadState logoutLoadState;

  LoginState({
    required this.loadState,
    required this.registerLoadState,
    required this.logoutLoadState,
  });
  factory LoginState.initial() {
    return LoginState(
      loadState: LoadState.idle,
      registerLoadState: LoadState.idle,
      logoutLoadState: LoadState.idle,
    );
  }
  LoginState copyWith({
    LoadState? loadState,
    LoadState? registerLoadState,
    LoadState? logoutLoadState,
  }) {
    return LoginState(
      loadState: loadState ?? this.loadState,
      registerLoadState: registerLoadState ?? this.registerLoadState,
      logoutLoadState: logoutLoadState ?? this.logoutLoadState,
    );
  }
}
