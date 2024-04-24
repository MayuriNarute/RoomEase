import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Authentication/Presentation/login.dart';
import '../../Authentication/Presentation/registerScreen.dart';
import 'booking.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName  = '';
  Future<void> fetchName ()async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference ref = FirebaseFirestore.instance.collection("Students");
    final QuerySnapshot snap = await ref.where("userId",isEqualTo: "${_auth.currentUser!.uid}").get();
    if(snap.docs.isNotEmpty){
      String name = snap.docs.first["FirstName"];
      setState(() {
        userName = name;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchName();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(

          children: [
            SizedBox(height: 50,),
            OwnersBookingPage(),
            ElevatedButton(onPressed: ()async{
              final FirebaseAuth _auth = FirebaseAuth.instance;
              await _auth.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage() ,), (route) => false);
              });
            }, child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
