import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreFunctions {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var firestore = FirebaseFirestore.instance;
  
}
