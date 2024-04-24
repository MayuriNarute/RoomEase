// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss/Modules/Admin/pdfViewer.dart';
import 'package:ss/ownerOrStudent.dart';

class StudentsVerification extends StatefulWidget {
  const StudentsVerification({super.key});

  @override
  State<StudentsVerification> createState() => _StudentsVerificationState();
}

class _StudentsVerificationState extends State<StudentsVerification> {
  List<Map<String, dynamic>> hi = [];
  bool isLoading = false;

  Future<void> studentsVerification() async {
    setState(() {
      isLoading = true;
    });
    print("object");
    hi.clear();
    try {
      final CollectionReference ref =
          FirebaseFirestore.instance.collection("Users");
      QuerySnapshot snapshot =
          await ref.where("isVerified", isEqualTo: false).get();
      if (snapshot.docs.isNotEmpty) {
        print("got the docs");
        for (var docs in snapshot.docs) {
          hi.add(docs.data() as Map<String, dynamic>);
          print("added");
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Pending Requests!")));
      }
    }  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    setState(() {
      isLoading = false;
    });
  }
Future<void> updateVerificationStatus(userId)async{
    try {
      final CollectionReference ref = FirebaseFirestore.instance.collection("Users");
      QuerySnapshot snapshot  = await ref.where("userId",isEqualTo: "${userId}").get();
      if(snapshot.docs.isNotEmpty){
        print("it is not empty");
        await snapshot.docs.first.reference.update({
          "isVerified":true,
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
      }
    }  catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Eroor")));
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: studentsVerification,
            child: ListView(
              children:[ Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Admin",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: hi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "User Id:-  ${hi[index]["userId"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Status:- ${hi[index]["isVerified"] == false ? "Not Verified" : "Verified"}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 35,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.black),
                                                foregroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.white)),
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder:(context) => PdfViewer(collegeIdentityUrl:hi[index]['identityVerification'],),));
                                            },
                                            child: Text("View Document")),
                                      ),
                                      Container(
                                        height: 35,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.green),
                                                foregroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.black)),
                                            onPressed: () {
                                              updateVerificationStatus(hi[index]["userId"]);
                                            },
                                            child: Text("Approve")),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final FirebaseAuth auth= FirebaseAuth.instance;
                        await auth.signOut().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseOwnerOrStudent(),)));
                      },
                      child: Text("Log Out")),
                ],
              )],
            ),
          ),
        ),
      ),
    );
  }
}
