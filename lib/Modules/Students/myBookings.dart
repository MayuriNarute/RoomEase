import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ss/Modules/Students/studentsLanding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../feedback.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> data = {};
  Future<void> fetchHostelDetails() async {
    final CollectionReference ref = FirebaseFirestore.instance.collection("Students");
    String propertyId = '';
    String ownerId = '';
    String propertyName = '';
    QuerySnapshot snapshot = await ref.where("userId", isEqualTo: "${currentUser}").get();
    if (snapshot.docs.isNotEmpty) {
      propertyName = snapshot.docs.first["propertyName"] as String? ?? ''; // Handle null value
      ownerId = snapshot.docs.first["ownerId"] as String? ?? ''; // Handle null value
    }

    final CollectionReference reff = FirebaseFirestore.instance.collection("Owners");
    QuerySnapshot snapshott = await reff.where("userId", isEqualTo: "${ownerId}").get();
    if (snapshott.docs.isNotEmpty) {
      CollectionReference ref = snapshott.docs.first.reference.collection("Properties");
      QuerySnapshot sn = await ref.where("propertyName", isEqualTo: "${propertyName}").get();
      if (sn.docs.isNotEmpty) {
        setState(() {
          data = sn.docs.first.data() as Map<String, dynamic>;
        });
      }
    }
    print(data.keys);
  }
Future<void> init()async{
    await fetchHostelDetails();
}
  _callNumber(mobileNum) async {
    var number = '${mobileNum}'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print(res);
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHostelDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Students")
                  .where("userId", isEqualTo: "${currentUser}")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var newValue = snapshot.data;
                var isRequested = newValue!.docs.first["isRequested"];
                if (isRequested == "true") {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("Your Request is not Accepted yet.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      )
                    ],
                  );
                } else if(isRequested == "accepted") {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("My Hostel",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:28),),
                          )),
                         Material(
                           elevation: 5,
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(

                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   children: [
                                     Text("Hostel Details",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15,),),
                                     Divider(),
                                     Text("Hostel Name:- ${data["propertyName"]}"),
                                     Text("Region:- ${data["subregion"]}"),
                                     Text("Address:- ${data["address"]}"),
                                    Padding(

                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(onTap: () async {
                                            _callNumber(data["mobileNum"]);
                                            print(data.keys);
                                          },child: Icon(Icons.call)),
                                          ElevatedButton(style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(Colors.black),foregroundColor: MaterialStatePropertyAll(Colors.white)
                                          ),onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => feedBackPage(ownerId: data["ownerId"],propertyId: data["propertyId"],),));
                                          }, child: Text("Feedback")),
                                          InkWell( onTap: () async {
                                            final Uri smsLaunchUri = Uri(
                                              scheme: 'sms',
                                              path: '${data["mobileNum"]}',
                                              queryParameters: <String, String>{
                                                'body':
                                                "Enter your message",
                                              },
                                            );
                                            launchUrl(smsLaunchUri);
                                            // }
                                          },child: Icon(Icons.message)),
                                        ],
                                      ),
                                    )
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         )

                        ],
                      ),
                    ),
                  );
                }else if(isRequested == "declined"){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text("Your Request is Declined",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),)),
                    ],
                  );
                }else{
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Bookings Found as of Now",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(height: 20,),
                        ElevatedButton(style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.black),
                          foregroundColor: MaterialStatePropertyAll(Colors.white)
                        ),onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StudentsLanding(),), (route) => false);
                        }, child: Text("Book Now"))
                      ],
                    ),
                  );
                }
              })),
    );
  }
}
