import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myid_scan/core/data/repository/user_repository.dart';
import 'package:myid_scan/core/utils/failure.dart';
import 'package:myid_scan/core/utils/logger.dart';
import 'package:myid_scan/view/authentication/model/app_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthenticationRepository {
  final UserRepository _userRepository;

  AuthenticationRepository(
    this._userRepository,
  );
  User? get currentUser => FirebaseAuth.instance.currentUser;

  //Register
  Future<AppUser> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    try {
      debugLog('Starting registration for email: $email');

      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      debugLog('Firebase user created with UID: ${credential.user!.uid}');

      await credential.user!.updateDisplayName(displayName);
      debugLog('Display name updated to: $displayName');

      await _userRepository.createUserWithId(credential.user!.uid,
          userName: displayName, email: email);
      debugLog('User document created in Firestore');

      final appUser = await _userRepository.getFutureUser(credential.user!.uid);
      debugLog('AppUser retrieved successfully');

      return appUser;
    } on FirebaseAuthException catch (ex) {
      debugLog('FirebaseAuthException: ${ex.code} - ${ex.message}');
      throw Failure(ex.message ?? 'Something went wrong!');
    } catch (e) {
      debugLog('Unexpected error during registration: $e');
      throw Failure('Registration failed: ${e.toString()}');
    }
  }

  //Sign in
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      debugLog('Starting login for email: $email');

      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugLog('Login successful for UID: ${credential.user!.uid}');

      final appUser = await _userRepository.getFutureUser(credential.user!.uid);
      debugLog('AppUser retrieved for login');

      return appUser;
    } on FirebaseAuthException catch (ex) {
      debugLog(
          'FirebaseAuthException during login: ${ex.code} - ${ex.message}');
      throw Failure(ex.message ?? 'Something went wrong!');
    } catch (e) {
      debugLog('Unexpected error during login: $e');
      throw Failure('Login failed: ${e.toString()}');
    }
  }

  //Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    debugLog('User signed out');
  }
}

final authenticationRepository = Provider(
  (ref) => AuthenticationRepository(
    ref.read(userRepository),
  ),
);
