// create a class PollEvent with firestore from factory and to factory
// Path: lib\objects\PollEvent.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import 'CompanySummary.dart';

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
  final CompanySummary companyData;
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
    required this.companyData,
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
      voters: (data['voters'] as List?)?.map((i) => i as String).toList() ?? [],
      options: (data['options'] as List?)?.map((i) => i as String).toList() ?? [],
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
      startTimestamp: data['startTimestamp'] ?? Timestamp.now(),
      endTimestamp: data['endTimestamp'] ?? Timestamp.now(),
      companyData: CompanySummary.fromMap(data['companyData']),
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
      'companyData': companyData.toFirestore(),
    };
  }

  static CollectionReference<PollEvent> get collection => FirebaseFirestore.instance.collection('events').withConverter(
      fromFirestore: PollEvent.fromFirestore,
      toFirestore: (PollEvent event, _) => event.toFirestore()
  );

  EventStatus computeEventStatus() {
    if (endTimestamp.toDate().isBefore(DateTime.now())) {
      return EventStatus.expired;
    } else if (startTimestamp.toDate().isAfter(DateTime.now())) {
      return EventStatus.coming;
    } else {
      return EventStatus.active;
    }
  }
}

enum EventStatus { coming, active, expired }