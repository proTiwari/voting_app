// create a class Comapny with firestore from factory and to factory

// Path: lib\objects\Company.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String cid;
  final String cin;
  final Timestamp creationTimestamp;
  final String name;
  final String admin;
  final List<String> users;
  final List<String> events;

  Company({
    required this.cid,
    required this.cin,
    required this.creationTimestamp,
    required this.name,
    required this.admin,
    required this.users,
    required this.events,
  });

  factory Company.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    Map data = snapshot.data() as Map;
    return Company(
      cid: data['cid'] ?? '',
      cin: data['cin'] ?? '',
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
      name: data['name'] ?? '',
      admin: data['admin'] ?? '',
      users: data['users'] ?? [],
      events: data['events'] ?? [],
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'cid': cid,
      'cin': cin,
      'creationTimestamp': creationTimestamp,
      'name': name,
      'admin': admin,
      'users': users,
      'events': events,
    };
  }

  static CollectionReference<Company> get collection => FirebaseFirestore.instance.collection('companies').withConverter(
      fromFirestore: Company.fromFirestore,
      toFirestore: (Company company, _) => company.toFirestore()
  );
}