import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myid_scan/core/utils/failure.dart';
import 'package:myid_scan/view/authentication/model/app_user.dart';
import 'package:myid_scan/view/home/model/card_model.dart';

class UserRepository {
  UserRepository();

  final userCollection = FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> get cardsCollection =>
      FirebaseFirestore.instance.collection('cards');

  Future<AppUser> getFutureUser(String userId) async {
    final snapshot = await userCollection.doc(userId).get();
    return AppUser.fromMap(snapshot);
  }

  // Stream<AppUser> getUser(String userId) {
  //   return userCollection.doc(userId).snapshots().map(
  //         (documentSnapshot) => AppUser.fromMap(
  //           documentSnapshot,
  //         ),
  //       );
  // }

  Future<void> createUserWithId(
    String userId, {
    required String userName,
    required String email,
  }) async {
    return await userCollection.doc(userId).set({
      'userName': userName,
      'email': email,
      'timestamp': Timestamp.now(),
    });
  }

  Future<AppUser> updateUserWithId(
    String userId, {
    required String userName,
  }) async {
    await userCollection.doc(userId).update({
      'userName': userName,
    });

    return getFutureUser(userId);
  }

  Future<void> createCard(
      {required String creatorName, required CardParams params}) async {
    try {
      await cardsCollection.add({
        'creatorName': creatorName,
        ...params.toMap(),
      });
    } catch (ex) {
      throw const Failure('Error creating forum');
    }
  }

  Stream<List<Card>> getCards() {
    return cardsCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (queryDocumentSnapshot) =>
                    Card.fromDocumentSnapshot(queryDocumentSnapshot),
              )
              .toList(),
        );
  }
}

final userRepository = Provider<UserRepository>((ref) => UserRepository());
final cardsProvider = StreamProvider<List<Card>>((ref) {
  return ref.watch(userRepository).getCards();
});
