// create a class EmployeeSummary with firestore from factory and to factory
// Path: lib\objects\EmployeeSummary.dart
// attributes: uid, eid, name, email

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeSummary {
  final String uid;
  final String eid;
  final String name;
  final String email;

  EmployeeSummary({
    required this.uid,
    required this.eid,
    required this.name,
    required this.email,
  });

  factory EmployeeSummary.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    Map data = snapshot.data() as Map;
    return EmployeeSummary(
      uid: data['uid'] ?? '',
      eid: data['eid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'eid': eid,
      'name': name,
      'email': email,
    };
  }

  static EmployeeSummary fromMap(Map<String, dynamic> map) {
    return EmployeeSummary(
      uid: map['uid'] ?? '',
      eid: map['eid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  static CollectionReference<EmployeeSummary> get collection => FirebaseFirestore.instance.collection('employees').withConverter(
      fromFirestore: EmployeeSummary.fromFirestore,
      toFirestore: (EmployeeSummary employeeSummary, _) => employeeSummary.toFirestore()
  );
}