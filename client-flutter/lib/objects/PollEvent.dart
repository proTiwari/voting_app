// create a class PollEvent with firestore from factory and to factory
// Path: lib\objects\PollEvent.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PollEvent {
  final String evid;
  final String topic;
  final String description;
  final String cid;
  final List<String> voters;
  final List<String> options;
  final Timestamp creationTimestamp;
  final Timestamp startTimestamp;
  final Timestamp endTimestamp;
  final String type = 'poll';

  PollEvent({
    required this.evid,
    required this.topic,
    required this.description,
    required this.cid,
    required this.voters,
    required this.options,
    required this.creationTimestamp,
    required this.startTimestamp,
    required this.endTimestamp,
  });

  factory PollEvent.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    Map data = snapshot.data() as Map;
    return PollEvent(
      evid: data['evid'] ?? '',
      topic: data['topic'] ?? '',
      description: data['description'] ?? '',
      cid: data['cid'] ?? '',
      voters: data['voters'] ?? [],
      options: data['options'] ?? [],
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
      startTimestamp: data['startTimestamp'] ?? Timestamp.now(),
      endTimestamp: data['endTimestamp'] ?? Timestamp.now(),
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'evid': evid,
      'topic': topic,
      'description': description,
      'cid': cid,
      'voters': voters,
      'options': options,
      'creationTimestamp': creationTimestamp,
      'startTimestamp': startTimestamp,
      'endTimestamp': endTimestamp,
      'type': type,
    };
  }

  static CollectionReference<PollEvent> get collection => FirebaseFirestore.instance.collection('events').withConverter(
      fromFirestore: PollEvent.fromFirestore,
      toFirestore: (PollEvent event, _) => event.toFirestore()
  );
}