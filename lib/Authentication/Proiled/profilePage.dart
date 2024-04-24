import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../Modules/Students/myBookings.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isLoading = false;
  bool isFetchingProfile = false;
  bool isUploading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  void signOut() async {
    await auth.signOut().then((value) => Navigator.pushNamedAndRemoveUntil(
        context, Navigator.defaultRouteName, (route) => false));
    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(backgroundColor: Colors.green,content: Text("Logged Off",)),
    );
  }


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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child:Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [


                          Container(
                            width: 350,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Hi,  \n  ${userName}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                SizedBox(
                                  width: 20,
                                ),

                                CircleAvatar(child: Icon(Icons.person,size: 30,),radius: 30,)


                              ],
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              smallContainer(Icons.help, "Help"),
                              smallContainer(Icons.feedback_rounded, "Feedback")
                            ],
                          ),
                          Divider(),
                          Column(
                            children: [
                              listWidgtes(Icons.message, "Messages / Support"),
                              InkWell(onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBookings(),));
                              },child: listWidgtes(Icons.person, "My Hostel / Bookings")),
                              listWidgtes(Icons.settings_suggest_rounded,
                                  "Settings"),
                              listWidgtes(Icons.rule, "Legal"),
                              // listWidgtes(AboutUS(), Icons.info_rounded, "About Us"),
                            ],
                          ),
                          Divider(),
                          Container(
                            width: 400,
                            child: AboutListTile(
                              applicationName: "Room Ease",
                              applicationVersion:"1.0.0.1",
                              applicationLegalese: "© 2024 RoomEase.",
                              dense: true,
                              icon:Icon(Icons.info,size:31,color: Colors.black,),
                              child: Text("About Us",style: TextStyle(fontSize: 14)),
                              // applicationIcon: Image.asset("assets/images/icon.jpg",width:80),
                              aboutBoxChildren: [

                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                // color: Colors.grey,
                              ),
                              child: InkWell(
                                onTap: () {
                                  signOut();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, size:31),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Log Out"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget smallContainer(IconData icon, t) {
    return InkWell(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[300],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon),
              Text("${t}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget listWidgtes(IconData i, text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          // color: Colors.grey,
        ),

          child: Row(
            children: [
              Icon(i, size: 35),
              SizedBox(
                width: 20,
              ),
              Text("${text}"),
            ],
          ),
        ),

    );
  }
}


