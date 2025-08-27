import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myid_scan/core/data/repository/auth_repository.dart';
import 'package:myid_scan/core/data/repository/user_repository.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/core/utils/failure.dart';
import 'package:myid_scan/core/utils/logger.dart';
import 'package:myid_scan/view/authentication/model/app_user.dart';
import 'package:myid_scan/view/authentication/notifiers/login_state.dart';

class LoginNotifier extends AutoDisposeNotifier<LoginState> {
  LoginNotifier();
  late AuthenticationRepository _authRepository;
  late UserRepository _userRepository;

  @override
  LoginState build() {
    _authRepository = ref.read(authenticationRepository);
    _userRepository = ref.read(userRepository);
    return LoginState.initial();
  }

  Future<void> login({
    required String email,
    required String password,
    required void Function(String) onError,
    required void Function(AppUser) onCompleted,
  }) async {
    state = state.copyWith(loadState: LoadState.loading);
    try {
      await _authRepository.login(
        email: email,
        password: password,
      );

      final user = _authRepository.currentUser;
      final appUser = await _userRepository.getFutureUser(user!.uid);
      state = state.copyWith(loadState: LoadState.success);
      onCompleted(appUser);
    } on Failure catch (e) {
      state = state.copyWith(loadState: LoadState.error);
      onError(e.toString());
    } catch (e) {
      state = state.copyWith(loadState: LoadState.error);
      onError('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required void Function(String) onError,
    required void Function() onCompleted,
  }) async {
    state = state.copyWith(registerLoadState: LoadState.loading);
    try {
      await _authRepository.register(
          email: email, displayName: displayName, password: password);
      state = state.copyWith(registerLoadState: LoadState.success);
      onCompleted();
    } on Failure catch (e) {
      state = state.copyWith(registerLoadState: LoadState.error);
      onError(e.toString());
    } catch (e) {
      state = state.copyWith(registerLoadState: LoadState.error);
      onError('An unexpected error occurred: ${e.toString()}');
    }
  }

  logOut() async {
    state = state.copyWith(registerLoadState: LoadState.loading);
    try {
      await _authRepository.signOut();
      state = state.copyWith(registerLoadState: LoadState.success);
    } on Failure catch (e) {
      state = state.copyWith(registerLoadState: LoadState.error);
      debugLog(e.toString());
    } catch (e) {
      state = state.copyWith(logoutLoadState: LoadState.error);
      debugLog('An unexpected error occurred: ${e.toString()}');
    }
  }
}

final loginNotifierProvider =
    NotifierProvider.autoDispose<LoginNotifier, LoginState>(LoginNotifier.new);
