// create a class ElectionEvent with firestore from factory and to factory
// Path: lib\objects\ElectionEvent.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import 'CompanySummary.dart';

class ElectionEvent {
  final String evid;
  final String topic;
  final String description;
  final String cid;
  final List<String> voters;
  final List<String> candidates;
  final Timestamp creationTimestamp;
  final Timestamp startTimestamp;
  final Timestamp endTimestamp;
  final CompanySummary companyData;
  final String type = 'election';

  ElectionEvent({
    required this.evid,
    required this.topic,
    required this.description,
    required this.cid,
    required this.voters,
    required this.candidates,
    required this.creationTimestamp,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.companyData,
  });

  factory ElectionEvent.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    Map data = snapshot.data() as Map;
    return ElectionEvent(
      evid: data['evid'] ?? '',
      topic: data['topic'] ?? '',
      description: data['description'] ?? '',
      cid: data['cid'] ?? '',
      voters: data['voters'] ?? [],
      candidates:
          (data['candidates'] as List?)?.map((i) => i as String).toList() ?? [],
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
      'candidates': candidates,
      'creationTimestamp': creationTimestamp,
      'startTimestamp': startTimestamp,
      'endTimestamp': endTimestamp,
      'type': type,
      'companyData': companyData.toFirestore(),
    };
  }

  static CollectionReference<ElectionEvent> get collection =>
      FirebaseFirestore.instance.collection('events').withConverter(
          fromFirestore: ElectionEvent.fromFirestore,
          toFirestore: (ElectionEvent event, _) => event.toFirestore());
}
