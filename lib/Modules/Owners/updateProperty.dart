import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProperty extends StatefulWidget {
  List<dynamic> facilities = [];
  List<dynamic> typeOfRomm = [];
  // String selectedFacility = '';
   UpdateProperty({required this.facilities,required this.typeOfRomm,super.key});

  @override
  State<UpdateProperty> createState() => _UpdatePropertyState();
}

class _UpdatePropertyState extends State<UpdateProperty> {
  // List<dynamic> facilities = [];
  // List<dynamic> typeOfRomm = [];
  // String selectedFacility = '';
  TextEditingController propertyName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController descridption = TextEditingController();
  TextEditingController mobileNum = TextEditingController();


  // ==========to select the imaegs and uplaod those on firebas storahge/
  List<String> uploadedImageUrls = [];
  bool isUploadingImages = false;

  void setPreSelectedFacilities() {
    setState(() {
      selectedFacilities.forEach((facility) {
        if (!widget.facilities.contains(facility)) {
          widget.facilities.add(facility);
        }
      });
    });
  }

  void setPreSelectedRoomTypes() {
    setState(() {
      selectedRoom.forEach((roomType) {
        if (!widget.typeOfRomm.contains(roomType)) {
          widget.typeOfRomm.add(roomType);
        }
      });
    });
  }

  String selectedCity = 'Select City';
  String selectedSubregion = 'Select Subregion';
  Map<String, List<String>> citySubregions = {
    'Select City': [],
    'Pune': [
      'Shivaji Nagar', 'Bhosari', 'Kothrud', 'Wakad', 'Hadapsar',
      'Baner', 'Aundh', 'Viman Nagar', 'Kondhwa', 'Kharadi'
    ],
    'Mumbai': ['Dadar', 'Bandra', 'Andheri'],
    'Delhi': ['Connaught Place', 'Karol Bagh', 'Saket'],
  };

  List<String> subregionsList(String city) {
    return citySubregions.containsKey(city) ? citySubregions[city]! : [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchFacilites();
    setPreSelectedFacilities();
    setPreSelectedRoomTypes();
  }

  List<String> selectedFacilities = [];
  List<String> selectedRoom = [];
  Map<String, TextEditingController> roomPriceControllers = {};
  Map<String, TextEditingController> roomPeopleControllers = {};



  @override
  Widget build(BuildContext context) {
    List<String> subregions = subregionsList(selectedCity);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add New Property",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              SizedBox(height: 20),

              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: TextField(
                  controller: propertyName,
                  // controller: emailAddress,
                  decoration: InputDecoration(
                      label: Text("Property Name"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
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
                      selectedSubregion = 'Select Subregion'; // Reset subregion dropdown
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
                    },
                  ),
                ),
              SizedBox(height:15 ,),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: TextField(
                  controller: address,
                  // controller: emailAddress,
                  decoration: InputDecoration(
                      label: Text("Address"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: TextField(
                  controller: descridption,
                  maxLength: 250,
                  maxLines: 3,
                  // controller: emailAddress,
                  decoration: InputDecoration(
                      label: Text("Description"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: TextField(
                  controller: mobileNum,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      label: Text("Contact Details"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ExpansionTile(
                title: Text("Select Facilites"),
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: widget.facilities.map((facility) {
                      return Container(
                        width: 200,
                        // height: 50,
                        child: CheckboxListTile(
                          title: Text(facility.toString()),
                          value: selectedFacilities.contains(facility),
                          onChanged: (bool? value) {
                            setState(() {
                              if (!selectedFacilities.contains(facility)) {
                                selectedFacilities.add(
                                    facility); // Add facility if not already selected
                              } else {
                                selectedFacilities.remove(
                                    facility); // Remove facility if unselected
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ExpansionTile(
                title: Text("Room Type"),
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: widget.typeOfRomm.map((facility) {
                      return Container(
                        width: 200,
                        child: CheckboxListTile(
                          title: Text(facility),
                          value: selectedRoom.contains(facility),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                selectedRoom.add(facility);
                                roomPriceControllers[facility] =
                                    TextEditingController();
                                roomPeopleControllers[facility] =
                                    TextEditingController();
                              } else {
                                selectedRoom.remove(facility);
                                roomPriceControllers.remove(facility);
                                roomPeopleControllers.remove(facility);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  if (selectedRoom.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedRoom.map((selectedRoom) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Room Name: $selectedRoom',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: TextField(
                                controller: roomPriceControllers[selectedRoom],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Enter Price',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(20))),
                              ),
                            ),
                            SizedBox(height: 20),
                            if (selectedRoom != 'Single Sharing')
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextField(
                                  controller:
                                  roomPeopleControllers[selectedRoom],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText:
                                      'Enter Number of People Already Residing',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(20))),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // await uploadImages();
                    },
                    child: Text("Upload Images"),
                  ),
                  if (isUploadingImages == true)
                    Column(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        CircularProgressIndicator(),
                      ],
                    )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    displayPropertyDetails();
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> displayPropertyDetails() async{

    // Gather entered information
    String propertyNameValue = propertyName.text;
    String addressValue = address.text;
    String descriptionValue = descridption.text;
    String mobileNumValue = mobileNum.text;

    // Gather selected facilities and room details
    Map<String, dynamic> propertyDetails = {
      "propertyName": propertyNameValue,
      "address": addressValue,
      "description": descriptionValue,
      "mobileNum": mobileNumValue,
      "selectedFacilities": selectedFacilities,
      "selectedRoom": [],
      "roomImages": uploadedImageUrls,
      "City":selectedCity,
      "subregion":selectedSubregion,
    };

    for (String roomType in selectedRoom) {
      String price = roomPriceControllers[roomType]?.text ?? "";
      String occupants = roomPeopleControllers[roomType]?.text ?? "";
      propertyDetails["selectedRoom"].add({
        "roomType": roomType,
        "price": price,
        "occupants": occupants,
      });
    }

    // Print or process property details
    print("Property Details:");
    print(propertyDetails);
    try {

      final FirebaseAuth _auth = FirebaseAuth.instance;
      final CollectionReference ref = FirebaseFirestore.instance.collection("Owners");
      QuerySnapshot snapshot = await ref.where("userId",isEqualTo: "${_auth.currentUser!.uid}").get();
      if(snapshot.docs.isNotEmpty){
        await snapshot.docs.first.reference.collection("Properties").doc().set(propertyDetails);
        print("adde in properties collection");
      }else{
        print("error in adding the propertis");
      }
    }  catch (e) {
      print(e);
    }
  }
}
