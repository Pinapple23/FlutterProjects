// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hello You are signed in',
          style: TextStyle(fontSize: 22),
        ),
        Text(
          user.email!,
          style: TextStyle(fontSize: 22),
        ),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          color: Colors.amber[900],
          child: Text('Sign Out'),
        )
      ],
    )));
  }
}
