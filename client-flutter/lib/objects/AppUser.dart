// create a class User with firestore factory

// Path: lib\objects\AppUser.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String name;
  final String address;
  final String email;
  final String uid;
  final Timestamp creationTimestamp;
  final List<String> companies;

  AppUser({
    required this.name,
    required this.address,
    required this.email,
    required this.uid,
    required this.creationTimestamp,
    required this.companies,
    });

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    Map data = snapshot.data() as Map;
    return AppUser(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      uid: data['uid'] ?? '',
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
      companies: data['companies'] ?? [],
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'uid': uid,
      'creationTimestamp': creationTimestamp,
      'companies': companies,
    };
  }

  static CollectionReference<AppUser> get collection => FirebaseFirestore.instance.collection('users').withConverter(
      fromFirestore: AppUser.fromFirestore,
      toFirestore: (AppUser user, _) => user.toFirestore()
  );
}