// create a class CompanySummary with firestore from factory and to factory
// Path: lib\objects\CompanySummary.dart
// attributes: cid, name, cin

import 'package:cloud_firestore/cloud_firestore.dart';

class CompanySummary {
  final String cid;
  final String cin;
  final String name;

  CompanySummary({
    required this.cid,
    required this.cin,
    required this.name,
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
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'cid': cid,
      'cin': cin,
      'name': name,
    };
  }

  static CollectionReference<CompanySummary> get collection => FirebaseFirestore.instance.collection('companies').withConverter(
      fromFirestore: CompanySummary.fromFirestore,
      toFirestore: (CompanySummary companySummary, _) => companySummary.toFirestore()
  );
}