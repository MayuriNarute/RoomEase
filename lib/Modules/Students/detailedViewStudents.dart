

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:url_launcher/url_launcher.dart';

class studentsPgDetailedView extends StatefulWidget {
  List<dynamic> urls = [];
  List<dynamic> amenities = [];
  List<dynamic> rooms = [];
  String name = '';
  String des = '';
  String mobileNum = '';
  String propertyId = '';
  String ownerId = '';
  List<dynamic> feedbacks = [];
  studentsPgDetailedView(
      {required this.propertyId,required this.mobileNum,
      required this.name,
      required this.des,
      required this.amenities,
      required this.rooms,
      required this.urls,
        required this.ownerId,
        required this.feedbacks,
      super.key});

  @override
  State<studentsPgDetailedView> createState() => _studentsPgDetailedViewState();
}

class _studentsPgDetailedViewState extends State<studentsPgDetailedView> {
  _callNumber() async {
    var number = '${widget.mobileNum}'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Divider(
                            thickness: 2,
                          ))),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                          // color: Colors.black
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.urls.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Container(
                                    width: 200,
                                    height: 550,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                            fit: BoxFit.fill,
                                            "${widget.urls[index]}")),
                                  )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("${widget.des}"),
                  ],
                ),
              ),
              Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Divider(
                        thickness: 2,
                      ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amenities",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    // SizedBox(height: 20,),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        itemCount: widget.amenities.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String image = '';
                          if (widget.amenities[index] == "Washing Machine") {
                            image = "assets/laundry.png";
                          } else if (widget.amenities[index] == "Parking") {
                            image = "assets/parked-car.png";
                          } else if (widget.amenities[index] == "Mess") {
                            image = "assets/dinner.png";
                          } else if (widget.amenities[index] == "Solar Water") {
                            image = "assets/heater.png";
                          }
                          return Row(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Image.asset(width: 40, image),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${widget.amenities[index]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Divider(
                        thickness: 2,
                      ))),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rooms Available",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    // SizedBox(height: 20,),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        itemCount: widget.rooms.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Type:- ${widget.rooms[index]["roomType"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Price:- ${widget.rooms[index]["price"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Occupants:- ${widget.rooms[index]["occupants"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
          
                  ],
                ),
              ),
              Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Divider(
                        thickness: 2,
                      ))),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Feedbacks",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    if(widget.feedbacks.length==0)

     Column(
       children: [
         SizedBox(height: 15,),
         Center(child: Text("No Feedbacks Received Yet..",style: TextStyle(
             fontWeight: FontWeight.bold,fontSize: 15,color: Colors.grey
         ),)),
       ],
     )  ,            // SizedBox(height: 20,),
                    if(widget.feedbacks.length!=0)
                    Container(
                      height: 100,
                      child: ListView.builder(
                        itemCount: widget.feedbacks.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.feedbacks[index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
          
                  ],
                ),
              ),
              Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Divider(
                        thickness: 2,
                      ))),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () async {
                          _callNumber();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.call,
                            size: 40,
                          ),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.black)),
                        onPressed: () async{
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          final CollectionReference ref = FirebaseFirestore.instance.collection("Owners");
                          final CollectionReference customer = FirebaseFirestore.instance.collection("Students");
                          QuerySnapshot customerSnap = await customer.where("userId",isEqualTo: "${_auth.currentUser!.uid}").get();
                          if(customerSnap.docs.isNotEmpty){
                            await customerSnap.docs.first.reference.update({
                              "isRequested":"true",
                              "ownerId":"${widget.ownerId}",
                              "propertyName":"${widget.name}",
                            });
                          }
                          // for owners collection =====
                          QuerySnapshot snap = await ref.where("userId",isEqualTo: "${widget.ownerId}").get();
                          if(snap.docs.isNotEmpty){
                            await snap.docs.first.reference.collection("Properties").where("propertyId",isEqualTo: "${widget.propertyId}").get().then((value) async{
                              final CollectionReference ref = FirebaseFirestore.instance.collection("Owners");
                              QuerySnapshot checker = await snap.docs.first.reference.collection("Requests").where("customerId",isEqualTo: "${_auth.currentUser!.uid}").get();
                        if(checker.docs.isNotEmpty){
          
                          await checker.docs.first.reference.update({
                            "customerId":"${_auth.currentUser!.uid}",
                            "propertyId":"${widget.propertyId}",
                            "status":"pending",
                            "propertyName":"${widget.name}",
                          });
                        }else{
          
                          await snap.docs.first.reference.collection("Requests").add({
                            "customerId":"${_auth.currentUser!.uid}",
                            "propertyId":"${widget.propertyId}",
                            "status":"pending",
                            "propertyName":"${widget.name}",
                          });
                        }
                            });
                          }else{
                            print("not foundddd");
                          }
          
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.green.shade100,
                                content: Container(
                                  width: 150,
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Your request for booking was proceed..",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(height:10 ,),
                                      Text(
                                        "Owner will contact you in shortley",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Book Now")),
                    InkWell(
                        onTap: () async {
                          final Uri smsLaunchUri = Uri(
                            scheme: 'sms',
                            path: '${widget.mobileNum}',
                            queryParameters: <String, String>{
                              'body':
                                  "Hello I checked your property listed on RoomEase.Property Name:- ${widget.name},I need more details.",
                            },
                          );
                          launchUrl(smsLaunchUri);
                          // }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.message,
                            size: 40,
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  launchWhatsappWithMobileNumber(mobileNumber, message) async {
    final url = "whatsapp://send?phone=+919503904362&text=${message}";
    if (await canLaunchUrl(Uri.parse(Uri.encodeFull(url)))) {
      await launchUrl(Uri.parse(Uri.encodeFull(url)));
    } else {
      throw 'Could not launch $url';
    }
  }
}
