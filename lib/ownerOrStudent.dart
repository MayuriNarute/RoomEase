import 'package:flutter/material.dart';
import 'package:ss/Authentication/Presentation/registerScreen.dart';

import 'Authentication/Proiled/profilePage.dart';
import 'Modules/collegeProfile.dart';

class ChooseOwnerOrStudent extends StatefulWidget {
  const ChooseOwnerOrStudent({super.key});

  @override
  State<ChooseOwnerOrStudent> createState() => _ChooseOwnerOrStudentState();
}

class _ChooseOwnerOrStudentState extends State<ChooseOwnerOrStudent> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Text("Select your Role",style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 25
          ),),
          Divider(

            color: Colors.purple.shade100,
            thickness: 5,
            endIndent: 15,
            indent: 15,
          ),
          // Image.asset("assets/gif1.gif")
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(selectedRole: "Owner"),));
                  },
                  child: Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.blwhick/
                  ),width: 150,child: Center(child: Column(
                    children: [
                      Image.asset("assets/landlord.png"),
                      SizedBox(height: 10,),
                      Text("Im a Owner",style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize:18,color: Colors.black
                      ),),
                    ],
                  )),),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(selectedRole: "Student"),));
                  },
                  child: Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                  ),width: 150,child: Center(child: Column(
                    children: [
                      Image.asset("assets/graduated.png"),
                      SizedBox(height: 10,),
                      Text("Im a Student",style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize:18,color: Colors.black
                      ),),
                    ],
                  )),),
                ),
              ],
            ),
          ),

        ],),
      ),
    );
  }
}
