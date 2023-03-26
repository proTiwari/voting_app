import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/services/app_state.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(AppState().address)
                .snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(children: [
                      const SizedBox(height: 24),
                      buildName(snapshot.data!.data()!['name'],
                          snapshot.data!.data()!['email']),
                      const SizedBox(height: 24),
                      const SizedBox(height: 24),
                      const SizedBox(height: 48),
                      // buildAbout(),
                    ]),
                  );
                },
              );
            }),
      ),
    );
  }

  Widget buildName(name, email) => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

 
}
