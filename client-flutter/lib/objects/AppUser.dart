// create a class User with firestore factory

// Path: lib\objects\AppUser.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/objects/CompanySummary.dart';

class AppUser {
  final String name;
  final String address;
  final String email;
  final String uid;
  final Timestamp creationTimestamp;
  final List<String> companies;
  final Map<String, CompanySummary> companyData;

  AppUser({
    required this.name,
    required this.address,
    required this.email,
    required this.uid,
    required this.creationTimestamp,
    required this.companies,
    required this.companyData,
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
      companies: (data['companies'] as List?)?.map((i) => i as String).toList() ?? [],
      companyData: (data['companyData'] as Map?)?.map((key, value) => MapEntry(key, CompanySummary.fromMap(value))) ?? {},
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
      'companyData': companyData.map((key, value) => MapEntry(key, value.toFirestore())),
    };
  }

  static CollectionReference<AppUser> get collection => FirebaseFirestore.instance.collection('users').withConverter(
      fromFirestore: AppUser.fromFirestore,
      toFirestore: (AppUser user, _) => user.toFirestore()
  );
}