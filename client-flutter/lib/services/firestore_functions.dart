import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/objects/AppUser.dart';
import 'package:voting_app/objects/Company.dart';
import 'package:voting_app/objects/Invite.dart';
import 'package:voting_app/objects/PollEvent.dart';
import '../objects/ElectionEvent.dart';

class FirestoreFunctions {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  var firestore = FirebaseFirestore.instance;

  // Create a new user in the database
  Future<void> createUser(AppUser user) async {
    await AppUser.collection.doc(user.uid).set(user);
  }

  // Create a new company in the database
  Future<void> createCompany(Company company) async {
    final batch = firestore.batch();
    batch.set(Company.collection.doc(company.cid), company);
    batch.update(AppUser.collection.doc(uid), {
      'companies': FieldValue.arrayUnion([company.cid])
    });
    await batch.commit();
  }

  // Create a new event with type poll in the database
  Future<void> createPollEvent(PollEvent event) async {
    final batch = firestore.batch();
    batch.set(PollEvent.collection.doc(event.evid), event);
    batch.update(Company.collection.doc(event.cid), {
      'events': FieldValue.arrayUnion([event.evid])
    });
    await batch.commit();
  }

  // Create a new event with type election in the database
  Future<void> createElectionEvent(ElectionEvent event) async {
    final batch = firestore.batch();
    batch.set(ElectionEvent.collection.doc(event.evid), event);
    batch.update(Company.collection.doc(event.cid), {
      'events': FieldValue.arrayUnion([event.evid])
    });
    await batch.commit();
  }

  // get all active events from the collection events
  Future<List<dynamic>> getActiveEvents() async {
    final eventsCollRef = FirebaseFirestore.instance.collection('events');
    List<dynamic> events = [];
    Timestamp now = Timestamp.now();
    var snapshot = await eventsCollRef.where('endTimestamp', isGreaterThan: now).get();
    final filteredDocs = snapshot.docs.where((doc) => now.compareTo(doc.data()['startTimestamp'] as Timestamp) >= 0);
    for (var doc in filteredDocs) {
      if(doc.data()['type'] == 'poll') {
        PollEvent event = PollEvent.fromFirestore(doc, null);
        if(event.voters.contains(uid)) {
          events.add(event);
        }
      } else if (doc.data()['type'] == 'election') {
        ElectionEvent event = ElectionEvent.fromFirestore(doc, null);
        if(event.voters.contains(uid) || event.candidates.contains(uid)) {
          events.add(event);
        }
      }
    }
    return events;
  }

  // get all events from the collection events where cid is equal to the given company id
  Future<List<dynamic>> getAllCompanyEvents(String cid) async {
    final eventsCollRef = FirebaseFirestore.instance.collection('events');
    List<dynamic> events = [];
    var snapshot = await eventsCollRef.where('cid', isEqualTo: cid).get();
    for (var doc in snapshot.docs) {
      if(doc.data()['type'] == 'poll') {
        events.add(PollEvent.fromFirestore(doc, null));
      } else if (doc.data()['type'] == 'election') {
        events.add(ElectionEvent.fromFirestore(doc, null));
      }
    }
    return events;
  }

  // get all companies from the collection companies where uid is equal to firebase user uid
  Future<List<Company>> getCompanies() async {
    List<Company> companies = [];
    var snapshot = await Company.collection.where('users', arrayContains: uid).get();
    for (var doc in snapshot.docs) {
      companies.add(Company.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null));
    }
    return companies;
  }

  // get a event from the collection events where evid is equal to the given event id
  Future<dynamic> getEvent(String evid) async {
    final eventsCollRef = FirebaseFirestore.instance.collection('events');
    var snapshot = await eventsCollRef.doc(evid).get();
    if(snapshot.data() == null) return null;

    if(snapshot.data()!['type'] == 'poll') {
      return PollEvent.fromFirestore(snapshot, null);
    } else if (snapshot.data()!['type'] == 'election') {
      return ElectionEvent.fromFirestore(snapshot, null);
    }
  }

  // get a company from the collection companies where cid is equal to the given company id
  Future<Company?> getCompany(String cid) async {
    var snapshot = await Company.collection.doc(cid).get();
    return snapshot.data();
  }

  // get a user from the collection users where uid is equal to firebase user uid
  Future<AppUser?> getUser() async {
    var snapshot = await AppUser.collection.doc(uid).get();
    return snapshot.data();
  }

  // function to invite a user to a company
  Future<void> inviteUser(String companyEmail, String cid) async {
    if(uid == null) return;
    final docRef = Invite.collection.doc();
    final invite = Invite(
      companyEmail: companyEmail,
      cid: cid,
      uid: uid!,
      inviteId: docRef.id,
      creationTimestamp: Timestamp.now(),
      actionTimestamp: null,
      status: InviteStatus.pending
    );
    await docRef.set(invite);

    // TODO: send email
    /*final email = Email(
      body: 'You have been invited to join a company on the app. Click the link below to accept the invite. \n\n'
          'https://voting-app-9f3e5.web.app/invite/${invite.inviteId}',
      subject: 'Invite to join a company',
      recipients: [companyEmail],
      isHTML: false,
    );*/
  }

  // function to accept an invite
  Future<void> acceptInvite(Invite invite) async {
    if(uid == null) return;
    final batch = firestore.batch();
    batch.update(Invite.collection.doc(invite.inviteId), {
      'status': InviteStatus.accepted.name,
      'actionTimestamp': Timestamp.now()
    });
    batch.update(AppUser.collection.doc(uid), {
      'companies': FieldValue.arrayUnion([invite.cid])
    });
    batch.update(Company.collection.doc(invite.cid), {
      'users': FieldValue.arrayUnion([uid])
    });
    await batch.commit();
  }

  // function to decline an invite
  Future<void> declineInvite(Invite invite) async {
    if(uid == null) return;
    await Invite.collection.doc(invite.inviteId).update({
      'status': InviteStatus.rejected.name,
      'actionTimestamp': Timestamp.now()
    });
  }

  // function to get all invites from the collection invites where the company email is equal to the given company email
  Future<List<Invite>> getMyInvites() async {
    List<Invite> invites = [];
    var snapshot = await Invite.collection.where('uid', isEqualTo: uid).get();
    for (var doc in snapshot.docs) {
      invites.add(Invite.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null));
    }
    return invites;
  }
}
