import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ss/Modules/Students/profileStudents.dart';

import '../../Authentication/Proiled/profilePage.dart';
import '../Owners/detailedDescription.dart';
import '../help.dart';
import 'detailedViewStudents.dart';
import 'nearbyPlaces.dart';

class StudentsLanding extends StatefulWidget {
  const StudentsLanding({super.key});

  @override
  State<StudentsLanding> createState() => _StudentsLandingState();
}

class _StudentsLandingState extends State<StudentsLanding> {
  String userName = '';
  Future<void> fetchName() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference ref =
        FirebaseFirestore.instance.collection("Students");
    final QuerySnapshot snap =
        await ref.where("userId", isEqualTo: "${_auth.currentUser!.uid}").get();
    if (snap.docs.isNotEmpty) {
      String name = snap.docs.first["FirstName"];
      setState(() {
        userName = name;
      });
    }
  }

  String selectedCity = 'Select City';
  String selectedSubregion = 'Select Subregion';
  Map<String, List<String>> citySubregions = {
    'Select City': [],
    'Pune': [
      'Shivaji Nagar',
      'Bhosari',
      'Kothrud',
      'Wakad',
      'Hadapsar',
      'Baner',
      'Aundh',
      'Viman Nagar',
      'Kondhwa',
      'Kharadi'
    ],
    'Mumbai': ['Dadar', 'Bandra', 'Andheri'],
    'Delhi': ['Connaught Place', 'Karol Bagh', 'Saket'],
  };
  List<String> subregionsList(String city) {
    return citySubregions.containsKey(city) ? citySubregions[city]! : [];
  }

  List<Map<String, dynamic>> myProperties = [];

  bool isLoading = false;
  Future<void> fetchProperties(String city, String subregion) async {
    setState(() {
      isLoading = true;
    });
    this.myProperties.clear();
    final CollectionReference ownersRef =
        FirebaseFirestore.instance.collection("Owners");
    final QuerySnapshot ownersSnapshot = await ownersRef.get();
    for (QueryDocumentSnapshot ownerDoc in ownersSnapshot.docs) {
      final QuerySnapshot propertiesSnapshot = await ownerDoc.reference
          .collection("Properties")
          .where("City", isEqualTo: "${city}")
          .where("subregion", isEqualTo: "${subregion}")
          .get();

      for (QueryDocumentSnapshot propertyDoc in propertiesSnapshot.docs) {
        print(propertyDoc.data());
        Map<String, dynamic> propertyData =
            propertyDoc.data() as Map<String, dynamic>;
        myProperties.add(propertyData);
      }

      // print(puneProperties[0]);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    List<String> subregions = subregionsList(selectedCity);
    return isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: ListView(children: [
              SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hi,",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          "${userName}",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(

                              "Select your City and start exploring PG's near you...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,color: Colors.green,
                              ))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: selectedCity,
                        items: citySubregions.keys.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedCity = value ?? 'Select City';
                            selectedSubregion =
                                'Select Subregion'; // Reset subregion dropdown
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    if (subregions.isNotEmpty)
                      Container(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          value: selectedSubregion,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Select Subregion',
                              child: Text('Select Subregion'),
                            ),
                            ...subregions.map((String subregion) {
                              return DropdownMenuItem<String>(
                                value: subregion,
                                child: Text(subregion),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedSubregion = value ?? 'Select Subregion';
                            });
                            fetchProperties(selectedCity, selectedSubregion);
                          },
                        ),
                      ),
                    if (myProperties.length == 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                              child: Text(
                            "Data not Available",
                            style: TextStyle(
                                color: Colors.red.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    if (myProperties.length != 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "We found Hostel's For you!",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: myProperties.length,
                              itemBuilder: (context, index) {
                                List<dynamic> urls =
                                    myProperties[index]["roomImages"];
                                List<dynamic> facilites =
                                    myProperties[index]["selectedFacilities"];
                                List<dynamic> roomType =
                                    myProperties[index]["selectedRoom"];
                                String mobileNum =
                                    myProperties[index]["mobileNum"];
                                String propertyId =
                                    myProperties[index]["propertyId"];
                                String ownerId = myProperties[index]["ownerId"];
                                List<dynamic> feedbacks =
                                    myProperties[index]["Feedbacks"] ?? [];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  studentsPgDetailedView(
                                                feedbacks: feedbacks,
                                                ownerId: ownerId,
                                                propertyId: propertyId,
                                                mobileNum: mobileNum,
                                                des:
                                                    "${myProperties[index]["description"]}",
                                                name:
                                                    "${myProperties[index]["propertyName"]}",
                                                amenities: facilites,
                                                rooms: roomType,
                                                urls: urls,
                                              ),
                                            ));
                                          },
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "${myProperties[index]["propertyName"]}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${myProperties[index]["City"]},",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "${myProperties[index]["subregion"]}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      child: Divider(
                                                        thickness: 2,
                                                      ))),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color:
                                                        Colors.grey.shade100),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      // border: Border.all(color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      // color: Colors.black
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: urls.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Center(
                                                                  child:
                                                                      Container(
                                                                width: 200,
                                                                height: 550,
                                                                child: ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    child: Image.network(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        "${urls[index]}")),
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
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    if (subregions.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Nearby Places",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Container(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subregions.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => NearbyPlaces(
                                        region: subregions[index],
                                        city: selectedCity,
                                      ),
                                    ));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.purple.shade100),
                                        width: 150,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                "${subregions[index]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 45,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.person),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.security_sharp, size: 45),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )),
            ]),
          );
  }
}
