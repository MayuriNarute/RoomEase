import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailedViewStudents.dart';

class NearbyPlaces extends StatefulWidget {
  String city='';
  String region = '';
   NearbyPlaces({required this.region,required this.city,super.key});

  @override
  State<NearbyPlaces> createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {
  List<Map<String,dynamic>> myProperties = [];

bool isLoading = false;
  Future<void> fetchProperties(String city,String subregion)async {
    setState(() {
      isLoading = true;
    });
    this.myProperties.clear();
    final CollectionReference ownersRef = FirebaseFirestore.instance.collection(
        "Owners");
    final QuerySnapshot ownersSnapshot = await ownersRef.get();
    for (QueryDocumentSnapshot ownerDoc in ownersSnapshot.docs) {
      final QuerySnapshot propertiesSnapshot = await ownerDoc.reference
          .collection("Properties").where("City", isEqualTo: "${city}").where("subregion",isEqualTo: "${subregion}").get();

      for (QueryDocumentSnapshot propertyDoc in propertiesSnapshot.docs) {
        print(propertyDoc.data());
        Map<String, dynamic> propertyData = propertyDoc.data() as Map<String, dynamic>;
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
    fetchProperties(widget.city,widget.region);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?Center(child: CircularProgressIndicator()):SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: [
              if(myProperties.length==0)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50,),
                      Center(child: Container(child: Text("No Hostels Found",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),))),
                    ],
                  ),
                ),
              if(myProperties.length!=0)
          
                Column(
                  children: [
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment: Alignment.centerLeft,child: Text("Hostels in ${widget.region}!",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 18),)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      )
                      ,width: MediaQuery.of(context).size.width,height:800,child: ListView.builder(scrollDirection: Axis.vertical,itemCount: myProperties.length,itemBuilder: (context, index) {
                      List<dynamic> urls = myProperties[index]["roomImages"];
                      List<dynamic> facilites = myProperties[index]["selectedFacilities"];
                      List<dynamic>  roomType = myProperties[index]["selectedRoom"];
                      String mobileNum = myProperties[index]["mobileNum"];
                      String ownerId = myProperties[index]["ownerId"];
                      String proertyId = myProperties[index]["propertyId"];
                      List<dynamic> feedbacks = myProperties[index]["Feedbacks"]  ?? [];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width-100,
                          height: 250,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
          
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => studentsPgDetailedView(feedbacks: feedbacks,ownerId: ownerId,propertyId: proertyId,mobileNum: mobileNum,des:"${myProperties[index]["description"]}",name: "${myProperties[index]["propertyName"]}",amenities:facilites,rooms: roomType,urls:urls,),));
                                },
                                child: Column(
                                  children: [
          
                                    Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width-50,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("${myProperties[index]["propertyName"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
                                          ),
                                          Row(
          
                                            children: [
                                              Text("${myProperties[index]["City"]},",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                                              SizedBox(width:10,),
                                              Text("${myProperties[index]["subregion"]}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                                            ],
                                          ),
                                        ],),
                                      ),
                                    ),

                                    Center(child: Container(width:  MediaQuery.of(context).size.width-50,child: Divider(thickness:2,))),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.grey.shade100
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width-50,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            // border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50),
                                            // color: Colors.black
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: urls.length,itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Center(child: Container(width:200,height:550,child:ClipRRect(borderRadius: BorderRadius.circular(25),child: Image.network(fit: BoxFit.fill,"${urls[index]}")),)),
          
                                                  SizedBox(width: 15,),
                                                ],
                                              );
                                            },),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
          
          
                            ],
                          ),
                        ),
                      );
                    },),),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
