// create a class CompanySummary with firestore from factory and to factory
// Path: lib\objects\CompanySummary.dart
// attributes: cid, name, cin

import 'package:cloud_firestore/cloud_firestore.dart';

class CompanySummary {
  final String cid;
  final String cin;
  final String name;
  final String admin;

  CompanySummary({
    required this.cid,
    required this.cin,
    required this.name,
    required this.admin,
  });

  factory CompanySummary.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    Map data = snapshot.data() as Map;
    return CompanySummary(
      cid: data['cid'] ?? '',
      cin: data['cin'] ?? '',
      name: data['name'] ?? '',
      admin: data['admin'] ?? '',
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'cid': cid,
      'cin': cin,
      'name': name,
      'admin': admin,
    };
  }

  static CompanySummary fromMap(Map<String, dynamic> map) {
    return CompanySummary(
      cid: map['cid'] ?? '',
      cin: map['cin'] ?? '',
      name: map['name'] ?? '',
      admin: map['admin'] ?? '',
    );
  }

  static CollectionReference<CompanySummary> get collection => FirebaseFirestore.instance.collection('companies').withConverter(
      fromFirestore: CompanySummary.fromFirestore,
      toFirestore: (CompanySummary companySummary, _) => companySummary.toFirestore()
  );
}