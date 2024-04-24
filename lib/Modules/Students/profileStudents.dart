import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ss/Authentication/Presentation/login.dart';

import '../../Authentication/Presentation/registerScreen.dart';
class StudentsProfilePage extends StatefulWidget {
  const StudentsProfilePage({super.key});

  @override
  State<StudentsProfilePage> createState() => _StudentsProfilePageState();
}

class _StudentsProfilePageState extends State<StudentsProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(onPressed: ()async{
              final FirebaseAuth _auth = FirebaseAuth.instance;
              await _auth.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage() ,), (route) => false);
              });
            }, child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
