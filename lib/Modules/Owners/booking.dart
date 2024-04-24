

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss/Modules/Admin/pdfViewer.dart';

import '../../Authentication/Presentation/login.dart';

class OwnersBookingPage extends StatefulWidget {
  const OwnersBookingPage({super.key});

  @override
  State<OwnersBookingPage> createState() => _OwnersBookingPageState();
}

class _OwnersBookingPageState extends State<OwnersBookingPage> {
  List<Map<String,dynamic>> requests = [];
List<String> names = [];
  Future<void> fetchRequests() async {
    requests.clear();
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final CollectionReference ref =
      FirebaseFirestore.instance.collection("Owners");
      QuerySnapshot snapshot = await ref
          .where("userId", isEqualTo: _auth.currentUser!.uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        CollectionReference requestsCol =
        snapshot.docs.first.reference.collection("Requests");
        QuerySnapshot snapshott = await requestsCol.get();

        List<Map<String, dynamic>> newRequests = [];

        for (var docs in snapshott.docs) {
          newRequests.add(docs.data() as Map<String, dynamic>);
          String currentName = await fetchName(docs["customerId"]);
          String req = docs["status"];
          if(req=="pending"){
            names.add(currentName);
            print("current name is ");
          }


        }

        setState(() {
          // Assuming requests is a List<Map<String, dynamic>>
          requests.clear(); // Clear previous requests
          requests.addAll(newRequests);
        });
        print(requests.first);
      }
    } catch (e) {
      print("Error fetching requests: $e");
      // Handle error, show error message or retry logic
    }
  }
  Future<String>fetchName (userId)async{
    final CollectionReference ref = FirebaseFirestore.instance.collection("Students");
    QuerySnapshot snapshot = await ref.where("userId",isEqualTo: "${userId}").get();
    if(snapshot.docs.isNotEmpty){
      String name = snapshot.docs.first["FirstName"];
      return name;
    }else{
      return "nul";
    }
  }
  Future<void> init()async{
    await fetchRequests()
;  }
  
  Future<void> acceptRequest(userId)async{
    final CollectionReference ref = FirebaseFirestore.instance.collection("Students");
    QuerySnapshot snapshot = await ref.where("userId",isEqualTo: "${userId}").get();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if(snapshot.docs.isNotEmpty){
      await snapshot.docs.first.reference.update({
        "isRequested":"accepted",
      });
      print("acce");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Booking Confirmed")));
      final CollectionReference ref =
      FirebaseFirestore.instance.collection("Owners");
      QuerySnapshot snapshotO = await ref
          .where("userId", isEqualTo: _auth.currentUser!.uid)
          .get();
      print("updating noe");
      print("${userId}");

        CollectionReference delet = await snapshotO.docs.first.reference.collection("Requests");
        QuerySnapshot sn = await delet.where("customerId",isEqualTo: "${userId}").get();
        if(sn.docs.isNotEmpty){
          await sn.docs.first.reference.delete();
          print("deleted");
          await fetchRequests();
        }else {
          print("empty");
          await fetchRequests();
        }


    }else{
      print("snashot empty to accept");
    }
  }
  Future<void> declineRequest(userId)async{
    final CollectionReference ref = FirebaseFirestore.instance.collection("Students");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    QuerySnapshot snapshot = await ref.where("userId",isEqualTo: "${userId}").get();
    if(snapshot.docs.isNotEmpty){
      await snapshot.docs.first.reference.update({
        "isRequested":"declined",
      });
      print("acce");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Booking Declined")));
      final CollectionReference ref =
      FirebaseFirestore.instance.collection("Owners");
      QuerySnapshot snapshotO = await ref
          .where("userId", isEqualTo: _auth.currentUser!.uid)
          .get();
      print("updating noe");
      print("${userId}");

      CollectionReference delet = await snapshotO.docs.first.reference.collection("Requests");
      QuerySnapshot sn = await delet.where("customerId",isEqualTo: "${userId}").get();
      if(sn.docs.isNotEmpty){
        await sn.docs.first.reference.delete();
        print("deleted");
        await fetchRequests();
      }else {
        print("empty");
        await fetchRequests();
      }
    }else{
      print("snashot empty to accept");
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRequests();
    init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchRequests,
          child: ListView(
            children: [Column(
            // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Requests",style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 25
                    ),),
                  ),
                ),
            if(requests.length==0)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("No Requests as of Know"),
                  ],
                ),
              ),
                if(requests.length!=0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 550,
                  child: ListView.builder(itemCount: requests.length,itemBuilder: (context, index) {

                    return Material(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width-50,
                        height: 100,
                        decoration: BoxDecoration(

                        ),
                          child: Column(
                            children: [
                              Text("Property Name:- ${requests[index]["propertyName"]}"),
                              Text("Customer Name:- ${names[index]}"),
                              SizedBox(height: 15,),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap:()async{
                                        await acceptRequest(requests[index]["customerId"]);
                                      },
                                      child: Container(
                                        height:40,
                                        width: 100,
                                        child: Center(child: Text("Confirm",style: TextStyle(
                                          fontWeight: FontWeight.bold,fontSize: 15
                                        ),)),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.grey),
                                          color: Colors.green.shade300,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    InkWell(
                                      onTap:()async{
                                        String pdfUrl = '';
                                        final CollectionReference ref = FirebaseFirestore.instance.collection("Users");
                                        QuerySnapshot snapshot = await ref.where("userId",isEqualTo: "${requests[index]['customerId']}").get();
                                        if(snapshot.docs.isNotEmpty){
                                           pdfUrl = snapshot.docs.first["collegeIdentityUrl"];
                                           print(pdfUrl);
                                           Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewer(collegeIdentityUrl: pdfUrl),));
                                        }
                                      },
                                      child: Container(
                                        height:40,
                                        width: 100,
                                        child: Center(child: Text("Identity Card",style: TextStyle(
                                            fontWeight: FontWeight.bold,fontSize: 15
                                        ),)),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.5,color: Colors.grey),
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    InkWell(
                                      onTap:()async{
                                        await acceptRequest(requests[index]["customerId"]);
                                      },
                                      child: Container(
                                        height:40,
                                        width: 100,
                                        child: Center(child: Text("Decline",style: TextStyle(
                                            fontWeight: FontWeight.bold,fontSize: 15
                                        ),)),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.5,color: Colors.grey),
                                            color: Colors.red.shade300,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    );
                  },),
                ),
              ),

                if(requests.length==0)
                  SizedBox(height:300,),
                Container(
                  width: 150,
                  child: ElevatedButton(style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                    backgroundColor: MaterialStatePropertyAll(Colors.white)
                  ),onPressed: ()async{


                    //function to logout the user
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    await _auth.signOut().then((value) {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage() ,), (route) => false);
                    });
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logout",style: TextStyle(fontWeight: FontWeight.bold),),
                      Icon(Icons.logout,color: Colors.red,)
                    ],
                  )),
                )
              ],
            )],
          ),
        ),
      ),
    );
  }
}
