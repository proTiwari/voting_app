// create a class Invite with firestore from factory and to factory
// Path: lib\objects\Invite.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum InviteStatus { pending, accepted, rejected }

class Invite {
  final String inviteId;
  final String cid;
  final String uid;
  final String companyEmail;
  final Timestamp creationTimestamp;
  final InviteStatus status;
  final Timestamp? actionTimestamp;

  Invite({
    required this.inviteId,
    required this.cid,
    required this.uid,
    required this.companyEmail,
    required this.creationTimestamp,
    required this.status,
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
      companyEmail: data['email'] ?? '',
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
      status: data['status'] ? InviteStatus.values.byName(data['status']): InviteStatus.pending,
      actionTimestamp: data['actionTimestamp'],
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'inviteId': inviteId,
      'cid': cid,
      'uid': uid,
      'email': companyEmail,
      'creationTimestamp': creationTimestamp,
      'status': status.name,
      'actionTimestamp': actionTimestamp,
    };
  }

  // collection with converter
  static CollectionReference<Invite> get collection => FirebaseFirestore.instance.collection('invites').withConverter(
      fromFirestore: Invite.fromFirestore,
      toFirestore: (Invite invite, _) => invite.toFirestore()
  );
}