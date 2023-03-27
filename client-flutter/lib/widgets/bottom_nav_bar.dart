import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voting_app/screens/companies.dart';
import 'package:voting_app/screens/homescreen.dart';
import 'package:voting_app/screens/me.dart';
import 'package:get/get.dart';

import '../screens/invitation_action_screen.dart';

class CustomBottomNavigation extends StatefulWidget {
  String? inviteId;
  CustomBottomNavigation({inviteId, super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late int currentPageIndex = 0;

  final pages = [HomeScreen(), Companies(), Me()];

  @override
  void initState() {
    super.initState();
    print("init state called: ${widget.inviteId}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.inviteId != null){
        Get.to(InvitationActionScreen(widget.inviteId!));
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
