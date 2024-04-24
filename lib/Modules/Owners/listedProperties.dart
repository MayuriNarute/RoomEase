import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ss/Modules/Owners/updateProperty.dart';

import 'detailedDescription.dart';

class ListedProperties extends StatefulWidget {
  const ListedProperties({super.key});

  @override
  State<ListedProperties> createState() => _ListedPropertiesState();
}

class _ListedPropertiesState extends State<ListedProperties> {
  List<Map<String,dynamic>> myProperties = [];
  bool isLaoding = false;
  Future<void> fetchMyProperties()async{
    setState(() {
      isLaoding = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference ref = FirebaseFirestore.instance.collection("Owners");
    final QuerySnapshot snapshot = await ref.where("userId",isEqualTo: "${_auth.currentUser!.uid}").get();
    if(snapshot.docs.isNotEmpty){
     final QuerySnapshot propertiesSnapshot =  await snapshot.docs.first.reference.collection("Properties").get();
     for(var docs in propertiesSnapshot.docs){
       Map<String,dynamic> myPropertyData = docs.data() as Map<String,dynamic>;
       this.myProperties.add(myPropertyData) ;
       print("this ${myPropertyData}");
     }
     setState(() {
       isLaoding = false;
     });
    }
  }
  Future<void> init()async{
    await fetchMyProperties();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLaoding?Center(child: CircularProgressIndicator()):RefreshIndicator(
        onRefresh: fetchMyProperties,
        child: ListView(
          children:[ SafeArea(
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("My  Apartments",style: TextStyle(
                        fontSize:25,fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  if(myProperties.length==0)
                    Center(
                      child: Text("Not Properties Found",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18
                      ),),
                    ),
                  Container(width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height-200,child: ListView.builder(itemCount: myProperties.length,itemBuilder: (context, index) {
                    List<dynamic> urls = myProperties[index]["roomImages"];
                    List<dynamic> facilites = myProperties[index]["selectedFacilities"];
                    List<dynamic>  roomType = myProperties[index]["selectedRoom"];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PgDetailedView(des:"${myProperties[index]["description"]}",name: "${myProperties[index]["propertyName"]}",amenities:facilites,rooms: roomType,urls:urls,),));
                          },
                          child: Column(
                            children: [

                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width-50,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                    Text("${myProperties[index]["propertyName"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
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
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
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
                    );
                  },),),
                ],
              ),
            ),
          )],
        ),
      ),
    );
  }
}
