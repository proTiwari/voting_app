// create a class Invite with firestore from factory and to factory
// Path: lib\objects\Invite.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/objects/EmployeeSummary.dart';
import 'CompanySummary.dart';

enum InviteStatus { pending, accepted, rejected }

class Invite {
  final String inviteId;
  final String cid;
  final String uid;
  final String companyEmail;
  final Timestamp creationTimestamp;
  final InviteStatus status;
  final CompanySummary companyData;
  final EmployeeSummary employeeData;
  final Timestamp? actionTimestamp;

  Invite({
    required this.inviteId,
    required this.cid,
    required this.uid,
    required this.companyEmail,
    required this.creationTimestamp,
    required this.status,
    required this.companyData,
    required this.employeeData,
    this.actionTimestamp,
  });

  factory Invite.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    Map data = snapshot.data() as Map;
    return Invite(
      inviteId: data['inviteId'] ?? '',
      cid: data['cid'] ?? '',
      uid: data['uid'] ?? '',
      companyEmail: data['companyEmail'] ?? '',
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
      status: InviteStatus.values.byName(data['status']),
      actionTimestamp: data['actionTimestamp'],
      companyData: CompanySummary.fromMap(data['companyData']),
      employeeData: EmployeeSummary.fromMap(data['employeeData']),
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'inviteId': inviteId,
      'cid': cid,
      'uid': uid,
      'companyEmail': companyEmail,
      'creationTimestamp': creationTimestamp,
      'status': status.name,
      'actionTimestamp': actionTimestamp,
      'companyData': companyData.toFirestore(),
      'employeeData': employeeData.toFirestore(),
    };
  }

  // collection with converter
  static CollectionReference<Invite> get collection => FirebaseFirestore.instance.collection('invites').withConverter(
      fromFirestore: Invite.fromFirestore,
      toFirestore: (Invite invite, _) => invite.toFirestore()
  );
}