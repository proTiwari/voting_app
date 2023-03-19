import 'package:flutter/material.dart';

class HomeStreen extends StatefulWidget {
  const HomeStreen({super.key});

  @override
  State<HomeStreen> createState() => _HomeStreenState();
}

class _HomeStreenState extends State<HomeStreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      
      floatingActionButton: IconButton(icon: const Icon(Icons.add), onPressed: () {
        
       },),
    );
  }
}