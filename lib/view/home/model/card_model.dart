import 'package:cloud_firestore/cloud_firestore.dart';

class Card {
  final String id;
  final String fullName;
  final String imageUrl;
  final String jobTitle;
  final String address;
  final String businessName;
  final String phone;
  final String email;
  final String cardId;
  final Timestamp timestamp;
  final String website;

  Card({
    required this.id,
    required this.fullName,
    required this.imageUrl,
    required this.jobTitle,
    required this.address,
    required this.businessName,
    required this.timestamp,
    required this.phone,
    required this.email,
    required this.website,
    required this.cardId,
  });

  factory Card.fromDocumentSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Card(
        id: snapshot.id,
        fullName: snapshot.data()?['fullName'],
        imageUrl: snapshot.data()?['imageUrl'],
        jobTitle: snapshot.data()?['jobTitle'],
        address: snapshot.data()?['address'],
        businessName: snapshot.data()?['businessName'],
        timestamp: snapshot.data()?['timestamp'],
        phone: snapshot.data()?['phone'],
        email: snapshot.data()?['email'],
        website: snapshot.data()?['website'],
        cardId: snapshot.data()?['cardId'],
      );
}

class CardParams {
  final String fullName;
  final String imageUrl;
  final String jobTitle;
  final String address;
  final String businessName;
  final String phone;
  final String email;
  final String website;
  final String? cardId;
  final bool fromSaved;

  CardParams({
    required this.fullName,
    required this.imageUrl,
    required this.jobTitle,
    required this.address,
    required this.businessName,
    required this.phone,
    required this.email,
    required this.website,
    this.cardId,
    required this.fromSaved,
  });

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'imageUrl': imageUrl,
        'jobTitle': jobTitle,
        'address': address,
        'businessName': businessName,
        'phone': phone,
        'email': email,
        'website': website,
        'cardId': cardId ?? '',
        'timestamp': Timestamp.now(),
      };
}
