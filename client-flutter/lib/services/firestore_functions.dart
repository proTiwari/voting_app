import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/objects/AppUser.dart';
import 'package:voting_app/objects/Company.dart';
import 'package:voting_app/objects/Invite.dart';
import 'package:voting_app/objects/PollEvent.dart';
import '../objects/ElectionEvent.dart';
import '../objects/EmployeeSummary.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class FirestoreFunctions {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  var firestore = FirebaseFirestore.instance;

  // Create a new user in the database
  Future<void> createUser({
    required String name,
    required String address,
    required String email,
    required String uid,
  }) async {
    final user = AppUser(
      name: name,
      address: address,
      email: email.trim().toLowerCase(),
      uid: uid,
      creationTimestamp: Timestamp.now(),
      companies: [],
      companyData: {},
    );
    await AppUser.collection.doc(user.uid).set(user);
  }

  // Create a new company in the database
  Future<void> createCompany(String cin, String name, String eid) async {
    final companyDocRef = Company.collection.doc();
    final company = Company(
      cid: companyDocRef.id,
      cin: cin,
      creationTimestamp: Timestamp.now(),
      name: name,
      admin: uid!,
      users: [uid!],
      events: [],
      empData: {
        '$uid': EmployeeSummary(
          uid: uid!,
          name: FirebaseAuth.instance.currentUser!.displayName!,
          email: FirebaseAuth.instance.currentUser!.email!,
          eid: eid,
        )
      },
    );
    final batch = firestore.batch();
    batch.set(Company.collection.doc(company.cid), company);
    batch.update(AppUser.collection.doc(uid), {
      'companies': FieldValue.arrayUnion([company.cid]),
      'companyData.${company.cid}': company.getCompanySummary().toFirestore(),
    });
    await batch.commit();
  }

  // Create a new event with type poll in the database
  Future<void> createPollEvent({
    required String topic,
    required String description,
    required List<String> options,
    required List<String> voters,
    required Timestamp startTimestamp,
    required Timestamp endTimestamp,
    required String cid,
  }) async {
    final eventDocRef = PollEvent.collection.doc();

    await firestore.runTransaction<PollEvent>((transaction) async {
      final companyDoc = await transaction.get(Company.collection.doc(cid));
      if (companyDoc.exists) {
        final company = companyDoc.data() as Company;
        PollEvent event = PollEvent(
          evid: eventDocRef.id,
          topic: topic,
          description: description,
          options: options,
          startTimestamp: startTimestamp,
          endTimestamp: endTimestamp,
          cid: cid,
          voters: voters,
          creationTimestamp: Timestamp.now(),
          companyData: company.getCompanySummary(),
        );
        transaction.set(eventDocRef, event);
        transaction.update(Company.collection.doc(event.cid), {
          'events': FieldValue.arrayUnion([event.evid])
        });

        return event;
      } else {
        throw Exception('Company does not exist');
      }
    });
  }

  // Create a new event with type election in the database
  Future<void> createElectionEvent({
    required String topic,
    required String description,
    required List<String> candidates,
    required List<String> voters,
    required Timestamp startTimestamp,
    required Timestamp endTimestamp,
    required String cid,
  }) async {
    final eventDocRef = ElectionEvent.collection.doc();

    await firestore.runTransaction<ElectionEvent>((transaction) async {
      final companyDoc = await transaction.get(Company.collection.doc(cid));
      if (companyDoc.exists) {
        final company = companyDoc.data() as Company;
        ElectionEvent event = ElectionEvent(
          evid: eventDocRef.id,
          topic: topic,
          description: description,
          candidates: candidates,
          startTimestamp: startTimestamp,
          endTimestamp: endTimestamp,
          cid: cid,
          voters: voters,
          creationTimestamp: Timestamp.now(),
          companyData: company.getCompanySummary(),
        );
        transaction.set(eventDocRef, event);
        transaction.update(Company.collection.doc(event.cid), {
          'events': FieldValue.arrayUnion([event.evid])
        });

        return event;
      } else {
        throw Exception('Company does not exist');
      }
    });
  }

  // get all active events from the collection events
  Future<List<dynamic>> getActiveEvents() async {
    final eventsCollRef = FirebaseFirestore.instance.collection('events');
    List<dynamic> events = [];
    Timestamp now = Timestamp.now();
    var snapshot =
        await eventsCollRef.where('endTimestamp', isGreaterThan: now).get();
    final filteredDocs = snapshot.docs.where(
        (doc) => now.compareTo(doc.data()['startTimestamp'] as Timestamp) >= 0);
    for (var doc in filteredDocs) {
      if (doc.data()['type'] == 'poll') {
        PollEvent event = PollEvent.fromFirestore(doc, null);
        if (event.voters.contains(uid)) {
          events.add(event);
        }
      } else if (doc.data()['type'] == 'election') {
        ElectionEvent event = ElectionEvent.fromFirestore(doc, null);
        if (event.voters.contains(uid) || event.candidates.contains(uid)) {
          events.add(event);
        }
      }
    }
    return events;
  }

  // get all events from the collection events where cid is equal to the given company id
  Future<List<dynamic>> getAllCompanyEvents(String cid) async {
    final eventsCollRef = FirebaseFirestore.instance.collection('events');
    List<ElectionEvent> events = [];
    var snapshot = await eventsCollRef.where('cid', isEqualTo: cid).get();
    for (var doc in snapshot.docs) {
      // if(doc.data()['type'] == 'poll') {
      //   events.add(PollEvent.fromFirestore(doc, null));
      // } else if (doc.data()['type'] == 'election') {
      //   events.add(ElectionEvent.fromFirestore(doc, null));
      // }
      events.add(ElectionEvent.fromFirestore(doc, null));
    }
    return events;
  }

  // get all companies from the collection companies where uid is equal to firebase user uid
  Future<List<Company>> getCompanies() async {
    List<Company> companies = [];
    var snapshot =
        await Company.collection.where('users', arrayContains: uid).get();
    for (var doc in snapshot.docs) {
      companies.add(doc.data());
    }
    return companies;
  }

  // get a event from the collection events where evid is equal to the given event id
  Future<dynamic> getEvent(String evid) async {
    final eventsCollRef = FirebaseFirestore.instance.collection('events');
    var snapshot = await eventsCollRef.doc(evid).get();
    if (snapshot.data() == null) return null;

    if (snapshot.data()!['type'] == 'poll') {
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
  Future<void> inviteUser(String companyEmail, String cid, String eid) async {
    if (uid == null) return;
    final docRef = Invite.collection.doc();

    // run transaction and get company data
    final invitation =
        await firestore.runTransaction<Invite>((transaction) async {
      final companyDoc = await transaction.get(Company.collection.doc(cid));
      if (companyDoc.exists) {
        final company = companyDoc.data() as Company;
        final invite = Invite(
            companyEmail: companyEmail,
            cid: cid,
            uid: uid!,
            inviteId: docRef.id,
            creationTimestamp: Timestamp.now(),
            actionTimestamp: null,
            status: InviteStatus.pending,
            companyData: company.getCompanySummary(),
            employeeData: EmployeeSummary(
              uid: uid!,
              name: (await getUser())!.name,
              email: companyEmail,
              eid: eid,
            ));
        transaction.set(docRef, invite);
        return invite;
      } else {
        throw Exception('Company does not exist');
      }
    });

    // send email with sendgrid_mailer library
    final mailer = Mailer(dotenv.env['SENDGRID_API_KEY']!);
    final toAddress = Address(invitation.companyEmail);
    const fromAddress = Address('proshubham5@gmail.com');
    final content = Content(
        'text/plain',
        'You have been invited to join a company ${invitation.companyData.name} ${invitation.companyData.cin.isNotEmpty ? '(${invitation.companyData.cin})' : ''} on the app. Click the link below to accept the invite. \n\n'
            'https://evotingapp.page.link/invite-member/${invitation.inviteId}');
    final subject =
        'Invite to join a company ${invitation.companyData.name} ${invitation.companyData.cin.isNotEmpty ? '(${invitation.companyData.cin})' : ''}';
    final personalization = Personalization([toAddress]);

    final email =
        Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      print(result);
    }).catchError((onError) {
      print('error');
    });
  }

  // function to accept an invite
  Future<void> acceptInvite(Invite invite) async {
    if (uid == null) return;
    await firestore.runTransaction((transaction) async {
      final inviteDoc =
          await transaction.get(Invite.collection.doc(invite.inviteId));
      final userDoc = await transaction.get(AppUser.collection.doc(uid));
      if (userDoc.exists && inviteDoc.exists) {
        final invite = inviteDoc.data() as Invite;
        transaction.update(Invite.collection.doc(invite.inviteId), {
          'status': InviteStatus.accepted.name,
          'actionTimestamp': Timestamp.now()
        });
        if (userDoc.data()!.companies.contains(invite.cid)) return;
        transaction.update(AppUser.collection.doc(uid), {
          'companies': FieldValue.arrayUnion([invite.cid]),
          'companyData.${invite.cid}': invite.companyData.toFirestore(),
        });
        transaction.update(Company.collection.doc(invite.cid), {
          'users': FieldValue.arrayUnion([uid]),
          'empData.$uid': invite.employeeData.toFirestore(),
        });
      } else {
        throw Exception('Invite does not exist');
      }
    });
  }

  // function to decline an invite
  Future<void> declineInvite(String inviteId) async {
    if (uid == null) return;
    await Invite.collection.doc(inviteId).update({
      'status': InviteStatus.rejected.name,
      'actionTimestamp': Timestamp.now()
    });
  }

  // function to get all invites from the collection invites where the company email is equal to the given company email
  Future<List<Invite>> getMyInvites() async {
    List<Invite> invites = [];
    var snapshot = await Invite.collection.where('uid', isEqualTo: uid).get();
    for (var doc in snapshot.docs) {
      invites.add(Invite.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>, null));
    }
    return invites;
  }

  // getInvite function to get an invite from the collection invites where the invite id is equal to the given invite id
  Future<Invite?> getInvite(String inviteId) async {
    print('getInvite: $inviteId');
    var snapshot = await Invite.collection.doc(inviteId).get();
    print('getInvite: $snapshot ${snapshot.data()}');
    return snapshot.data();
  }

  // function to get all members of a company
  Future<List<EmployeeSummary>> getCompanyMembers(String cid) async {
    var snapshot = await Company.collection.doc(cid).get();
    return snapshot.data()!.empData.values.toList();
  }
}
