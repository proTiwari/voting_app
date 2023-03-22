import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voting_app/screens/companies.dart';
import 'package:voting_app/screens/homescreen.dart';
import 'package:voting_app/screens/me.dart';

import '../flutterflow/flutter_flow_theme.dart';

class CustomBottomNavigation extends StatefulWidget {
  CustomBottomNavigation();

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late int pageIndex = 0;

  final pages = [
    HomeScreen(),
    Companies(),
    Me()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          leading: null,
          backgroundColor:Color.fromARGB(220, 59, 58, 58),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: pages[pageIndex],
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 8 : width * 0.24),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 80,
                height: 60,
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/home.png",color: Color.fromARGB(220, 59, 58, 58),
                        height: 30,
                      ),
                      Text(
                        "Home",
                        style: GoogleFonts.poppins(
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 60,
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/group.png",color: Color.fromARGB(220, 59, 58, 58),
                        height: 30,
                      ),
                      Text(
                        "Companies",
                        style: GoogleFonts.poppins(
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 60,
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/user.png",color: Color.fromARGB(220, 59, 58, 58),
                        height: 30,
                      ),
                      Text(
                        "Me",
                        style: GoogleFonts.poppins(
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
