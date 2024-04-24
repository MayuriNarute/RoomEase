import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ss/Modules/Admin/studentsVerification.dart';
import 'package:ss/Modules/Owners/OwnersLandingPage.dart';
import 'package:ss/Modules/Students/studentsLanding.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("RoomEase",style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize:35
                    ),),
                  ),
                ),

                SizedBox(height: 25,),
                Center(
                  child: Text("Enter your Login Credentilas",style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey
                  ),),
                ),
                SizedBox(height: 15,),
                // ===========login form===========
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                        label: Text("Email Address"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(

                    controller:password,
                    obscureText: true,
                    decoration: InputDecoration(

                        label: Text("Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                  ),
                ),
SizedBox(height: 20,),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: ElevatedButton(style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.black),
          foregroundColor: MaterialStatePropertyAll(Colors.white)
        ),onPressed: ()async{
          setState(() {
            isLoading=true;
          });
          final FirebaseAuth _auth = FirebaseAuth.instance;
          try {
            await _auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim()).then((value) async{
              final CollectionReference ref= FirebaseFirestore.instance.collection("Users");
              QuerySnapshot snap = await ref.where("userId",isEqualTo: "${_auth.currentUser!.uid}").get();
              print("role is ${snap.docs.first["role"]}");
              if(snap.docs.isNotEmpty){
                if(snap.docs.first["role"]=="Owner"){
                  setState(() {
                    isLoading=false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged In Successfully"),backgroundColor: Colors.green,));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OwnersLanding(),), (route) => false);
                }else  if(snap.docs.first["role"]=="Admin"){
                  setState(() {
                    isLoading=false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged In Successfully"),backgroundColor: Colors.green,));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StudentsVerification(),), (route) => false);
                }else{
                  setState(() {
                    isLoading=false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged In Successfully"),backgroundColor: Colors.green,));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StudentsLanding(),), (route) => false);
                }
              }else{
                setState(() {
                  isLoading=false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to Login")));
              }
            });
          }  catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Failed to Login")));
            setState(() {
              isLoading=false;
            });
          }
}, child: Text("Log In")),
      ),
      SizedBox(width: 15,),
      if(isLoading==true)
        CircularProgressIndicator(),
    ],
  ),
                Container(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User?"),
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(),), (route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Register",style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18
                        ),),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
