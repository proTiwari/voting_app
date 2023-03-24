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
  late int currentPageIndex = 0;

  final pages = [HomeScreen(), Companies(), Me()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Companies',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
      body: <Widget>[HomeScreen(), const Companies(), Me()][currentPageIndex],
    );
  }
}
