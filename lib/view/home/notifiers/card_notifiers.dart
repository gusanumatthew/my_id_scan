import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myid_scan/core/data/repository/auth_repository.dart';
import 'package:myid_scan/core/data/repository/user_repository.dart';
import 'package:myid_scan/core/data/services/cloudinary_image_upload.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/core/utils/failure.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/notifiers/card_state.dart';

class CardNotifier extends Notifier<CardState> {
  late UserRepository _userRepository;
  late AuthenticationRepository _authRepository;
  CardNotifier();

  @override
  CardState build() {
    _userRepository = ref.read(userRepository);
    _authRepository = ref.read(authenticationRepository);
    return CardState.initial();
  }

  void uploadFile({
    required String path,
    required void Function(String) onError,
    required void Function(String) onSuccess,
  }) async {
    state = state.copyWith(loadState: LoadState.loading);
    try {
      final response = await CloudinaryImageUploader().uploadImage(path);
      if (response.isNotEmpty) {
        state = state.copyWith(
          loadState: LoadState.success,
        );
        onSuccess(response);
      }
      state = state.copyWith(loadState: LoadState.error);
    } catch (e) {
      state = state.copyWith(loadState: LoadState.error);
      onError(e.toString());
    }
  }

  Future<void> saveCards({
    required CardParams params,
    required void Function(String) onError,
    required void Function() onCompleted,
  }) async {
    state = state.copyWith(addCarLoadState: LoadState.loading);
    try {
      await _userRepository.createCard(
        params: params,
        creatorName: _authRepository.currentUser?.displayName ?? 'Unknown',
      );
      state = state.copyWith(addCarLoadState: LoadState.success);
      onCompleted();
    } on Failure catch (e) {
      onError(e.toString());
    } catch (e) {
      state = state.copyWith(addCarLoadState: LoadState.error);
    }
  }

  resetState() {
    state = CardState(
      addCarLoadState: LoadState.idle,
      loadState: LoadState.idle,
    );
  }
}

final cardNotifierProvider =
    NotifierProvider<CardNotifier, CardState>(CardNotifier.new);
